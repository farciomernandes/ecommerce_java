--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.0

-- Started on 2025-03-16 20:21:49

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 259 (class 1255 OID 49994)
-- Name: validatepeoplekey(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.validatepeoplekey() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    existe INTEGER;
BEGIN
    -- Verifica se o ID existe na tabela individual_person
    existe = (SELECT COUNT(1) FROM individual_person WHERE id = NEW.people_id);

    -- Se não encontrou na tabela individual_person, verifica na juridical_person
    IF (existe <= 0) THEN
        existe = (SELECT COUNT(1) FROM juridical_person WHERE id = NEW.people_id);

        -- Se não encontrar em nenhuma das tabelas, gera um erro
        IF (existe <= 0) THEN
            RAISE EXCEPTION 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        END IF;
    END IF;

    -- Retorna a nova linha
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validatepeoplekey() OWNER TO admin;

--
-- TOC entry 260 (class 1255 OID 50004)
-- Name: validatepeoplekey2(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.validatepeoplekey2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    existe INTEGER;
BEGIN
    existe = (SELECT COUNT(1) FROM individual_person WHERE id = NEW.supplier_id);

    IF (existe <= 0) THEN
        existe = (SELECT COUNT(1) FROM juridical_person WHERE id = NEW.supplier_id);

        IF (existe <= 0) THEN
            RAISE EXCEPTION 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validatepeoplekey2() OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 49722)
-- Name: access; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.access (
    id bigint NOT NULL,
    description character varying(255) NOT NULL
);


ALTER TABLE public.access OWNER TO admin;

--
-- TOC entry 238 (class 1259 OID 49727)
-- Name: account_payment; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_payment (
    id bigint NOT NULL,
    description character varying(255) NOT NULL,
    due_date date NOT NULL,
    payment_date date,
    status character varying(255) NOT NULL,
    total_value numeric(38,2) NOT NULL,
    people_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    CONSTRAINT account_payment_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING_PAYMENT'::character varying, 'OVERDUE'::character varying, 'OPEN'::character varying, 'RENEGOTIATED'::character varying, 'PAID'::character varying])::text[])))
);


ALTER TABLE public.account_payment OWNER TO admin;

--
-- TOC entry 239 (class 1259 OID 49735)
-- Name: account_receivable; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_receivable (
    id bigint NOT NULL,
    description character varying(255) NOT NULL,
    discount_value numeric(38,2),
    due_date date NOT NULL,
    payment_date date,
    status character varying(255) NOT NULL,
    total_value numeric(38,2) NOT NULL,
    people_id bigint NOT NULL,
    CONSTRAINT account_receivable_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING_PAYMENT'::character varying, 'OVERDUE'::character varying, 'OPEN'::character varying, 'PAID'::character varying])::text[])))
);


ALTER TABLE public.account_receivable OWNER TO admin;

--
-- TOC entry 240 (class 1259 OID 49743)
-- Name: address; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.address (
    id bigint NOT NULL,
    address_type character varying(255) NOT NULL,
    cep character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    complement character varying(255),
    neighborhood character varying(255) NOT NULL,
    number integer NOT NULL,
    street character varying(255) NOT NULL,
    uf character varying(255) NOT NULL,
    people_id bigint NOT NULL,
    CONSTRAINT address_address_type_check CHECK (((address_type)::text = ANY ((ARRAY['BILLING'::character varying, 'DELIVERY'::character varying])::text[])))
);


ALTER TABLE public.address OWNER TO admin;

--
-- TOC entry 241 (class 1259 OID 49751)
-- Name: brand_product; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.brand_product (
    id bigint NOT NULL,
    name_description character varying(255) NOT NULL
);


ALTER TABLE public.brand_product OWNER TO admin;

--
-- TOC entry 242 (class 1259 OID 49756)
-- Name: category_product; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.category_product (
    id bigint NOT NULL,
    name_description character varying(255) NOT NULL
);


ALTER TABLE public.category_product OWNER TO admin;

--
-- TOC entry 243 (class 1259 OID 49761)
-- Name: coupon_discount; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.coupon_discount (
    id bigint NOT NULL,
    code_description character varying(255) NOT NULL,
    discount_percentage numeric(38,2),
    discount_value numeric(38,2),
    expiration_date date
);


ALTER TABLE public.coupon_discount OWNER TO admin;

--
-- TOC entry 244 (class 1259 OID 49766)
-- Name: individual_person; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.individual_person (
    birthdate date,
    cpf character varying(255) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.individual_person OWNER TO admin;

--
-- TOC entry 245 (class 1259 OID 49771)
-- Name: juridical_person; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.juridical_person (
    category character varying(255),
    cnpj character varying(255) NOT NULL,
    fantasy_name character varying(255) NOT NULL,
    municipal_registration character varying(255),
    social_reason character varying(255) NOT NULL,
    state_registration character varying(255) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.juridical_person OWNER TO admin;

--
-- TOC entry 246 (class 1259 OID 49778)
-- Name: order_tracking_status; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.order_tracking_status (
    id bigint NOT NULL,
    city character varying(255),
    distribution_center character varying(255),
    state character varying(255),
    status character varying(255),
    store_sale_purchase_id bigint NOT NULL
);


ALTER TABLE public.order_tracking_status OWNER TO admin;

--
-- TOC entry 247 (class 1259 OID 49785)
-- Name: payment_method; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.payment_method (
    id bigint NOT NULL,
    description character varying(255)
);


ALTER TABLE public.payment_method OWNER TO admin;

--
-- TOC entry 248 (class 1259 OID 49790)
-- Name: people; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(255) NOT NULL
);


ALTER TABLE public.people OWNER TO admin;

--
-- TOC entry 249 (class 1259 OID 49797)
-- Name: product; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.product (
    id bigint NOT NULL,
    activated boolean,
    alert_qtd_stock boolean,
    depth double precision NOT NULL,
    description text NOT NULL,
    height double precision NOT NULL,
    link_youtube character varying(255),
    name character varying(255) NOT NULL,
    qtd_click integer,
    qtd_stock_alert integer,
    sale_price numeric(38,2) NOT NULL,
    stock integer NOT NULL,
    unit_type character varying(255) NOT NULL,
    weight double precision NOT NULL,
    width double precision NOT NULL
);


ALTER TABLE public.product OWNER TO admin;

--
-- TOC entry 250 (class 1259 OID 49804)
-- Name: product_image; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.product_image (
    id bigint NOT NULL,
    original_image text,
    thumbnail_image text,
    product_id bigint NOT NULL
);


ALTER TABLE public.product_image OWNER TO admin;

--
-- TOC entry 251 (class 1259 OID 49811)
-- Name: product_invoice_item; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.product_invoice_item (
    id bigint NOT NULL,
    quantity double precision NOT NULL,
    product_id bigint NOT NULL,
    purchase_invoice_id bigint NOT NULL
);


ALTER TABLE public.product_invoice_item OWNER TO admin;

--
-- TOC entry 252 (class 1259 OID 49816)
-- Name: product_review; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.product_review (
    id bigint NOT NULL,
    description character varying(255) NOT NULL,
    rating integer NOT NULL,
    people_id bigint NOT NULL,
    product_id bigint NOT NULL
);


ALTER TABLE public.product_review OWNER TO admin;

--
-- TOC entry 253 (class 1259 OID 49821)
-- Name: purchase_invoice; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.purchase_invoice (
    id bigint NOT NULL,
    description_note character varying(255),
    discount_amount numeric(38,2),
    icms_amount numeric(38,2) NOT NULL,
    invoice_number character varying(255) NOT NULL,
    invoice_series character varying(255) NOT NULL,
    purchase_date date NOT NULL,
    total_amount numeric(38,2) NOT NULL,
    account_payment_id bigint NOT NULL,
    people_id bigint NOT NULL
);


ALTER TABLE public.purchase_invoice OWNER TO admin;

--
-- TOC entry 254 (class 1259 OID 49828)
-- Name: sales_invoice; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.sales_invoice (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    pdf text NOT NULL,
    series character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    xml text NOT NULL,
    store_sale_purchase_id bigint NOT NULL
);


ALTER TABLE public.sales_invoice OWNER TO admin;

--
-- TOC entry 219 (class 1259 OID 24618)
-- Name: seq_access; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_access
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_access OWNER TO admin;

--
-- TOC entry 227 (class 1259 OID 24985)
-- Name: seq_account_payment; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_account_payment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_account_payment OWNER TO admin;

--
-- TOC entry 224 (class 1259 OID 24828)
-- Name: seq_account_receivable; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_account_receivable
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_account_receivable OWNER TO admin;

--
-- TOC entry 221 (class 1259 OID 24688)
-- Name: seq_address; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_address
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_address OWNER TO admin;

--
-- TOC entry 217 (class 1259 OID 24591)
-- Name: seq_brand_product; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_brand_product
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_brand_product OWNER TO admin;

--
-- TOC entry 218 (class 1259 OID 24602)
-- Name: seq_category_product; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_category_product
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_category_product OWNER TO admin;

--
-- TOC entry 228 (class 1259 OID 25001)
-- Name: seq_coupon_discount; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_coupon_discount
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_coupon_discount OWNER TO admin;

--
-- TOC entry 232 (class 1259 OID 40973)
-- Name: seq_invoice_item; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_invoice_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_invoice_item OWNER TO admin;

--
-- TOC entry 233 (class 1259 OID 40974)
-- Name: seq_order_tracking_status; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_order_tracking_status
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_order_tracking_status OWNER TO admin;

--
-- TOC entry 225 (class 1259 OID 24839)
-- Name: seq_payment_method; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_payment_method
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_payment_method OWNER TO admin;

--
-- TOC entry 220 (class 1259 OID 24633)
-- Name: seq_people; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_people
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_people OWNER TO admin;

--
-- TOC entry 229 (class 1259 OID 32776)
-- Name: seq_product; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_product
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_product OWNER TO admin;

--
-- TOC entry 230 (class 1259 OID 32784)
-- Name: seq_product_image; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_product_image
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_product_image OWNER TO admin;

--
-- TOC entry 236 (class 1259 OID 41455)
-- Name: seq_product_review; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_product_review
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_product_review OWNER TO admin;

--
-- TOC entry 226 (class 1259 OID 24848)
-- Name: seq_purchase; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_purchase
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_purchase OWNER TO admin;

--
-- TOC entry 231 (class 1259 OID 32797)
-- Name: seq_purchase_invoice; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_purchase_invoice
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_purchase_invoice OWNER TO admin;

--
-- TOC entry 234 (class 1259 OID 40992)
-- Name: seq_sales_invoice; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_sales_invoice
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_sales_invoice OWNER TO admin;

--
-- TOC entry 235 (class 1259 OID 41121)
-- Name: seq_store_sale_purchase; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_store_sale_purchase
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_store_sale_purchase OWNER TO admin;

--
-- TOC entry 222 (class 1259 OID 24719)
-- Name: seq_user; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_user OWNER TO admin;

--
-- TOC entry 223 (class 1259 OID 24732)
-- Name: seq_users; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_users OWNER TO admin;

--
-- TOC entry 255 (class 1259 OID 49835)
-- Name: store_sale_item; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.store_sale_item (
    id bigint NOT NULL,
    quantity double precision NOT NULL,
    product_id bigint NOT NULL,
    store_sale_purchase_id bigint NOT NULL
);


ALTER TABLE public.store_sale_item OWNER TO admin;

--
-- TOC entry 256 (class 1259 OID 49840)
-- Name: store_sale_purchase; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.store_sale_purchase (
    id bigint NOT NULL,
    delivery_date date,
    discount_value numeric(38,2),
    receive_day integer NOT NULL,
    sale_date date,
    shipping_value numeric(38,2) NOT NULL,
    total_value numeric(38,2) NOT NULL,
    billing_address_id bigint NOT NULL,
    coupon_discount_id bigint,
    people_id bigint NOT NULL,
    address_delivery_id bigint NOT NULL,
    payment_method_id bigint NOT NULL,
    sales_invoice_id bigint NOT NULL
);


ALTER TABLE public.store_sale_purchase OWNER TO admin;

--
-- TOC entry 257 (class 1259 OID 49845)
-- Name: user_access; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_access (
    users_id bigint NOT NULL,
    access_id bigint NOT NULL
);


ALTER TABLE public.user_access OWNER TO admin;

--
-- TOC entry 258 (class 1259 OID 49848)
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    actual_date_password date NOT NULL,
    login character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    people_id bigint NOT NULL
);


ALTER TABLE public.users OWNER TO admin;

--
-- TOC entry 3571 (class 0 OID 49722)
-- Dependencies: 237
-- Data for Name: access; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3572 (class 0 OID 49727)
-- Dependencies: 238
-- Data for Name: account_payment; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3573 (class 0 OID 49735)
-- Dependencies: 239
-- Data for Name: account_receivable; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3574 (class 0 OID 49743)
-- Dependencies: 240
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3575 (class 0 OID 49751)
-- Dependencies: 241
-- Data for Name: brand_product; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3576 (class 0 OID 49756)
-- Dependencies: 242
-- Data for Name: category_product; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3577 (class 0 OID 49761)
-- Dependencies: 243
-- Data for Name: coupon_discount; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3578 (class 0 OID 49766)
-- Dependencies: 244
-- Data for Name: individual_person; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3579 (class 0 OID 49771)
-- Dependencies: 245
-- Data for Name: juridical_person; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3580 (class 0 OID 49778)
-- Dependencies: 246
-- Data for Name: order_tracking_status; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3581 (class 0 OID 49785)
-- Dependencies: 247
-- Data for Name: payment_method; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3582 (class 0 OID 49790)
-- Dependencies: 248
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3583 (class 0 OID 49797)
-- Dependencies: 249
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3584 (class 0 OID 49804)
-- Dependencies: 250
-- Data for Name: product_image; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3585 (class 0 OID 49811)
-- Dependencies: 251
-- Data for Name: product_invoice_item; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3586 (class 0 OID 49816)
-- Dependencies: 252
-- Data for Name: product_review; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3587 (class 0 OID 49821)
-- Dependencies: 253
-- Data for Name: purchase_invoice; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3588 (class 0 OID 49828)
-- Dependencies: 254
-- Data for Name: sales_invoice; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3589 (class 0 OID 49835)
-- Dependencies: 255
-- Data for Name: store_sale_item; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3590 (class 0 OID 49840)
-- Dependencies: 256
-- Data for Name: store_sale_purchase; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3591 (class 0 OID 49845)
-- Dependencies: 257
-- Data for Name: user_access; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3592 (class 0 OID 49848)
-- Dependencies: 258
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--



--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 219
-- Name: seq_access; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_access', 1, false);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 227
-- Name: seq_account_payment; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_account_payment', 1, false);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 224
-- Name: seq_account_receivable; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_account_receivable', 1, false);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 221
-- Name: seq_address; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_address', 1, false);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 217
-- Name: seq_brand_product; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_brand_product', 1, false);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 218
-- Name: seq_category_product; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_category_product', 1, false);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 228
-- Name: seq_coupon_discount; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_coupon_discount', 1, false);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 232
-- Name: seq_invoice_item; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_invoice_item', 1, false);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 233
-- Name: seq_order_tracking_status; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_order_tracking_status', 1, false);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 225
-- Name: seq_payment_method; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_payment_method', 1, false);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 220
-- Name: seq_people; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_people', 1, false);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 229
-- Name: seq_product; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_product', 1, false);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 230
-- Name: seq_product_image; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_product_image', 1, false);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 236
-- Name: seq_product_review; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_product_review', 1, false);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 226
-- Name: seq_purchase; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_purchase', 1, false);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 231
-- Name: seq_purchase_invoice; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_purchase_invoice', 1, false);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 234
-- Name: seq_sales_invoice; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_sales_invoice', 1, false);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 235
-- Name: seq_store_sale_purchase; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_store_sale_purchase', 1, false);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 222
-- Name: seq_user; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_user', 1, false);


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 223
-- Name: seq_users; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_users', 1, false);


--
-- TOC entry 3319 (class 2606 OID 49726)
-- Name: access access_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.access
    ADD CONSTRAINT access_pkey PRIMARY KEY (id);


--
-- TOC entry 3321 (class 2606 OID 49734)
-- Name: account_payment account_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_payment
    ADD CONSTRAINT account_payment_pkey PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 49742)
