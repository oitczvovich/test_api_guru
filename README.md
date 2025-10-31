Ответы к ТЗ в файле answer_1_2.md


# FastAPI Order API - тестовое задание

## Описание проекта

REST API для управления заказами и товарами.
Реализована бизнес-логика добавления товара в заказ с проверкой остатков на складе и блокировками строк для конкурентного доступа.
Структура приложения построена по принципу **MVC (Controller–Service–Repository)**.

---

## Основной стек

* Python 3.12
* FastAPI
* SQLAlchemy 2.0 (async)
* Alembic - миграции БД
* PostgreSQL 17
* Docker / Docker Compose
* PgAdmin 4 - для визуального управления БД
* UV - для работы с переменым окружением

---

## Архитектура проекта

```
src/
├── api/                # FastAPI роуты (уровень API)
│   └── v1/orders.py
├── controllers/        # Контроллеры: принимают запросы, обрабатывают исключения
├── services/           # Сервисный слой: бизнес-логика
├── repositories/       # Репозитории: работа с БД
├── models/             # ORM-модели SQLAlchemy
├── schemas/            # Pydantic-схемы валидации
├── configs/            # Настройки, БД, логирование
└── main.py             # Точка входа FastAPI
```

---

## Основной endpoint

### POST /orders/{order_id}/items

Добавить товар в заказ.
Если товар уже присутствует - увеличивает количество.
Если на складе не хватает - возвращает ошибку.

#### Пример запроса:

```json
{
  "product_id": 15,
  "quantity": 2
}
```

#### Пример ответа:

| Код | Описание                  | Пример                                                                                    |
| --- | ------------------------- | ----------------------------------------------------------------------------------------- |
| 200 | Успешно                   | `{ "status": "success", "order_id": 1, "product_id": 15, "added": 2, "new_quantity": 5 }` |
| 400 | Недостаточно товара       | `{ "detail": "Недостаточно товара на складе. Доступно: 1, требуется: 3" }`                |
| 404 | Товар или заказ не найден | `{ "detail": "Order not found" }`                                                         |
| 500 | Ошибка сервера            | `{ "detail": "Ошибка базы данных: ..." }`                                                 |

---

## Разворачивание проекта

### 1. Скачай проект 
```bash 
git clone https://github.com/oitczvovich/test_api_guru
``` 

### 2. Создать файл `.env` в корне проекта

```bash
POSTGRES_USER=app_user
POSTGRES_PASSWORD=app_pass
POSTGRES_DB=shop
POSTGRES_PORT=5432
PGADMIN_EMAIL=admin@example.com
PGADMIN_PASSWORD=admin
PGADMIN_PORT=5050
APP_PORT=8000
DEBUG=true
TZ=Europe/Moscow
```

---

### 3. Запуск через Docker Compose

```bash
docker compose up -d --build
```

После первого запуска:

* PostgreSQL создаёт базу `shop` и автоматически импортирует тестовые данные из `postgres/init.sql`.
* PgAdmin доступен по адресу [http://localhost:5050](http://localhost:5050).
* FastAPI — [http://localhost:8000/docs](http://localhost:8000/docs).

---

### 4. Запуск вручную
При условии, что БД развернута.
Если проект разворачивается вручную (без Docker), необходимо применить миграции:

#### Запуск переменного окружения 

Установка UV 
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
Установка зависимостей 

```bash
uv sync 
```

#### Создание таблиц

```bash
alembic upgrade head
```

#### Генерация новой миграции при изменении моделей

```bash
alembic revision --autogenerate -m "added new field"
```

#### Применение всех миграций

```bash
alembic upgrade head
```

Alembic использует настройки подключения из `src/configs/settings.py`.
Переменные окружения те же, что и в `.env`.

---

#### Запускаем приложение 
```
# Переходим в папку с приложением 
cd src/
# Запускаем приложение 
uv run uvicorn main:app  --host 0.0.0.0 --port 8000
```

#### Приложение доступно 
* FastAPI — [http://localhost:8000/docs](http://localhost:8000/docs).

## Полезные команды

**Проверить состояние контейнеров**

```bash
docker compose ps
```

**Зайти внутрь контейнера Postgres**

```bash
docker exec -it postgres_db psql -U app_user -d shop
```

**Пересоздать БД с нуля**

```bash
docker compose down -v
docker compose up -d --build
```

---

## Тестовые данные

При первом запуске `docker compose up` выполняется скрипт:

```
postgres/init.sql
```

Он создаёт таблицы и наполняет базу тестовыми категориями, товарами, клиентами и заказами.

Если нужно сбросить базу и снова импортировать тестовые данные - удали volume:

```bash
docker compose down -v
docker compose up -d --build
```

---

## Автор

**Владимир Скалацкий**
[skalackii@yandex.ru](mailto:skalackii@yandex.ru)
<br>Версия проекта: `0.1.0`

