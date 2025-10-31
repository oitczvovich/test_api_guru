Ниже собрана даталогическая схема (DDL для PostgreSQL), требуемые SQL-запросы (п.2) и готовый пример сервиса «Добавление товара в заказ» (п.3) на FastAPI + SQLAlchemy с комментариями. Компоненты самодостаточные — можно положить в Git и контейнеризовать.

---

# 1. Проект схемы БД (реляционная) — PostgreSQL

Подходы:

* Дерево категорий: используем **adjacency list** (parent_id) + **closure table** (`category_closure`) — это даёт быстрое получение всех предков/потомков и гибкость при неограниченной вложенности.
* Товар хранит текущее количество на складе и базовую цену; в заказе фиксируем `price_at_order`.
* Заказ состоит из `orders` + `order_items`.
* Клиенты — `clients`.

DDL (Postgres). Выполните как единый скрипт:

```sql
-- 1. SCHEMA DDL (PostgreSQL)

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id INT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- closure table for categories: ancestor-descendant relationships
CREATE TABLE category_closures (
    ancestor_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    descendant_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    depth INT NOT NULL, -- 0 = same node, 1 = child, ...
    PRIMARY KEY (ancestor_id, descendant_id)
);

CREATE INDEX idx_category_closure_desc ON category_closures(descendant_id);
CREATE INDEX idx_category_closure_anc ON category_closures(ancestor_id);
CREATE INDEX idx_category_parent ON categories(parent_id);

-- Товары (номенклатура)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku TEXT UNIQUE, -- optional
    name TEXT NOT NULL,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    quantity_available BIGINT NOT NULL DEFAULT 0, -- складской остаток (штук)
    price NUMERIC(12,2) NOT NULL, -- текущая цена
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
CREATE INDEX idx_products_category ON products(category_id);

-- Заказы
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
    status TEXT NOT NULL DEFAULT 'draft' -- draft, confirmed, cancelled, etc.
);

-- Позиции заказа
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity BIGINT NOT NULL CHECK (quantity > 0),
    price_at_order NUMERIC(12,2) NOT NULL, -- фиксируем цену на момент добавления
    UNIQUE(order_id, product_id) -- одна позиция продукта в заказе
);

-- Индексы для производительности
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_date ON orders(order_date);
```

Комментарий: closure table `category_closure` нужно поддерживать при вставке/перемещении категории. При создании категории вставляем строки (ancestor=новая, descendant=новая, depth=0) и копируем предков родителя. Пример поддержания ниже.

---

# Вспомогательные операции с категориями (пример реализации логики поддержания closure table)

```sql
-- вставка новой категории с указанием parent_id (p_parent_id может быть NULL)
-- pseudo: p_name, p_parent_id
WITH new_cat AS (
  INSERT INTO categories (name, parent_id) VALUES ('New Category', 3) RETURNING id
), nid AS (
  SELECT id FROM new_cat
)
-- 1) добавляем (self,self)
INSERT INTO category_closure (ancestor_id, descendant_id, depth)
SELECT id, id, 0 FROM new_cat;

-- 2) копируем всех предков родителя (если parent_id NOT NULL)
INSERT INTO category_closure (ancestor_id, descendant_id, depth)
SELECT anc.ancestor_id, nid.id, anc.depth + 1
FROM category_closure anc
JOIN categories p ON p.id = anc.descendant_id
JOIN nid ON true
WHERE p.id = 3; -- parent_id
```
(в реальном приложении это оформляется как транзакция/функция)

---

# 2. SQL-запросы

## 2.1 Получение суммы товаров, заказанных под каждого клиента

(результат: client_name, total_sum — сумма в валюте: сумма (quantity * price_at_order))

```sql
SELECT
  c.id AS client_id,
  c.name AS client_name,
  COALESCE(SUM(oi.quantity * oi.price_at_order), 0)::numeric(14,2) AS total_sum
FROM clients c
LEFT JOIN orders o ON o.client_id = c.id
LEFT JOIN order_items oi ON oi.order_id = o.id
-- можно фильтровать только подтверждённые заказы, если нужно:
-- AND o.status = 'confirmed'
GROUP BY c.id, c.name
ORDER BY total_sum DESC;
```

Комментарий: если ваша бизнес-логика учитывает только `confirmed` заказы — добавьте `WHERE o.status = 'confirmed'` или соответствующий JOIN с условием.

---

## 2.2 Найти количество дочерних элементов первого уровня для категорий номенклатуры

(т.е. посчитать для каждой категории количество прямых детей — `parent_id = this.id`)

