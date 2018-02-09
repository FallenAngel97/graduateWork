--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: angel
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO angel;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: angel
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO angel;

--
-- Name: single_todos; Type: TABLE; Schema: public; Owner: angel
--

CREATE TABLE single_todos (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expires_date character varying
);


ALTER TABLE single_todos OWNER TO angel;

--
-- Name: single_todos_id_seq; Type: SEQUENCE; Schema: public; Owner: angel
--

CREATE SEQUENCE single_todos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE single_todos_id_seq OWNER TO angel;

--
-- Name: single_todos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: angel
--

ALTER SEQUENCE single_todos_id_seq OWNED BY single_todos.id;


--
-- Name: single_todos id; Type: DEFAULT; Schema: public; Owner: angel
--

ALTER TABLE ONLY single_todos ALTER COLUMN id SET DEFAULT nextval('single_todos_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: angel
--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	default_env	2018-01-23 19:00:53.640308	2018-01-23 19:00:53.640308
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: angel
--

COPY schema_migrations (version) FROM stdin;
20180121090616
20171027190028
\.


--
-- Data for Name: single_todos; Type: TABLE DATA; Schema: public; Owner: angel
--

COPY single_todos (id, title, created_at, updated_at, expires_date) FROM stdin;
1	Feed the cat	2018-01-23 19:01:16.23621	2018-01-23 19:01:16.23621	16:20
2	Design new interface	2018-01-23 19:01:24.443597	2018-01-23 19:01:24.443597	12:15
3	Update the source code	2018-01-23 19:19:36.226637	2018-01-23 19:19:36.226637	13:45
\.


--
-- Name: single_todos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: angel
--

SELECT pg_catalog.setval('single_todos_id_seq', 3, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: angel
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: angel
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: single_todos single_todos_pkey; Type: CONSTRAINT; Schema: public; Owner: angel
--

ALTER TABLE ONLY single_todos
    ADD CONSTRAINT single_todos_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