-- Name: account_receivable account_receivable_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_receivable
    ADD CONSTRAINT account_receivable_pkey PRIMARY KEY (id);


--
-- TOC entry 3325 (class 2606 OID 49750)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 3327 (class 2606 OID 49755)
-- Name: brand_product brand_product_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.brand_product
    ADD CONSTRAINT brand_product_pkey PRIMARY KEY (id);


--
-- TOC entry 3329 (class 2606 OID 49760)
-- Name: category_product category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.category_product
    ADD CONSTRAINT category_product_pkey PRIMARY KEY (id);


--
-- TOC entry 3331 (class 2606 OID 49765)
-- Name: coupon_discount coupon_discount_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.coupon_discount
    ADD CONSTRAINT coupon_discount_pkey PRIMARY KEY (id);


--
-- TOC entry 3333 (class 2606 OID 49770)
-- Name: individual_person individual_person_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.individual_person
    ADD CONSTRAINT individual_person_pkey PRIMARY KEY (id);


--
-- TOC entry 3335 (class 2606 OID 49777)
-- Name: juridical_person juridical_person_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.juridical_person
    ADD CONSTRAINT juridical_person_pkey PRIMARY KEY (id);


--
-- TOC entry 3337 (class 2606 OID 49784)
-- Name: order_tracking_status order_tracking_status_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.order_tracking_status
    ADD CONSTRAINT order_tracking_status_pkey PRIMARY KEY (id);


