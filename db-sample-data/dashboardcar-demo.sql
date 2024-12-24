--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg110+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg110+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: artificialrecognition_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artificialrecognition_log (
    violation_id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    processorip character varying(45) NOT NULL,
    eventtype character varying(20) NOT NULL,
    licenseplate character varying(20) NOT NULL,
    processing_date date DEFAULT CURRENT_DATE NOT NULL,
    processing_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    CONSTRAINT artificialrecognitionlog_eventtype_check CHECK (((eventtype)::text = ANY (ARRAY[('讀取紀錄'::character varying)::text, ('修正紀錄'::character varying)::text])))
);


ALTER TABLE public.artificialrecognition_log OWNER TO postgres;

--
-- Name: artificialrecognitionlog_reportid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artificialrecognitionlog_reportid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artificialrecognitionlog_reportid_seq OWNER TO postgres;

--
-- Name: artificialrecognitionlog_reportid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artificialrecognitionlog_reportid_seq OWNED BY public.artificialrecognition_log.violation_id;


--
-- Name: fineprint_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fineprint_log (
    violation_id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    print_date date DEFAULT CURRENT_DATE NOT NULL,
    print_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    processorip character varying(45) NOT NULL,
    finedetails json NOT NULL,
    printimage bytea NOT NULL
);


ALTER TABLE public.fineprint_log OWNER TO postgres;

--
-- Name: fineprintlog_reportid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fineprintlog_reportid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fineprintlog_reportid_seq OWNER TO postgres;

--
-- Name: fineprintlog_reportid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fineprintlog_reportid_seq OWNED BY public.fineprint_log.violation_id;


--
-- Name: unrecognized; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unrecognized (
    violation_id integer NOT NULL
);


ALTER TABLE public.unrecognized OWNER TO postgres;

--
-- Name: license_plate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.license_plate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.license_plate_id_seq OWNER TO postgres;

--
-- Name: license_plate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.license_plate_id_seq OWNED BY public.unrecognized.violation_id;


--
-- Name: trafficviolation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trafficviolation (
    violation_id integer NOT NULL,
    photo_id character varying(20),
    location character varying(255),
    latitudelongitude character varying(50),
    violation_date date,
    violation_time time without time zone,
    device_id character varying(50),
    speed_limit integer,
    vehicle_speed integer,
    license_plate character varying(20),
    licenseplatereplydate date,
    licenseplatereplytime time without time zone,
    owner_name character varying(50),
    vehicletype character varying(50),
    owner_address character varying(255),
    vehiclestatuscode integer NOT NULL,
    recognize integer
);


ALTER TABLE public.trafficviolation OWNER TO postgres;

--
-- Name: trafficviolation_violation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trafficviolation_violation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trafficviolation_violation_id_seq OWNER TO postgres;

--
-- Name: trafficviolation_violation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trafficviolation_violation_id_seq OWNED BY public.trafficviolation.violation_id;


--
-- Name: vehicle_registration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_registration (
    license_plate character varying(20) NOT NULL,
    registered_color character varying(50) NOT NULL,
    registered_model character varying(100) NOT NULL,
    owner_address character varying(255) NOT NULL,
    owner_name character varying(100) NOT NULL
);


ALTER TABLE public.vehicle_registration OWNER TO postgres;

--
-- Name: violation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.violation (
    violation_id integer DEFAULT nextval('public.trafficviolation_violation_id_seq'::regclass) NOT NULL,
    violation_date date NOT NULL,
    violation_time time without time zone NOT NULL,
    location character varying(255) NOT NULL,
    photo_id character varying(20) NOT NULL,
    speed_limit integer NOT NULL,
    vehicle_speed integer NOT NULL,
    device_id character varying(20) NOT NULL,
    license_plate character varying(20),
    recognize integer
);
ALTER TABLE ONLY public.violation ALTER COLUMN license_plate SET STORAGE EXTERNAL;


ALTER TABLE public.violation OWNER TO postgres;

--
-- Name: artificialrecognition_log violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artificialrecognition_log ALTER COLUMN violation_id SET DEFAULT nextval('public.artificialrecognitionlog_reportid_seq'::regclass);


--
-- Name: fineprint_log violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fineprint_log ALTER COLUMN violation_id SET DEFAULT nextval('public.fineprintlog_reportid_seq'::regclass);


--
-- Name: trafficviolation violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trafficviolation ALTER COLUMN violation_id SET DEFAULT nextval('public.trafficviolation_violation_id_seq'::regclass);


--
-- Name: unrecognized violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unrecognized ALTER COLUMN violation_id SET DEFAULT nextval('public.license_plate_id_seq'::regclass);


--
-- Data for Name: artificialrecognition_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artificialrecognition_log (violation_id, employee_id, processorip, eventtype, licenseplate, processing_date, processing_time) FROM stdin;
\.


