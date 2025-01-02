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
-- Name: abandoned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abandoned (
    violation_id integer NOT NULL,
    location character varying(255) NOT NULL,
    violation_date date NOT NULL,
    violation_time time without time zone NOT NULL,
    device_id character varying(50) NOT NULL,
    speed_limit integer NOT NULL,
    vehicle_speed integer NOT NULL,
    license_plate character varying(20),
    licenseplatereplydate date NOT NULL,
    licenseplatereplytime time without time zone NOT NULL,
    vehicletype character varying(50),
    vehiclestatuscode integer NOT NULL,
    longitude double precision,
    latitude double precision,
    photo_id bytea,
    recongnize integer,
    reportreason character varying
);


ALTER TABLE public.abandoned OWNER TO postgres;

--
-- Name: abandoned_violation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.abandoned_violation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.abandoned_violation_id_seq OWNER TO postgres;

--
-- Name: abandoned_violation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.abandoned_violation_id_seq OWNED BY public.abandoned.violation_id;


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
-- Name: trafficviolation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trafficviolation (
    violation_id integer NOT NULL,
    location character varying(255) NOT NULL,
    violation_date date NOT NULL,
    violation_time time without time zone NOT NULL,
    device_id character varying(50) NOT NULL,
    speed_limit integer NOT NULL,
    vehicle_speed integer,
    license_plate character varying(20) NOT NULL,
    licenseplatereplydate date NOT NULL,
    licenseplatereplytime time without time zone NOT NULL,
    vehicletype character varying(50),
    vehiclestatuscode integer NOT NULL,
    longitude double precision NOT NULL,
    latitude double precision NOT NULL,
    photo_id bytea,
    recognize integer,
    license_plate2 character varying
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
    vehicletype character varying(100) NOT NULL,
    owner_address character varying(255) NOT NULL,
    owner_name character varying(100) NOT NULL,
    license_plate2 character varying DEFAULT 1 NOT NULL
);


ALTER TABLE public.vehicle_registration OWNER TO postgres;

--
-- Name: abandoned violation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abandoned ALTER COLUMN violation_id SET DEFAULT nextval('public.abandoned_violation_id_seq'::regclass);


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
-- Data for Name: abandoned; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abandoned (violation_id, location, violation_date, violation_time, device_id, speed_limit, vehicle_speed, license_plate, licenseplatereplydate, licenseplatereplytime, vehicletype, vehiclestatuscode, longitude, latitude, photo_id, recongnize, reportreason) FROM stdin;
\.


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