--
-- TOC entry 3339 (class 2606 OID 49789)
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (id);


--
-- TOC entry 3341 (class 2606 OID 49796)
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- TOC entry 3345 (class 2606 OID 49810)
-- Name: product_image product_image_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_image
    ADD CONSTRAINT product_image_pkey PRIMARY KEY (id);


--
-- TOC entry 3347 (class 2606 OID 49815)
-- Name: product_invoice_item product_invoice_item_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_invoice_item
    ADD CONSTRAINT product_invoice_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3343 (class 2606 OID 49803)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 3349 (class 2606 OID 49820)
-- Name: product_review product_review_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_review
    ADD CONSTRAINT product_review_pkey PRIMARY KEY (id);


--
-- TOC entry 3351 (class 2606 OID 49827)
-- Name: purchase_invoice purchase_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.purchase_invoice
    ADD CONSTRAINT purchase_invoice_pkey PRIMARY KEY (id);


--
-- TOC entry 3353 (class 2606 OID 49834)
-- Name: sales_invoice sales_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sales_invoice
    ADD CONSTRAINT sales_invoice_pkey PRIMARY KEY (id);


--
-- TOC entry 3357 (class 2606 OID 49839)
-- Name: store_sale_item store_sale_item_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_item
    ADD CONSTRAINT store_sale_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3359 (class 2606 OID 49844)
