--
-- PostgreSQL database dump
--

\restrict yKDS89PAYXUVzBzDxBgsHjQzzKgZjyxD8a4tggQpazr0t0AwH9YaPoNlHmxzdbd

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO user_guru;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    parent_id integer
);


ALTER TABLE public.categories OWNER TO user_guru;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: user_guru
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO user_guru;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_guru
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: category_closures; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.category_closures (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    depth integer NOT NULL
);


ALTER TABLE public.category_closures OWNER TO user_guru;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying
);


ALTER TABLE public.clients OWNER TO user_guru;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: user_guru
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO user_guru;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_guru
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price_at_order numeric(12,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO user_guru;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: user_guru
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO user_guru;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_guru
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    client_id integer NOT NULL,
    order_date timestamp with time zone DEFAULT now(),
    status character varying NOT NULL
);


ALTER TABLE public.orders OWNER TO user_guru;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: user_guru
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO user_guru;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_guru
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: user_guru
--

CREATE TABLE public.products (
    id integer NOT NULL,
    sku character varying,
    name character varying NOT NULL,
    category_id integer,
    quantity_available integer NOT NULL,
    price numeric(12,2) NOT NULL
);


ALTER TABLE public.products OWNER TO user_guru;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: user_guru
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO user_guru;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_guru
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.alembic_version (version_num) FROM stdin;
6e04f9591c47
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.categories (id, name, parent_id) FROM stdin;
1	Электроника	\N
2	Одежда	\N
3	Книги	\N
4	Товары для дома	\N
5	Спорт и отдых	\N
6	Красота и здоровье	\N
7	Автотовары	\N
8	Детские товары	\N
9	Компьютеры	1
10	Смартфоны	1
11	Телевизоры и аудио	1
12	Бытовая техника	1
13	Ноутбуки	9
14	Настольные компьютеры	9
15	Комплектующие	9
16	Периферия	9
17	Процессоры	15
18	Видеокарты	15
19	Память	15
20	Накопители	15
21	Мужская одежда	2
22	Женская одежда	2
23	Детская одежда	2
24	Рубашки	21
25	Брюки	21
26	Куртки	21
27	Обувь	21
28	Художественная литература	3
29	Техническая литература	3
30	Детские книги	3
31	Учебная литература	3
32	Романы	28
33	Детективы	28
34	Фэнтези	28
35	Научная фантастика	28
36	Мебель	4
37	Товары для кухни	4
38	Декор	4
39	Освещение	4
40	Фитнес	5
41	Туризм	5
42	Командные виды спорта	5
\.


