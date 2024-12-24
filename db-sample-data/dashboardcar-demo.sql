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
    CONSTRAINT artificialrecognitionlog_eventtype_check CHECK (((eventtype)::text = ANY ((ARRAY['讀取紀錄'::character varying, '修正紀錄'::character varying])::text[])))
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
    photo_id integer,
    location character varying(255),
    latitudelongitude character varying(50),
    violation_date date,
    violation_time time without time zone,
    device_id character varying(50),
    speed_limit integer,
    vehicle_speed integer,
    license_plate character varying(20),
    licenseplateerrorcode character varying(50),
    licenseplatereplydate date,
    licenseplatereplytime time without time zone,
    owner_name character varying(50),
    vehicletype character varying(50),
    owner_address character varying(255),
    vehiclestatuscode character varying(50)
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
    violation_id integer NOT NULL,
    violation_date date NOT NULL,
    violation_time time without time zone NOT NULL,
    location character varying(255) NOT NULL,
    photo_id integer NOT NULL,
    speed_limit integer NOT NULL,
    vehicle_speed integer NOT NULL,
    device_id integer NOT NULL,
    license_plate character varying(20),
    recognize boolean NOT NULL
);
ALTER TABLE ONLY public.violation ALTER COLUMN license_plate SET STORAGE EXTERNAL;


ALTER TABLE public.violation OWNER TO postgres;

--
-- Name: violation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.violation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.violation_id_seq OWNER TO postgres;

--
-- Name: violation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.violation_id_seq OWNED BY public.violation.violation_id;


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
-- Name: violation violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violation ALTER COLUMN violation_id SET DEFAULT nextval('public.violation_id_seq'::regclass);


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
-- Data for Name: trafficviolation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trafficviolation (violation_id, photo_id, location, latitudelongitude, violation_date, violation_time, device_id, speed_limit, vehicle_speed, license_plate, licenseplateerrorcode, licenseplatereplydate, licenseplatereplytime, owner_name, vehicletype, owner_address, vehiclestatuscode) FROM stdin;
\.


--
-- Data for Name: unrecognized; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unrecognized (violation_id) FROM stdin;
\.


--
-- Data for Name: vehicle_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_registration (license_plate, registered_color, registered_model, owner_address, owner_name) FROM stdin;
\.


--
-- Data for Name: violation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.violation (violation_id, violation_date, violation_time, location, photo_id, speed_limit, vehicle_speed, device_id, license_plate, recognize) FROM stdin;
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

SELECT pg_catalog.setval('public.license_plate_id_seq', 1, false);


--
-- Name: trafficviolation_violation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trafficviolation_violation_id_seq', 1, false);


--
-- Name: violation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.violation_id_seq', 1, false);


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