-- Name: store_sale_purchase store_sale_purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT store_sale_purchase_pkey PRIMARY KEY (id);


--
-- TOC entry 3361 (class 2606 OID 49858)
-- Name: store_sale_purchase uk1c4cq2ki2ntvc67aymxa1qmy; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT uk1c4cq2ki2ntvc67aymxa1qmy UNIQUE (sales_invoice_id);


--
-- TOC entry 3355 (class 2606 OID 49856)
-- Name: sales_invoice ukhs0mtda8n3aaearj7etu78ay1; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sales_invoice
    ADD CONSTRAINT ukhs0mtda8n3aaearj7etu78ay1 UNIQUE (store_sale_purchase_id);


--
-- TOC entry 3363 (class 2606 OID 49862)
-- Name: user_access ukojlpsp4dq6pt966i85jb7i386; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_access
    ADD CONSTRAINT ukojlpsp4dq6pt966i85jb7i386 UNIQUE (access_id);


--
-- TOC entry 3365 (class 2606 OID 49860)
-- Name: user_access unique_access_user; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_access
    ADD CONSTRAINT unique_access_user UNIQUE (users_id, access_id);


--
-- TOC entry 3367 (class 2606 OID 49854)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3394 (class 2620 OID 50005)
-- Name: account_payment validatepeoplekeyaccountpaymentinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentinsert BEFORE INSERT ON public.account_payment FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey2();