```sql
SELECT
  parent.id AS category_id,
  parent.name AS category_name,
  COUNT(child.id) AS direct_children_count
FROM categories parent
LEFT JOIN categories child ON child.parent_id = parent.id
GROUP BY parent.id, parent.name
ORDER BY parent.name;
```

Если нужен только список категорий, у которых есть дети:

```sql
SELECT parent.id, parent.name, COUNT(child.id) AS direct_children_count
FROM categories parent
JOIN categories child ON child.parent_id = parent.id
GROUP BY parent.id, parent.name
HAVING COUNT(child.id) > 0;
```

---

## 2.3.1 View: «Топ-5 самых покупаемых товаров за последний месяц» (по кол-ву штук в заказах)

Предположим "последний месяц" — период `now() - interval '1 month'` до `now()`.

В отчёте: Наименование товара, Категория 1-го уровня, Общее количество проданных штук.

Пояснение: "Категория 1-го уровня" я трактую как **верхнеуровневая (root) категория**, то есть корневой предок (parent_id IS NULL) для категории товара. Если нужно `первый уровень под корнем`, напишите — дам альтернативный SQL.

SQL (view):

```sql
CREATE OR REPLACE VIEW vw_top5_last_month AS
SELECT
  p.id AS product_id,
  p.name AS product_name,
  root_cat.id AS root_category_id,
  root_cat.name AS root_category_name,
  SUM(oi.quantity)::bigint AS total_sold
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
-- берём заказы за последний месяц
WHERE o.order_date >= (now() - interval '1 month') AND o.order_date <= now()
-- находим корневого предка категории через closure table:
LEFT JOIN category_closure cc ON cc.descendant_id = p.category_id
LEFT JOIN categories root_cat ON root_cat.id = cc.ancestor_id AND root_cat.parent_id IS NULL
-- cc.depth при этом >= 0; для self row depth=0 root_cat будет NULL если продукт в не-root подкатегории —
-- поэтому выбираем ancestor с parent_id IS NULL -> корень
GROUP BY p.id, p.name, root_cat.id, root_cat.name
ORDER BY total_sold DESC
LIMIT 5;
```

Если вы хотите **категорию первого уровня относительно корня** (т.е. первую ветку под корнем, depth = (distance from root) = 1), тогда замените JOIN на:

```sql
-- Получить ancestor где ancestor.parent_id IS NULL (root) => потом найти descendant на depth = 1
-- Альтернативный вариант: найти ancestor с миним depth > 0 — но проще: выбрать ancestor с depth = (min depth where ancestor.parent_id IS NULL)...
```

(При необходимости дам точный SQL — сейчас включил вариант с **root**.)

---

## 2.3.2 Анализ и варианты оптимизации (производительность при росте данных — тысячи заказов в день)

Кратко — какие узкие места и как оптимизировать:

1. **Индексы**

   * `orders(order_date)`, `order_items(product_id)`, `order_items(order_id)` — уже добавлены.
   * Индекс комбинированный `order_items(product_id, order_id)` для быстрых выборок.
   * Индекс на `products(category_id)` — для связывания с категориями.

2. **Партиционирование**

   * Партиционировать таблицу `orders` (и, при необходимости, `order_items`) по `order_date` (range partition by month). Это ускорит сканирование за последний месяц и упростит удаление старых данных.

3. **Материализованные агрегаты**

   * Создать таблицу/материализованный view `daily_product_sales(product_id, day, qty)` и обновлять её по событию или батчом (nightly или streaming). Тогда топ-5 за месяц — это суммирование по 30 строк вместо миллионов order_items.
   * Можно иметь real-time счётчики (incremental update) при вставке order_items (триггер/worker).

4. **Денормализация**

   * В `order_items` фиксируем `price_at_order` (уже сделано).
   * Для ускорения отчётов можно сохранять `product_root_category_id` в `products` (или хранить в отдельной колонке) и периодически обновлять при изменениях иерархии — чтобы не делать join с closure в каждой аналитической выборке.

5. **Closure table vs Materialized path**

   * Closure table удобна для запросов «все предки/все потомки» и имеет индексы; но размер таблицы O(N^2) в худшем случае. Для огромных деревьев можно использовать materialized path (строка пути) с индексом GIST/BTREE на path, или ltree (Postgres extension) — ltree быстрый и экономный.
   * Рекомендация: если категории редко меняются, используйте **ltree** или **path string** + индекс; если нужно частые сложные запросы предков/потомков — закрытие (closure) с индексами.

6. **Кеширование + OLAP**

   * Отчёты агрегируются в отдельную OLAP базу (columnar) или реплика для аналитики.

7. **Транзакции и блокировки**

   * Минимизировать время транзакций при записи заказов; использовать оптимистичные подходы при учёте склада.