COPY public.trafficviolation (violation_id, location, violation_date, violation_time, device_id, speed_limit, vehicle_speed, license_plate, licenseplatereplydate, licenseplatereplytime, vehicletype, vehiclestatuscode, longitude, latitude, photo_id, recognize, license_plate2) FROM stdin;
1	北投區	2024-12-23	14:30:00	D001	50	80	ABC1234	2024-12-24	10:00:00	小客車	1	121.564468	25.033964	\\x	0	ABC-1234
2	士林區	2024-12-23	09:15:00	D002	40	70	DEF5678	2024-12-24	12:00:00	機車	1	121.462788	25.011004	\\x	0	DEF-5678
3	大同區	2024-12-22	20:45:00	D003	30	55	GHI9012	2024-12-24	14:30:00	小貨車	1	121.301506	24.993628	\\x	0	GHI-9012
4	中山區	2024-12-21	14:20:00	D004	60	95	JKL3456	2024-12-24	16:45:00	大客車	1	120.642803	24.163264	\\x	0	JKL-3456
6	內湖區	2024-12-19	08:45:00	D006	40	65	PQR2345	2024-12-20	09:00:00	小型車	1	120.311928	22.627334	\\x	0	PQR-2345
7	萬華區	2024-12-20	09:15:00	D007	50	75	STU6789	2024-12-21	09:30:00	大型車	2	121.538469	25.047767	\\x	0	STU-6789
8	中正區	2024-12-20	10:00:00	D008	60	80	VWX3456	2024-12-21	10:15:00	小型車	1	121.457956	25.016984	\\x	0	VWX-3456
9	大安區	2024-12-20	11:30:00	D009	50	70	YZA7890	2024-12-21	11:45:00	小型車	2	120.681226	24.146183	\\x	0	YZA-7890
10	信義區	2024-12-20	12:00:00	D010	40	60	BCD1234	2024-12-21	12:15:00	機車	1	120.195018	22.970689	\\x	0	BCD-1234
11	南港區	2024-12-20	12:30:00	D011	60	85	EFG5678	2024-12-21	12:45:00	小型車	1	120.297478	22.629298	\\x	0	EFG-5678
12	北投區	2024-12-20	13:00:00	D012	50	70	HIJ1234	2024-12-21	13:15:00	小型車	2	121.7411	25.126146	\\x	0	HIJ1-234
13	北投區	2024-12-20	14:00:00	D013	60	80	KLM4567	2024-12-21	14:15:00	大型車	1	121.223246	24.957099	\\x	0	KLM-4567
14	士林區	2024-12-20	15:00:00	D014	50	65	NOP8901	2024-12-21	15:15:00	小型車	1	120.976106	24.806877	\\x	0	NOP-8901
15	士林區	2024-12-20	16:00:00	D015	40	60	QRS2346	2024-12-21	16:15:00	機車	2	121.609403	25.071465	\\x	0	QRS-2346
16	士林區	2024-12-20	16:30:00	D016	50	70	TUV5670	2024-12-21	16:45:00	小型車	1	121.53707	25.037924	\\x	0	TUV-5670
17	士林區	2024-12-20	17:00:00	D017	60	85	WXY1235	2024-12-21	17:15:00	大型車	2	120.662295	24.140058	\\x	0	WXY-1235
18	大同區	2024-12-20	17:30:00	D018	50	70	ZAB8902	2024-12-21	17:45:00	小型車	1	121.565084	25.033956	\\x	0	ZAB-8902
19	中山區	2024-12-20	18:00:00	D019	60	80	CDE2346	2024-12-21	18:15:00	小型車	2	121.439845	25.043911	\\x	0	CDE-2346
20	士林區	2024-12-20	19:00:00	D020	40	60	FGH5679	2024-12-21	19:15:00	機車	1	121.563755	25.053848	\\x	0	FGH-5679
5	松山區	2024-12-20	16:10:00	D005	70	120	MNO7890	2024-12-24	18:15:00	機車	1	120.301435	22.627278	\\x	0	MNO-7890
21	士林區	2024-12-20	19:30:00	D021	50	70	IJK1239	2024-12-21	19:45:00	小型車	2	120.179702	22.956967	\\x	0	IJK-1239
22	士林區	2024-12-20	20:00:00	D022	60	80	LMN7891	2024-12-21	20:15:00	大型車	1	120.291104	22.607168	\\x	0	LMN-7891
23	士林區	2024-12-20	21:00:00	D023	50	70	OPQ1235	2024-12-21	21:15:00	小型車	1	121.382514	24.99634	\\x	0	OPQ-1235
24	士林區	2024-12-20	22:00:00	D024	60	85	RST5679	2024-12-21	22:15:00	大型車	2	120.687423	24.160529	\\x	0	RST-5679
25	松山區	2024-12-20	23:00:00	D025	50	70	UVW6789	2024-12-21	23:15:00	機車	1	121.531486	25.045174	\\x	0	UVW-6789
26	內湖區	2024-12-20	23:30:00	D026	40	60	XYZ1235	2024-12-21	23:45:00	小型車	2	121.516325	25.053652	\\x	1	XYZ-1235
27	萬華區	2024-12-21	00:00:00	D027	60	80	ABC5679	2024-12-22	00:15:00	大型車	1	121.456073	24.983983	\\x	0	ABC-5679
28	中正區	2024-12-21	01:00:00	D028	50	75	DEF1236	2024-12-22	01:15:00	小型車	2	121.521307	25.038523	\\x	0	DEF-1236
29	大安區	2024-12-21	02:00:00	D029	60	90	GHI4568	2024-12-22	02:15:00	大型車	1	120.205637	22.979229	\\x	0	GHI-4568
30	信義區	2024-12-21	03:00:00	D030	50	80	JKL7891	2024-12-22	03:15:00	機車	1	120.332728	22.585671	\\x	0	JKL-7891
31	信義區	2024-12-21	04:00:00	D031	50	70	MNO1235	2024-12-22	04:15:00	小型車	1	120.684441	24.132669	\\x	0	MNO-1235
32	信義區	2024-12-21	05:00:00	D032	60	85	PQR6780	2024-12-22	05:15:00	大型車	2	121.547349	25.030365	\\x	0	PQR-6780
33	信義區	2024-12-21	06:00:00	D033	40	60	STU2347	2024-12-22	06:15:00	小型車	1	121.650298	24.944659	\\x	0	STU-2347
34	信義區	2024-12-21	07:00:00	D034	50	70	VWX3457	2024-12-22	07:15:00	小型車	2	121.584503	25.033786	\\x	0	VWX-3457
36	信義區	2024-12-21	09:00:00	D036	40	60	BCD3459	2024-12-22	09:15:00	小型車	2	121.608739	24.986313	\\x	0	BCD-3459
37	信義區	2024-12-21	10:00:00	D037	50	70	EFG6789	2024-12-22	10:15:00	小型車	1	121.479526	25.060385	\\x	0	EFG-6789
38	信義區	2024-12-21	11:00:00	D038	60	80	HIJ6789	2024-12-22	11:15:00	大型車	2	121.577181	24.991684	\\x	0	HIJ-6789
39	信義區	2024-12-21	12:00:00	D039	50	75	KLM9013	2024-12-22	12:15:00	小型車	1	120.255308	23.030631	\\x	1	KLM-9013
40	信義區	2024-12-21	13:00:00	D040	40	60	NOP2346	2024-12-22	13:15:00	機車	1	120.309548	22.62684	\\x	0	NOP-2346
41	南港區	2024-12-21	14:00:00	D041	50	70	QRS3457	2024-12-22	14:15:00	大型車	2	120.684902	24.14223	\\x	0	QRS-3457
42	北投區	2024-12-21	15:00:00	D042	60	80	TUV5679	2024-12-22	15:15:00	小型車	1	121.495842	25.051645	\\x	0	TUV-5679
43	士林區	2024-12-21	16:00:00	D043	50	70	WXY6789	2024-12-22	16:15:00	小型車	1	121.533665	25.083578	\\x	0	WXY-6789
44	大同區	2024-12-21	17:00:00	D044	60	85	ZAB2346	2024-12-22	17:15:00	大型車	2	120.970844	24.831122	\\x	0	ZAB-2346
45	中山區	2024-12-21	18:00:00	D045	50	75	CDE6789	2024-12-22	18:15:00	機車	1	120.650702	24.137972	\\x	0	CDE-6789
46	松山區	2024-12-21	19:00:00	D046	40	60	FGH9013	2024-12-22	19:15:00	小型車	1	121.5478	25.062353	\\x	0	FGH-9013
47	內湖區	2024-12-21	20:00:00	D047	60	85	IJK1235	2024-12-22	20:15:00	大型車	2	120.692741	24.156542	\\x	0	IJK-1235
48	萬華區	2024-12-21	21:00:00	D048	50	70	LMN9013	2024-12-22	21:15:00	小型車	1	121.453243	25.023874	\\x	0	LMN-9013
49	中正區	2024-12-21	22:00:00	D049	40	60	OPQ2346	2024-12-22	22:15:00	小型車	1	121.641763	25.067249	\\x	0	OPQ-2346
50	大安區	2024-12-21	23:00:00	D050	60	80	RST6789	2024-12-22	23:15:00	機車	2	120.295122	22.629018	\\x	0	RST-6789
51	信義區	2024-12-22	00:00:00	D051	50	75	UVW1234	2024-12-23	00:15:00	小型車	1	120.693218	24.147632	\\x	0	UVW-1234
52	南港區	2024-12-22	01:00:00	D052	60	90	XYZ2346	2024-12-23	01:15:00	大型車	2	121.43567	25.003541	\\x	0	XYZ-2346
53	北投區	2024-12-22	02:00:00	D053	50	70	ABC6780	2024-12-23	02:15:00	小型車	1	121.55342	25.043548	\\x	0	ABC-6780
54	北投區	2024-12-22	03:00:00	D054	60	80	DEF1237	2024-12-23	03:15:00	大型車	2	120.728309	24.173639	\\x	0	DEF-1237
55	北投區	2024-12-22	04:00:00	D055	50	70	GHI5679	2024-12-23	04:15:00	機車	1	121.450371	24.872501	\\x	0	GHI-5679
56	北投區	2024-12-22	05:00:00	D056	60	90	JKL2349	2024-12-23	05:15:00	大型車	2	121.526456	25.037861	\\x	0	JKL-2349
57	士林區	2024-12-22	06:00:00	D057	50	75	MNO3459	2024-12-23	06:15:00	小型車	1	120.698411	24.130524	\\x	0	MNO-3459
68	大同區	2024-12-22	17:00:00	D068	50	75	TUV6789	2024-12-23	17:15:00	小型車	1	120.653012	24.143982	\\x	0	TUV-6789
69	大同區	2024-12-22	18:00:00	D069	60	90	WXY2346	2024-12-23	18:15:00	大型車	2	120.307845	22.619171	\\x	0	WXY-2346
70	松山區	2024-12-22	19:00:00	D070	50	70	ZAB5679	2024-12-23	19:15:00	機車	1	120.232458	23.034186	\\x	0	ZAB-5679
71	內湖區	2024-12-22	20:00:00	D071	60	80	CDE9013	2024-12-23	20:15:00	大型車	2	121.542389	25.035412	\\x	0	CDE-9013
72	萬華區	2024-12-22	21:00:00	D072	50	75	FGH1235	2024-12-23	21:15:00	小型車	1	121.465204	25.037892	\\x	0	FGH-1235
73	萬華區	2024-12-22	22:00:00	D073	60	85	IJK5679	2024-12-23	22:15:00	大型車	2	120.723451	24.13885	\\x	0	IJK-5679
74	萬華區	2024-12-22	23:00:00	D074	50	70	LMN2346	2024-12-23	23:15:00	小型車	1	120.978067	24.801356	\\x	0	LMN-2346
75	萬華區	2024-12-23	00:00:00	D075	60	90	OPQ6789	2024-12-23	00:15:00	機車	2	121.522105	25.051663	\\x	0	OPQ-6789
76	萬華區	2024-12-23	01:00:00	D076	50	75	RST2346	2024-12-23	01:15:00	小型車	1	120.702119	24.148748	\\x	0	RST-2346
77	萬華區	2024-12-23	02:00:00	D077	60	80	UVW5679	2024-12-23	02:15:00	大型車	2	121.48506	25.011667	\\x	0	UVW-5679
35	信義區	2024-12-21	08:00:00	D035	60	90	YZA9013	2024-12-22	08:15:00	機車	1	120.711395	24.167199	\\x	0	YZA-9013
58	士林區	2024-12-22	07:00:00	D058	40	60	PQR9013	2024-12-23	07:15:00	小型車	1	120.306177	22.682439	\\x	0	PQR-9013
59	士林區	2024-12-22	08:00:00	D059	60	80	STU2346	2024-12-23	08:15:00	大型車	2	121.63356	25.066597	\\x	0	STU-2346
60	士林區	2024-12-22	09:00:00	D060	50	70	VWX6789	2024-12-23	09:15:00	機車	1	120.648361	24.151359	\\x	1	VWX-6789
61	士林區	2024-12-22	10:00:00	D061	60	85	YZA9015	2024-12-23	10:15:00	大型車	2	120.151923	23.005041	\\x	0	YZA-9015
62	士林區	2024-12-22	11:00:00	D062	50	70	BCD3457	2024-12-23	11:15:00	小型車	1	121.487249	25.010549	\\x	0	BCD-3457
63	士林區	2024-12-22	12:00:00	D063	60	80	EFG5679	2024-12-23	12:15:00	大型車	2	121.506451	25.034271	\\x	0	EFG-5679
64	士林區	2024-12-22	13:00:00	D064	50	70	HIJ9013	2024-12-23	13:15:00	小型車	1	120.980273	24.799682	\\x	1	HIJ-9013
65	大同區	2024-12-22	14:00:00	D065	60	80	KLM3457	2024-12-23	14:15:00	機車	2	120.714929	24.153735	\\x	0	KLM-3457
66	大同區	2024-12-22	15:00:00	D066	50	70	NOP6789	2024-12-23	15:15:00	小型車	1	121.565087	25.033654	\\x	0	NOP-6789
67	大同區	2024-12-22	16:00:00	D067	60	80	QRS1236	2024-12-23	16:15:00	大型車	2	121.48407	25.063415	\\x	0	QRS-1236
78	中正區	2024-12-23	03:00:00	D078	50	75	XYZ2349	2024-12-23	03:15:00	小型車	1	121.578521	25.041702	\\x	0	XYZ-2349
79	大安區	2024-12-23	04:00:00	D079	60	80	ABC6789	2024-12-23	04:15:00	大型車	2	120.153382	23.03584	\\x	0	ABC-6789
80	信義區	2024-12-23	05:00:00	D080	50	70	DEF2345	2024-12-23	05:15:00	機車	1	120.289462	22.635794	\\x	0	DEF-2345
81	南港區	2024-12-23	06:00:00	D081	60	85	GHI9013	2024-12-23	06:15:00	大型車	2	121.562033	25.027937	\\x	0	GHI-9013
82	信義區	2024-12-23	07:00:00	D082	50	75	JKL2346	2024-12-23	07:15:00	小型車	1	121.459831	25.072691	\\x	0	JKL-2346
83	信義區	2024-12-23	08:00:00	D083	60	80	MNO3457	2024-12-23	08:15:00	大型車	2	120.671128	24.142108	\\x	0	MNO-3457
84	信義區	2024-12-23	09:00:00	D084	50	70	PQR5679	2024-12-23	09:15:00	小型車	1	121.535812	25.088762	\\x	0	PQR-5679
85	信義區	2024-12-23	10:00:00	D085	60	90	STU9013	2024-12-23	10:15:00	機車	2	121.466084	25.00938	\\x	0	STU-9013
86	信義區	2024-12-23	11:00:00	D086	50	70	UVW1235	2024-12-23	11:15:00	小型車	1	120.344665	22.647397	\\x	0	UVW-1235
87	信義區	2024-12-23	12:00:00	D087	60	85	YZA9014	2024-12-23	12:15:00	大型車	2	120.700372	24.143675	\\x	0	YZA-9014
88	信義區	2024-12-23	13:00:00	D088	50	75	BCD9013	2024-12-23	13:15:00	小型車	1	121.474389	25.057982	\\x	0	BCD-9013
89	信義區	2024-12-23	14:00:00	D089	60	80	EFG3457	2024-12-23	14:15:00	大型車	2	121.552749	25.030526	\\x	0	EFG-3457
90	信義區	2024-12-23	15:00:00	D090	50	75	HIJ5679	2024-12-23	15:15:00	機車	1	120.680934	24.135642	\\x	0	HIJ-5679
91	士林區	2024-12-23	16:00:00	D091	60	85	KLM2347	2024-12-23	16:15:00	大型車	2	121.523879	25.051374	\\x	0	KLM-2347
92	士林區	2024-12-23	17:00:00	D092	50	75	NOP6780	2024-12-23	17:15:00	小型車	1	121.472564	25.021389	\\x	0	NOP-6780
93	士林區	2024-12-23	18:00:00	D093	60	90	QRS1235	2024-12-23	18:15:00	大型車	2	120.210238	23.010547	\\x	0	QRS-1235
94	萬華區	2024-12-23	19:00:00	D094	50	70	TUV2346	2024-12-23	19:15:00	小型車	1	120.316404	22.629325	\\x	0	TUV-2346
95	萬華區	2024-12-23	20:00:00	D095	60	80	WXY5679	2024-12-23	20:15:00	機車	2	120.723198	24.153081	\\x	0	WXY-5679
96	萬華區	2024-12-23	21:00:00	D096	50	70	XYZ6789	2024-12-23	21:15:00	小型車	1	121.621459	25.069517	\\x	0	XYZ-6789
97	信義區	2024-12-23	22:00:00	D097	60	90	ABC3457	2024-12-23	22:15:00	大型車	2	121.502392	25.026514	\\x	0	ABC-3457
98	信義區	2024-12-23	23:00:00	D098	50	75	DEF1235	2024-12-23	23:15:00	小型車	1	120.688073	24.164517	\\x	1	DEF-1235
99	松山區	2024-12-23	00:00:00	D099	60	85	GHI9015	2024-12-23	00:15:00	大型車	2	120.303446	22.655883	\\x	0	GHI-9015
100	松山區	2024-12-23	01:00:00	D100	50	75	JKL2347	2024-12-23	01:15:00	機車	1	121.455876	25.034158	\\x	0	JKL-2347
\.