--
-- TOC entry 3396 (class 2620 OID 50008)
-- Name: account_receivable validatepeoplekeyaccountpaymentinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentinsert BEFORE INSERT ON public.account_receivable FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3398 (class 2620 OID 50009)
-- Name: address validatepeoplekeyaccountpaymentinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentinsert BEFORE INSERT ON public.address FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3402 (class 2620 OID 50011)
-- Name: purchase_invoice validatepeoplekeyaccountpaymentinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentinsert BEFORE INSERT ON public.purchase_invoice FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3404 (class 2620 OID 50016)
-- Name: store_sale_purchase validatepeoplekeyaccountpaymentinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentinsert BEFORE INSERT ON public.store_sale_purchase FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3395 (class 2620 OID 50006)
-- Name: account_payment validatepeoplekeyaccountpaymentupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentupdate BEFORE UPDATE ON public.account_payment FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey2();


--
-- TOC entry 3397 (class 2620 OID 50007)
-- Name: account_receivable validatepeoplekeyaccountpaymentupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentupdate BEFORE UPDATE ON public.account_receivable FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3399 (class 2620 OID 50010)
-- Name: address validatepeoplekeyaccountpaymentupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentupdate BEFORE UPDATE ON public.address FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3403 (class 2620 OID 50012)
-- Name: purchase_invoice validatepeoplekeyaccountpaymentupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentupdate BEFORE UPDATE ON public.purchase_invoice FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3405 (class 2620 OID 50015)
-- Name: store_sale_purchase validatepeoplekeyaccountpaymentupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyaccountpaymentupdate BEFORE UPDATE ON public.store_sale_purchase FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3400 (class 2620 OID 50003)
-- Name: product_review validatepeoplekeyproductreviewinsert; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyproductreviewinsert BEFORE INSERT ON public.product_review FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3401 (class 2620 OID 50002)
-- Name: product_review validatepeoplekeyproductreviewupdate; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER validatepeoplekeyproductreviewupdate BEFORE UPDATE ON public.product_review FOR EACH ROW EXECUTE FUNCTION public.validatepeoplekey();