--
-- Data for Name: category_closures; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.category_closures (ancestor_id, descendant_id, depth) FROM stdin;
1	1	0
2	2	0
3	3	0
4	4	0
5	5	0
6	6	0
7	7	0
8	8	0
9	9	0
1	9	1
10	10	0
1	10	1
11	11	0
1	11	1
12	12	0
1	12	1
13	13	0
9	13	1
1	13	2
14	14	0
9	14	1
1	14	2
15	15	0
9	15	1
1	15	2
16	16	0
9	16	1
1	16	2
17	17	0
15	17	1
9	17	2
1	17	3
18	18	0
15	18	1
9	18	2
1	18	3
19	19	0
15	19	1
9	19	2
1	19	3
20	20	0
15	20	1
9	20	2
1	20	3
21	21	0
2	21	1
22	22	0
2	22	1
23	23	0
2	23	1
24	24	0
21	24	1
2	24	2
25	25	0
21	25	1
2	25	2
26	26	0
21	26	1
2	26	2
27	27	0
21	27	1
2	27	2
28	28	0
3	28	1
29	29	0
3	29	1
30	30	0
3	30	1
31	31	0
3	31	1
32	32	0
28	32	1
3	32	2
33	33	0
28	33	1
3	33	2
34	34	0
28	34	1
3	34	2
35	35	0
28	35	1
3	35	2
36	36	0
4	36	1
37	37	0
4	37	1
38	38	0
4	38	1
39	39	0
4	39	1
40	40	0
5	40	1
41	41	0
5	41	1
42	42	0
5	42	1
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.clients (id, name, address) FROM stdin;
1	Иван Петров	г. Москва, ул. Ленина, д. 10, кв. 25
2	Мария Сидорова	г. Санкт-Петербург, Невский пр-т, д. 45, кв. 12
3	Алексей Козлов	г. Екатеринбург, ул. Мира, д. 33, кв. 7
4	Елена Васнецова	г. Новосибирск, ул. Кирова, д. 89, кв. 15
5	Дмитрий Орлов	г. Казань, ул. Баумана, д. 12, кв. 3
6	Ольга Новикова	г. Ростов-на-Дону, ул. Садовая, д. 5, кв. 8
7	Сергей Волков	г. Владивосток, ул. Светланская, д. 78, кв. 22
8	Анна Лебедева	г. Сочи, ул. Навагинская, д. 15, кв. 9
9	Павел Морозов	г. Калининград, ул. Театральная, д. 33, кв. 11
10	Юлия Зайцева	г. Уфа, ул. Октябрьской революции, д. 45, кв. 17
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.order_items (id, order_id, product_id, quantity, price_at_order) FROM stdin;
1	1	52	5	8172.00
2	1	17	4	60185.00
3	1	63	4	1088.00
4	1	65	4	1499.00
5	2	45	2	9696.00
6	2	54	2	1676.00
7	3	100	3	10952.00
8	3	20	3	192883.00
9	4	46	3	12566.00
10	4	66	5	1907.00
11	4	60	1	7592.00
12	4	12	5	227871.00
13	5	48	1	8708.00
14	5	52	3	8172.00
15	6	51	4	4369.00
16	6	17	5	60185.00
17	6	9	2	106162.00
18	6	77	5	2697.00
19	7	13	4	174833.00
20	7	59	1	5787.00
21	7	11	4	205157.00
22	8	78	5	802.00
23	9	13	5	174833.00
24	10	37	5	15271.00
25	10	38	1	11511.00
26	10	74	5	1327.00
27	10	78	2	802.00
28	11	90	1	7944.00
29	11	81	3	7451.00
30	11	37	4	15271.00
31	12	89	4	14264.00
32	12	68	4	1903.00
33	12	44	2	2841.00
34	12	79	2	1710.00
35	13	76	2	323.00
36	14	4	4	105372.00
37	14	89	3	14264.00
38	15	97	1	1182.00
39	15	4	2	105372.00
40	15	81	3	7451.00
41	15	26	4	77253.00
42	15	46	5	12566.00
43	16	87	1	23243.00
44	17	39	1	4210.00
45	18	10	2	21688.00
46	18	65	5	1499.00
47	18	97	3	1182.00
48	19	1	2	85221.00
49	19	75	2	2197.00
50	20	31	1	116842.00
51	20	95	2	4706.00
52	20	28	2	189282.00
53	20	81	5	7451.00
54	20	14	2	125386.00
55	21	79	2	1710.00
56	22	49	2	8347.00
57	22	31	3	116842.00
58	23	84	1	10725.00
59	23	56	5	9626.00
60	23	95	3	4706.00
61	24	75	3	2197.00
62	24	97	5	1182.00
63	24	2	4	101606.00
64	24	27	4	84201.00
65	24	21	1	54755.00
66	25	28	4	189282.00
67	26	27	1	84201.00
68	27	86	3	5153.00
69	27	49	1	8347.00
70	27	3	4	129228.00
71	27	71	5	1822.00
72	27	21	5	54755.00
73	1	1	1	85221.00
74	11	1	2	85221.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.orders (id, client_id, order_date, status) FROM stdin;
1	1	2025-10-19 23:12:31.911401+03	draft
2	1	2025-10-24 23:12:31.911439+03	completed
3	2	2025-08-08 23:12:31.911449+03	confirmed
4	3	2025-10-21 23:12:31.911458+03	cancelled
5	3	2025-10-15 23:12:31.911465+03	confirmed
6	3	2025-10-25 23:12:31.911471+03	confirmed
7	4	2025-10-08 23:12:31.911478+03	confirmed
8	4	2025-08-14 23:12:31.911483+03	cancelled
9	4	2025-09-15 23:12:31.911489+03	draft
10	4	2025-08-07 23:12:31.911495+03	confirmed
11	5	2025-08-17 23:12:31.911501+03	cancelled
12	5	2025-10-01 23:12:31.911507+03	draft
13	5	2025-08-26 23:12:31.911514+03	completed
14	6	2025-09-20 23:12:31.911521+03	draft
15	6	2025-08-08 23:12:31.911526+03	completed
16	6	2025-08-12 23:12:31.911532+03	draft
17	6	2025-08-04 23:12:31.911537+03	cancelled
18	7	2025-09-25 23:12:31.911543+03	completed
19	7	2025-08-07 23:12:31.911549+03	cancelled
20	8	2025-09-05 23:12:31.911554+03	draft
21	9	2025-09-18 23:12:31.91156+03	cancelled
22	9	2025-10-15 23:12:31.911565+03	confirmed
23	9	2025-08-29 23:12:31.911571+03	confirmed
24	10	2025-08-31 23:12:31.911578+03	draft
25	10	2025-10-18 23:12:31.911584+03	draft
26	10	2025-09-10 23:12:31.911589+03	confirmed
27	10	2025-08-11 23:12:31.911595+03	confirmed
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: user_guru
--