--
-- Data for Name: vehicle_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_registration (license_plate, registered_color, vehicletype, owner_address, owner_name, license_plate2) FROM stdin;
ABC1234	碧綠色	小客車	台中市北區	王靜怡	ABC-1234
DEF5678	藍色	機車	高雄市苓雅區	李俊傑	DEF-5678
GHI9012	紫色	小貨車	台北市信義區	劉志明	GHI-9012
JKL3456	綠色	大客車	台中市東區	鄭志強	JKL-3456
MNO7890	橙色	小客車	高雄市三民區	張家瑋	MNO-7890
PQR2345	金色	小型車	台北市內湖區	陳彥廷	PQR-2345
STU6789	白色	大型車	新北市板橋區	李怡君	STU-6789
VWX3456	紅色	小型車	台中市南區	黃子瑋	VWX-3456
YZA7890	藍色	小型車	高雄市左營區	林志偉	YZA-7890
BCD1234	黑色	機車	台北市松山區	劉家凱	BCD-1234
EFG5678	紫色	小型車	台中市西區	陳雅婷	EFG-5678
HIJ1234	藍色	小型車	高雄市前鎮區	黃宇翔	HIJ1-234
KLM4567	黃色	大型車	台北市大安區	蔡佳慧	KLM-4567
NOP8901	綠色	小型車	新北市中和區	楊士豪	NOP-8901
QRS2346	白色	機車	台中市東區	許博遠	QRS-2346
TUV5670	藍色	小型車	高雄市三民區	張家瑋	TUV-5670
WXY1235	紅色	大型車	台北市信義區	陳志強	WXY-1235
ZAB8902	黃色	小型車	台中市北區	李妍君	ZAB-8902
CDE2346	粉紅色	小型車	高雄市苓雅區	徐麗君	CDE-2346
FGH5679	紫色	機車	新北市新莊區	劉俊彥	FGH-5679
IJK1239	綠色	小型車	台中市西區	林雅琴	IJK-1239
LMN7891	藍色	大型車	台北市中山區	王奕涵	LMN-7891
OPQ1235	金色	小型車	高雄市前鎮區	王志誠	OPQ-1235
RST5679	橙色	大型車	台北市南港區	林宇翔	RST-5679
UVW6789	紅色	機車	新北市三重區	鄭佳慧	UVW-6789
XYZ1235	紫色	小型車	台中市東區	黃子涵	XYZ-1235
ABC5679	黃色	大型車	高雄市前鎮區	鄭婷婷	ABC-5679
DEF1236	綠色	小型車	台北市大安區	張家瑜	DEF-1236
GHI4568	藍色	大型車	新北市板橋區	曾文賢	GHI-4568
JKL7891	黑色	機車	台中市北區	林志豪	JKL-7891
MNO1235	紅色	小型車	台北市信義區	邱立慧	MNO-1235
PQR6780	藍色	大型車	高雄市三民區	何柏翔	PQR-6780
STU2347	金色	小型車	台北市內湖區	李宜庭	STU-2347
VWX3457	紫色	小型車	台中市南區	林志偉	VWX-3457
YZA9013	綠色	機車	高雄市左營區	邱家俊	YZA-9013
BCD3459	橙色	小型車	台北市松山區	陳小婷	BCD-3459
EFG6789	黃色	小型車	台中市西區	周怡君	EFG-6789
HIJ6789	粉紅色	大型車	高雄市苓雅區	林子涵	HIJ-6789
KLM9013	藍色	小型車	新北市中和區	楊宇翔	KLM-9013
NOP2346	紅色	機車	台北市大安區	吳依婷	NOP-2346
QRS3457	金色	大型車	高雄市左營區	黃子瑋	QRS-3457
TUV5679	紫色	小型車	台中市東區	林彥廷	TUV-5679
WXY6789	藍色	小型車	台北市信義區	吳雨婷	WXY-6789
ZAB2346	綠色	大型車	台中市北區	李婉君	ZAB-2346
CDE6789	橙色	機車	高雄市三民區	周志誠	CDE-6789
FGH9013	黃色	小型車	台北市中山區	黃欣怡	FGH-9013
IJK1235	粉紅色	大型車	台中市南區	蔡家瑋	IJK-1235
LMN9013	紫色	小型車	新北市新莊區	吳依婷	LMN-9013
OPQ2346	藍色	小型車	高雄市前鎮區	劉家凱	OPQ-2346
RST6789	綠色	機車	台北市南港區	黃志強	RST-6789
UVW1234	橙色	小型車	台中市東區	林雅婷	UVW-1234
XYZ2346	金色	大型車	新北市三重區	周子瑋	XYZ-2346
ABC6780	紅色	小型車	高雄市苓雅區	鄭家彥	ABC-6780
DEF1237	紫色	大型車	台北市大安區	蔡婉如	DEF-1237
GHI5679	藍色	機車	高雄市三民區	劉怡君	GHI-5679
JKL2349	綠色	大型車	台中市西區	黃佳怡	JKL-2349
MNO3459	橙色	小型車	台北市松山區	周家瑋	MNO-3459
PQR9013	黃色	小型車	高雄市左營區	林志強	PQR-9013
STU2346	粉紅色	大型車	台北市內湖區	李怡君	STU-2346
VWX6789	藍色	機車	台中市北區	陳佩君	VWX-6789
YZA9015	金色	大型車	高雄市三民區	黃宇翔	YZA-9015
BCD3457	紅色	小型車	台北市信義區	吳雨婷	BCD-3457
EFG5679	紫色	大型車	新北市板橋區	劉宇翔	EFG-5679
HIJ9013	綠色	小型車	台中市南區	蔡家瑋	HIJ-9013
KLM3457	藍色	機車	台北市大安區	王佳欣	KLM-3457
NOP6789	粉紅色	小型車	高雄市苓雅區	鄭家瑋	NOP-6789
QRS1236	橙色	大型車	台中市東區	林怡君	QRS-1236
TUV6789	黃色	小型車	台北市南港區	李志強	TUV-6789
WXY2346	白色	大型車	新北市三重區	蔡怡君	WXY-2346
ZAB5679	藍色	機車	高雄市左營區	張家瑋	ZAB-5679
CDE9013	紅色	大型車	台北市中山區	李宇翔	CDE-9013
FGH1235	紫色	小型車	台中市北區	黃佳怡	FGH-1235
IJK5679	綠色	大型車	高雄市三民區	張雅婷	IJK-5679
LMN2346	金色	小型車	台北市大安區	蔡佳瑋	LMN-2346
OPQ6789	藍色	機車	新北市新莊區	王子瑋	OPQ-6789
RST2346	紅色	小型車	高雄市左營區	陳家瑋	RST-2346
UVW5679	紫色	大型車	台中市西區	李家豪	UVW-5679
XYZ2349	綠色	小型車	台北市松山區	林雅婷	XYZ-2349
ABC6789	橙色	大型車	高雄市前鎮區	鄭家瑋	ABC-6789
DEF2345	黃色	機車	台北市內湖區	蔡佩君	DEF-2345
GHI9013	藍色	大型車	新北市板橋區	鄭宇翔	GHI-9013
JKL2346	紅色	小型車	台中市東區	李佳瑋	JKL-2346
MNO3457	金色	大型車	高雄市苓雅區	林子涵	MNO-3457
PQR5679	紫色	小型車	台北市信義區	張家瑋	PQR-5679
STU9013	綠色	機車	台中市南區	鄭怡君	STU-9013
UVW1235	藍色	小型車	高雄市三民區	王怡君	UVW-1235
YZA9014	粉紅色	大型車	台北市大安區	蔡志強	YZA-9014
BCD9013	黃色	小型車	台中市西區	陳子瑋	BCD-9013
EFG3457	紅色	大型車	高雄市前鎮區	李家凱	EFG-3457
HIJ5679	藍色	機車	新北市三重區	黃宇翔	HIJ-5679
KLM2347	綠色	大型車	台北市松山區	王佩君	KLM-2347
NOP6780	橙色	小型車	高雄市苓雅區	張家瑋	NOP-6780
QRS1235	黃色	大型車	台中市北區	李志瑋	QRS-1235
TUV2346	紫色	小型車	台北市大安區	鄭家欣	TUV-2346
WXY5679	藍色	機車	高雄市三民區	王怡君	WXY-5679
XYZ6789	綠色	小型車	台北市松山區	周怡君	XYZ-6789
ABC3457	黑色	大型車	新北市中和區	李志遠	ABC-3457
DEF1235	紫色	小型車	台中市東區	李小兵	DEF-1235
GHI9015	紅色	大型車	高雄市前鎮區	王心怡	GHI-9015
JKL2347	藍色	機車	台北市信義區	陳家瑋	JKL-2347
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
-- Name: abandoned_violation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.abandoned_violation_id_seq', 1, false);


--
-- Name: artificialrecognitionlog_reportid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artificialrecognitionlog_reportid_seq', 1, false);


--
-- Name: fineprintlog_reportid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fineprintlog_reportid_seq', 1, false);


--
-- Name: trafficviolation_violation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trafficviolation_violation_id_seq', 3, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: abandoned abandoned_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abandoned
    ADD CONSTRAINT abandoned_pkey PRIMARY KEY (violation_id);


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
-- PostgreSQL database dump complete
--