--
-- TOC entry 3391 (class 2606 OID 49978)
-- Name: user_access access_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_access
    ADD CONSTRAINT access_fk FOREIGN KEY (access_id) REFERENCES public.access(id);


--
-- TOC entry 3380 (class 2606 OID 49923)
-- Name: purchase_invoice account_payment_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.purchase_invoice
    ADD CONSTRAINT account_payment_fk FOREIGN KEY (account_payment_id) REFERENCES public.people(id);


--
-- TOC entry 3385 (class 2606 OID 49963)
-- Name: store_sale_purchase address_delivery_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT address_delivery_fk FOREIGN KEY (address_delivery_id) REFERENCES public.address(id);


--
-- TOC entry 3386 (class 2606 OID 49948)
-- Name: store_sale_purchase billing_address_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT billing_address_fk FOREIGN KEY (billing_address_id) REFERENCES public.address(id);


--
-- TOC entry 3387 (class 2606 OID 49953)
-- Name: store_sale_purchase coupon_discount_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT coupon_discount_fk FOREIGN KEY (coupon_discount_id) REFERENCES public.coupon_discount(id);


--
-- TOC entry 3373 (class 2606 OID 49888)
-- Name: juridical_person fk5lv9me7wmrfbey41q5ueck5kp; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.juridical_person
    ADD CONSTRAINT fk5lv9me7wmrfbey41q5ueck5kp FOREIGN KEY (id) REFERENCES public.people(id);