--
-- Data for Name: fineprint_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fineprint_log (violation_id, employee_id, print_date, print_time, processorip, finedetails, printimage) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: trafficviolation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trafficviolation (violation_id, photo_id, location, latitudelongitude, violation_date, violation_time, device_id, speed_limit, vehicle_speed, license_plate, licenseplatereplydate, licenseplatereplytime, owner_name, vehicletype, owner_address, vehiclestatuscode, recognize) FROM stdin;
1	photo1.jpg	臨江街觀光夜市	25.033964, 121.564468	2024-12-23	14:30:00	D001	50	80	ABC-1234	2024-12-24	10:00:00	王小明	小客車	台北市信義區松仁路100號	1	1
2	photo2.jpg	樹林秀泰影城	25.011004, 121.462788	2024-12-23	09:15:00	D002	40	70	DEF-5678	2024-12-24	12:00:00	陳大華	機車	新北市板橋區文化路50號	1	1
3	photo3.jpg	桃園市中壢圖書館	24.993628, 121.301506	2024-12-22	20:45:00	D003	30	55	GHI-9012	2024-12-24	14:30:00	林美惠	小貨車	桃園市中壢區中山路20號	1	2
4	photo4.jpg	秋紅谷景觀生態公園	24.163264, 120.642803	2024-12-21	14:20:00	D004	60	95	JKL-3456	2024-12-24	16:45:00	李志強	大客車	台中市西屯區台灣大道50號	1	2
5	photo5.jpg	高雄市政府衛生局	22.627278, 120.301435	2024-12-20	16:10:00	D005	70	120	MNO-7890	2024-12-24	18:15:00	張秀珍	小客車	高雄市苓雅區中正路100號	1	3
\.


--
-- Data for Name: unrecognized; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unrecognized (violation_id) FROM stdin;
3
4
2
\.


--
-- Data for Name: vehicle_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_registration (license_plate, registered_color, registered_model, owner_address, owner_name) FROM stdin;
ABC-1234	紅色	小客車	台北市信義區松仁路100號	王小明
DEF-5678	藍色	機車	新北市板橋區文化路50號	陳大華
GHI-9012	白色	小貨車	桃園市中壢區中山路20號	林美惠
JKL-3456	綠色	大客車	台中市西屯區台灣大道50號	李志強
MNO-7890	黑色	小客車	高雄市苓雅區中正路100號	張秀珍
\.


--
-- Data for Name: violation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.violation (violation_id, violation_date, violation_time, location, photo_id, speed_limit, vehicle_speed, device_id, license_plate, recognize) FROM stdin;
1	2024-12-23	14:30:00	臨江街觀光夜市	photo1.jpg	50	80	D001	ABC-1234	1
2	2024-12-23	09:15:00	樹林秀泰影城	photo2.jpg	40	70	D002	DEF-5678	1
3	2024-12-22	20:45:00	桃園市中壢圖書館	photo3.jpg	30	55	D003	GHI-9012	2
4	2024-12-21	14:20:00	秋紅谷景觀生態公園	photo4.jpg	60	95	D004	JKL-3456	2
5	2024-12-20	16:10:00	高雄市政府衛生局	photo5.jpg	70	120	D005	MNO-7890	3
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: artificialrecognitionlog_reportid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artificialrecognitionlog_reportid_seq', 1, false);


--
-- Name: fineprintlog_reportid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fineprintlog_reportid_seq', 1, false);


--
-- Name: license_plate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.license_plate_id_seq', 2, true);


--
-- Name: trafficviolation_violation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trafficviolation_violation_id_seq', 1, false);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: artificialrecognition_log artificialrecognitionlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artificialrecognition_log
    ADD CONSTRAINT artificialrecognitionlog_pkey PRIMARY KEY (violation_id);


--
-- Name: fineprint_log fineprintlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fineprint_log
    ADD CONSTRAINT fineprintlog_pkey PRIMARY KEY (violation_id);


--
-- Name: unrecognized license_plate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unrecognized
    ADD CONSTRAINT license_plate_pkey PRIMARY KEY (violation_id);


--
-- Name: trafficviolation trafficviolation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trafficviolation
    ADD CONSTRAINT trafficviolation_pkey PRIMARY KEY (violation_id);


--
-- Name: vehicle_registration vehicle_registration_license_plate_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_registration
    ADD CONSTRAINT vehicle_registration_license_plate_key UNIQUE (license_plate);


--
-- Name: vehicle_registration vehicle_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_registration
    ADD CONSTRAINT vehicle_registration_pkey PRIMARY KEY (license_plate);


--
-- Name: violation violation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violation
    ADD CONSTRAINT violation_pkey PRIMARY KEY (violation_id);


--
-- PostgreSQL database dump complete
--