COPY public.products (id, sku, name, category_id, quantity_available, price) FROM stdin;
2	SM002	Samsung Galaxy S24	10	84	101606.00
3	SM003	Xiaomi Redmi Note 13	10	62	129228.00
4	SM004	Google Pixel 8	10	53	105372.00
5	SM005	OnePlus 12	10	34	86408.00
6	SM006	Huawei P60	10	96	140888.00
7	SM007	Realme GT 3	10	54	128429.00
8	SM008	Oppo Find X6	10	33	82271.00
9	SM009	Vivo X100	10	78	106162.00
10	SM010	Honor Magic 5	10	93	21688.00
11	LT011	MacBook Pro 16"	13	28	205157.00
12	LT012	Dell XPS 13	13	40	227871.00
13	LT013	Lenovo ThinkPad X1	13	38	174833.00
14	LT014	ASUS ROG Zephyrus	13	37	125386.00
15	LT015	HP Spectre x360	13	22	180301.00
16	LT016	Acer Swift 3	13	32	56481.00
17	LT017	MSI Prestige 14	13	24	60185.00
18	LT018	Razer Blade 15	13	41	90779.00
19	LT019	LG Gram 17	13	14	286916.00
20	LT020	Microsoft Surface Laptop 5	13	26	192883.00
21	CPU021	Intel Core i9-14900K	17	19	54755.00
22	CPU022	AMD Ryzen 9 7950X	17	29	52208.00
23	CPU023	Intel Core i7-14700K	17	23	29569.00
24	CPU024	AMD Ryzen 7 7800X3D	17	5	18142.00
25	CPU025	Intel Core i5-14600K	17	30	66440.00
26	CPU026	AMD Ryzen 5 7600X	17	30	77253.00
27	GPU027	NVIDIA RTX 4090	18	6	84201.00
28	GPU028	NVIDIA RTX 4080	18	16	189282.00
29	GPU029	AMD Radeon RX 7900 XTX	18	20	99297.00
30	GPU030	NVIDIA RTX 4070 Ti	18	16	150875.00
31	GPU031	AMD Radeon RX 7800 XT	18	13	116842.00
32	GPU032	NVIDIA RTX 4060 Ti	18	12	198511.00
33	RAM033	Оперативная память DDR5 11GB	19	34	4186.00
34	RAM034	Оперативная память DDR4 57GB	19	29	23055.00
35	RAM035	Оперативная память DDR4 56GB	19	56	18302.00
36	RAM036	Оперативная память DDR5 57GB	19	16	17249.00
37	RAM037	Оперативная память DDR4 56GB	19	30	15271.00
38	RAM038	Оперативная память DDR4 43GB	19	24	11511.00
39	RAM039	Оперативная память DDR4 55GB	19	31	4210.00
40	RAM040	Оперативная память DDR5 10GB	19	54	16192.00
41	SSD041	SSD накопитель 766GB NVMe	20	33	9749.00
42	SSD042	SSD накопитель 658GB NVMe	20	24	4937.00
43	SSD043	SSD накопитель 641GB SATA	20	28	8482.00
44	SSD044	SSD накопитель 266GB NVMe	20	32	2841.00
45	SSD045	SSD накопитель 1346GB SATA	20	16	9696.00
46	SSD046	SSD накопитель 1466GB SATA	20	31	12566.00
47	SSD047	SSD накопитель 889GB NVMe	20	22	8340.00
48	SSD048	SSD накопитель 292GB SATA	20	37	8708.00
49	MEN049	Рубашка классическая	24	91	8347.00
50	MEN050	Рубашка офисная	24	170	8008.00
51	MEN051	Рубашка повседневная	24	177	4369.00
52	MEN052	Брюки спортивные	25	51	8172.00
53	MEN053	Брюки спортивные	25	175	1691.00
54	MEN054	Брюки классические	25	108	1676.00
55	MEN055	Куртка зимняя	26	127	5032.00
56	MEN056	Куртка кожаная	26	133	9626.00
57	MEN057	Куртка демисезонная	26	90	8457.00
58	MEN058	Обувь ботинки	27	117	4278.00
59	MEN059	Обувь ботинки	27	186	5787.00
60	MEN060	Обувь кроссовки	27	102	7592.00
61	BOOK061	Роман 'Мастер и Маргарита'	32	209	1017.00
62	BOOK062	Роман 'Мастер и Маргарита'	32	327	2850.00
63	BOOK063	Роман 'Анна Каренина'	32	118	1088.00
64	BOOK064	Роман 'Анна Каренина'	32	165	2682.00
65	BOOK065	Детектив 'Убийство в Восточном экспрессе'	33	421	1499.00
66	BOOK066	Детектив 'Парфюмер'	33	498	1907.00
67	BOOK067	Детектив 'Десять негритят'	33	447	2694.00
68	BOOK068	Детектив 'Убийство в Восточном экспрессе'	33	252	1903.00
69	BOOK069	Фэнтези 'Ведьмак'	34	397	1457.00
70	BOOK070	Фэнтези 'Игра престолов'	34	321	851.00
71	BOOK071	Фэнтези 'Властелин колец'	34	367	1822.00
72	BOOK072	Фэнтези 'Гарри Поттер'	34	459	2325.00
73	BOOK073	Научная фантастика 'Нейромант'	35	421	2761.00
74	BOOK074	Научная фантастика 'Нейромант'	35	247	1327.00
75	BOOK075	Научная фантастика '451° по Фаренгейту'	35	157	2197.00
76	BOOK076	Научная фантастика 'Основание'	35	232	323.00
77	BOOK077	Техническая книга 'Грокаем алгоритмы'	29	207	2697.00
78	BOOK078	Техническая книга 'Python для начинающих'	29	494	802.00
79	BOOK079	Техническая книга 'Python для начинающих'	29	125	1710.00
80	BOOK080	Техническая книга 'Python для начинающих'	29	432	2004.00
81	HOME081	Мебель диван	36	63	7451.00
82	HOME082	Мебель диван	36	86	20248.00
83	HOME083	Мебель стул	36	24	9192.00
84	HOME084	Мебель стол	36	25	10725.00
85	HOME085	Кухонный тостер	37	29	22568.00
86	HOME086	Кухонный тостер	37	61	5153.00
87	HOME087	Кухонный миксер	37	99	23243.00
88	HOME088	Декор зеркало	38	70	7576.00
1	SM001	iPhone 15 Pro	10	46	85221.00
89	HOME089	Декор светильник	38	45	14264.00
90	HOME090	Декор зеркало	38	61	7944.00
91	SPT091	Спортивный тренажер теннисный	40	46	2265.00
92	SPT092	Спортивный инвентарь боксерский	40	107	7941.00
93	SPT093	Спортивный тренажер футбольный	40	32	1562.00
94	SPT094	Спортивный инвентарь футбольный	40	141	6612.00
95	SPT095	Спортивный мяч баскетбольный	40	33	4706.00
96	SPT096	Спортивный мяч боксерский	40	72	5145.00
97	SPT097	Спортивный снаряд боксерский	40	41	1182.00
98	SPT098	Спортивный мяч футбольный	40	30	13740.00
99	SPT099	Спортивный снаряд футбольный	40	130	3705.00
100	SPT100	Спортивный снаряд теннисный	40	76	10952.00
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_guru
--

SELECT pg_catalog.setval('public.categories_id_seq', 42, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_guru
--

SELECT pg_catalog.setval('public.clients_id_seq', 10, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_guru
--

SELECT pg_catalog.setval('public.order_items_id_seq', 74, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_guru
--

SELECT pg_catalog.setval('public.orders_id_seq', 27, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user_guru
--

SELECT pg_catalog.setval('public.products_id_seq', 100, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: category_closures category_closures_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.category_closures
    ADD CONSTRAINT category_closures_pkey PRIMARY KEY (ancestor_id, descendant_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: order_items uix_order_product; Type: CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT uix_order_product UNIQUE (order_id, product_id);


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: category_closures category_closures_ancestor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.category_closures
    ADD CONSTRAINT category_closures_ancestor_id_fkey FOREIGN KEY (ancestor_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: category_closures category_closures_descendant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.category_closures
    ADD CONSTRAINT category_closures_descendant_id_fkey FOREIGN KEY (descendant_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_guru
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- PostgreSQL database dump complete
--

\unrestrict yKDS89PAYXUVzBzDxBgsHjQzzKgZjyxD8a4tggQpazr0t0AwH9YaPoNlHmxzdbd