--
-- TOC entry 3372 (class 2606 OID 49883)
-- Name: individual_person fk6qnsx9fhv6ohseu76cwdp7kyy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.individual_person
    ADD CONSTRAINT fk6qnsx9fhv6ohseu76cwdp7kyy FOREIGN KEY (id) REFERENCES public.people(id);


--
-- TOC entry 3388 (class 2606 OID 49968)
-- Name: store_sale_purchase payment_method_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT payment_method_fk FOREIGN KEY (payment_method_id) REFERENCES public.payment_method(id);


--
-- TOC entry 3368 (class 2606 OID 49863)
-- Name: account_payment people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_payment
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3370 (class 2606 OID 49873)
-- Name: account_receivable people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_receivable
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3371 (class 2606 OID 49878)
-- Name: address people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3378 (class 2606 OID 49913)
-- Name: product_review people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_review
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3381 (class 2606 OID 49928)
-- Name: purchase_invoice people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.purchase_invoice
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3389 (class 2606 OID 49958)
-- Name: store_sale_purchase people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3393 (class 2606 OID 49988)
-- Name: users people_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT people_fk FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- TOC entry 3375 (class 2606 OID 49898)
-- Name: product_image product_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_image
    ADD CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- TOC entry 3376 (class 2606 OID 49903)
-- Name: product_invoice_item product_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_invoice_item
    ADD CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- TOC entry 3379 (class 2606 OID 49918)
-- Name: product_review product_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_review
    ADD CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- TOC entry 3383 (class 2606 OID 49938)
-- Name: store_sale_item product_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_item
    ADD CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- TOC entry 3377 (class 2606 OID 49908)
-- Name: product_invoice_item purchase_invoice_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.product_invoice_item
    ADD CONSTRAINT purchase_invoice_fk FOREIGN KEY (purchase_invoice_id) REFERENCES public.purchase_invoice(id);


--
-- TOC entry 3390 (class 2606 OID 49973)
-- Name: store_sale_purchase sales_invoice_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_purchase
    ADD CONSTRAINT sales_invoice_fk FOREIGN KEY (sales_invoice_id) REFERENCES public.sales_invoice(id);


--
-- TOC entry 3374 (class 2606 OID 49893)
-- Name: order_tracking_status store_sale_purchase_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.order_tracking_status
    ADD CONSTRAINT store_sale_purchase_fk FOREIGN KEY (store_sale_purchase_id) REFERENCES public.store_sale_purchase(id);


--
-- TOC entry 3382 (class 2606 OID 49933)
-- Name: sales_invoice store_sale_purchase_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sales_invoice
    ADD CONSTRAINT store_sale_purchase_fk FOREIGN KEY (store_sale_purchase_id) REFERENCES public.store_sale_purchase(id);


--
-- TOC entry 3384 (class 2606 OID 49943)
-- Name: store_sale_item store_sale_purchase_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.store_sale_item
    ADD CONSTRAINT store_sale_purchase_fk FOREIGN KEY (store_sale_purchase_id) REFERENCES public.store_sale_purchase(id);


--
-- TOC entry 3369 (class 2606 OID 49868)
-- Name: account_payment supplier_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_payment
    ADD CONSTRAINT supplier_fk FOREIGN KEY (supplier_id) REFERENCES public.people(id);


--
-- TOC entry 3392 (class 2606 OID 49983)
-- Name: user_access users_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_access
    ADD CONSTRAINT users_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


-- Completed on 2025-03-16 20:21:49

--
-- PostgreSQL database dump complete
--