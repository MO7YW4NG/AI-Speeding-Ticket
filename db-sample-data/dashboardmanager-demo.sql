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
-- Name: auth_user_group_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_group_roles (
    auth_user_id bigint NOT NULL,
    group_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.auth_user_group_roles OWNER TO postgres;

--
-- Name: auth_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    password character varying,
    idno character varying,
    uuid character varying,
    tp_account character varying,
    member_type character varying,
    verify_level character varying,
    is_admin boolean DEFAULT false,
    is_active boolean DEFAULT true,
    is_whitelist boolean DEFAULT false,
    is_blacked boolean DEFAULT false,
    expired_at timestamp with time zone,
    created_at timestamp with time zone,
    login_at timestamp with time zone,
    CONSTRAINT chk_auth_users_email CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text))
);


ALTER TABLE public.auth_users OWNER TO postgres;

--
-- Name: auth_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_users_id_seq OWNER TO postgres;

--
-- Name: auth_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_users_id_seq OWNED BY public.auth_users.id;


--
-- Name: component_charts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_charts (
    index character varying NOT NULL,
    color character varying[],
    types character varying[],
    unit character varying
);


ALTER TABLE public.component_charts OWNER TO postgres;

--
-- Name: component_maps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_maps (
    id bigint NOT NULL,
    index character varying NOT NULL,
    title character varying NOT NULL,
    type character varying NOT NULL,
    source character varying NOT NULL,
    size character varying,
    icon character varying,
    paint json,
    property json
);


ALTER TABLE public.component_maps OWNER TO postgres;

--
-- Name: component_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_maps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.component_maps_id_seq OWNER TO postgres;

--
-- Name: component_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_maps_id_seq OWNED BY public.component_maps.id;


--
-- Name: components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.components (
    id bigint NOT NULL,
    index character varying NOT NULL,
    name character varying NOT NULL,
    history_config json,
    map_config_ids integer[],
    map_config json,
    chart_config json,
    map_filter json,
    time_from character varying,
    time_to character varying,
    update_freq integer,
    update_freq_unit character varying,
    source character varying,
    short_desc text,
    long_desc text,
    use_case text,
    links text[],
    contributors text[],
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    query_type character varying,
    query_chart text,
    query_history text
);


ALTER TABLE public.components OWNER TO postgres;

--
-- Name: components_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.components_id_seq OWNER TO postgres;

--
-- Name: components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.components_id_seq OWNED BY public.components.id;


--
-- Name: contributors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contributors (
    id bigint NOT NULL,
    user_id character varying NOT NULL,
    user_name character varying NOT NULL,
    image text,
    link text NOT NULL,
    identity character varying,
    description text,
    include boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.contributors OWNER TO postgres;

--
-- Name: contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contributors_id_seq OWNER TO postgres;

--
-- Name: contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contributors_id_seq OWNED BY public.contributors.id;


--
-- Name: dashboard_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_groups (
    dashboard_id bigint NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.dashboard_groups OWNER TO postgres;

--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboards (
    id bigint NOT NULL,
    index character varying NOT NULL,
    name character varying NOT NULL,
    components integer[],
    icon text,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboards_id_seq OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    name character varying,
    is_personal boolean DEFAULT false,
    create_by bigint
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    id bigint NOT NULL,
    type text,
    description text,
    distance numeric,
    latitude numeric,
    longitude numeric,
    place text,
    "time" timestamp with time zone,
    status text
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidents_id_seq OWNER TO postgres;

--
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issues (
    id bigint NOT NULL,
    title character varying NOT NULL,
    user_name character varying NOT NULL,
    user_id character varying NOT NULL,
    context text,
    description text NOT NULL,
    decision_desc text,
    status character varying NOT NULL,
    updated_by character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.issues OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.issues_id_seq OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    access_control boolean DEFAULT false,
    modify boolean DEFAULT false,
    read boolean DEFAULT false
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: view_points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_points (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    center_x numeric,
    center_y numeric,
    zoom numeric,
    pitch numeric,
    bearing numeric,
    name text,
    point_type text
);


ALTER TABLE public.view_points OWNER TO postgres;

--
-- Name: view_points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.view_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.view_points_id_seq OWNER TO postgres;

--
-- Name: view_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.view_points_id_seq OWNED BY public.view_points.id;


--
-- Name: auth_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users ALTER COLUMN id SET DEFAULT nextval('public.auth_users_id_seq'::regclass);


--
-- Name: component_maps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_maps ALTER COLUMN id SET DEFAULT nextval('public.component_maps_id_seq'::regclass);


--
-- Name: components id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components ALTER COLUMN id SET DEFAULT nextval('public.components_id_seq'::regclass);


--
-- Name: contributors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors ALTER COLUMN id SET DEFAULT nextval('public.contributors_id_seq'::regclass);


--
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: view_points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points ALTER COLUMN id SET DEFAULT nextval('public.view_points_id_seq'::regclass);


--
-- Data for Name: auth_user_group_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_group_roles (auth_user_id, group_id, role_id) FROM stdin;
1	42	1
1	1	1
\.


--
-- Data for Name: auth_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_users (id, name, email, password, idno, uuid, tp_account, member_type, verify_level, is_admin, is_active, is_whitelist, is_blacked, expired_at, created_at, login_at) FROM stdin;
1	Schumi	schumiy.tw@gmail.com	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	\N	\N	\N	\N	\N	t	t	t	f	\N	2024-12-25 02:01:16.226405+08	2025-01-11 04:37:38.203002+08
\.


--
-- Data for Name: component_charts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_charts (index, color, types, unit) FROM stdin;
welfare_institutions	{#F65658,#F49F36,#F5C860,#9AC17C,#4CB495,#569C9A,#60819C,#2F8AB1}	{BarChart,DonutChart}	間
building_unsued	{#d16ae2,#655fad}	{MapLegend}	處
patrol_criminalcase	{#FD5696,#00A9E0}	{TimelineSeparateChart,TimelineStackedChart,ColumnLineChart}	件
welfare_population	{#2e999b,#80e3d4,#1f9b85,#a5ece0}	{ColumnChart,BarPercentChart,DistrictChart}	人
pump_status	{#ff9800}	{GuageChart,BarPercentChart}	站
abandoned	{#BF40BF}	{ColumnChart}	件
trafficviolation	{#ff4c4c,#2F8AB1,#60819C,#569C9A,#9AC17C,#4CB495}	{DistrictChart,ColumnChart}	件
vehicle_model	{#1d3557,#2a5d84,#457b84,#6a8d92,#a8dadc,#d0e6f3}	{DonutChart,ColumnChart}	%
order_rate	{#9ac17c}	{GuageChart,BarPercentChart}	件
speed_camera	{#569C9A}	{DistrictChart,RadarChart}	處
illegal_plate	{#fcba03}	{ColumnChart}	件
trafficviolation_poly	{#FF9999,#CC6666,#993333,#800000}	{TreemapChart,ColumnChart,DistrictChart}	件
\.


--
-- Data for Name: component_maps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_maps (id, index, title, type, source, size, icon, paint, property) FROM stdin;
50	patrol_rain_floodgate	抽水站	circle	geojson	big	\N	{"circle-color":["match",["get","all_pumb_lights"],"+","#ff9800","#00B2FF"]}	[{"key":"station_name","name":"站名"},{"key":"all_pumb_lights","name":"總抽水狀態"},{"key":"warning_level","name":"目前警戒值"},{"key":"start_pumping_level","name":"抽水起始值"},{"key":"door_num","name":"水門數目"},{"key":"pumb_num","name":"抽水機數目"},{"key":"river_basin","name":"流域"},{"key":"rec_time","name":"記錄時間"}]
42	building_unsued_land	閒置市有公有地	fill	geojson	\N	\N	{"fill-color":"#d16ae2","fill-opacity":0.7}	[{"key":"10712土地_1_土地權屬情形","name":"土地權屬情形"},{"key":"10712土地_1_管理機關","name":"管理機關"}]
60	patrol_rain_sewer	下水道	circle	geojson	big	\N	{"circle-color": ["interpolate", ["linear"], ["to-number", ["get", "ground_far"]], -100, "#F92623", 0.51, "#81bcf5"]}	[{"key": "station_no", "name": "NO"}, {"key": "station_name", "name": "站名"}, {"key": "ground_far", "name": "距地面高[公尺]"}, {"key": "level_out", "name": "水位高[公尺]"}, {"key": "rec_time", "name": "紀錄時間"}]
64	socl_welfare_organization_plc	社福機構	circle	geojson	big	\N	{"circle-color": ["match", ["get", "main_type"], "銀髮族服務", "#F49F36", "身障機構", "#F65658", "兒童與少年服務", "#F5C860", "社區服務、NPO", "#9AC17C", "婦女服務", "#4CB495", "貧困危機家庭服務", "#569C9A", "保護性服務", "#60819C", "#2F8AB1"]}	[{"key": "main_type", "name": "主要類別"}, {"key": "sub_type", "name": "次要分類"}, {"key": "name", "name": "名稱"}, {"key": "address", "name": "地址"}]
43	building_unsued_public	閒置市有(公用)建物	circle	geojson	big	\N	{"circle-color":"#655fad"}	[{"key":"門牌","name":"門牌"},{"key":"房屋現況","name":"房屋現況"},{"key":"目前執行情形","name":"目前執行情形"},{"key":"閒置樓層_閒置樓層/該建物總樓層","name":"閒置樓層/總樓層"},{"key":"閒置面積㎡","name":"閒置面積㎡"},{"key":"基地管理機關","name":"基地管理機關"},{"key":"建物管理機關","name":"建物管理機關"},{"key":"原使用用途","name":"原使用用途"},{"key":"基地所有權人","name":"基地所有權人"},{"key":"建物標示","name":"建物標示"},{"key":"建築完成日期","name":"建築完成日期"}]
95	trafficviolation_abandoned	無法辨識案件	circle	geojson	big	\N	{"circle-color":"#BF40BF"}	[{"key":"violation_id","name":"案件編號"},{"key":"district","name":"行政區"},{"key":"address","name":"案件地址"},{"key":"violation_date","name":"案件日期"},{"key":"violation_time","name":"案件時間"},{"key":"status_code","name":"無法辨識原因"}]
92	speed_camera	測速執法設置點	circle	geojson	big	\N	{"circle-color":"#569C9A"}	[{"key":"設置市區鄉鎮","name":"設置行政區區"},{"key":"管轄警局","name":"管轄警局"},{"key":"管轄分局","name":"管轄分局"},{"key":"設置地址","name":"地址"}]
93	trafficviolation_polygon	台北市違規案件分佈	fill	geojson	\N	\N	{"fill-color":["interpolate",["linear"],["get","number"],1,"#FFEBEB",10,"#FF4C4C",50,"#660000"],"fill-opacity":0.3}	[{"key":"location","name":"行政區"},{"key":"number","name":"違規案件數量"}]
96	trafficviolation_sus_licenseplates	非法車牌案件	circle	geojson	big	\N	{"circle-color":"#fcba03"}	[{"key":"violation_id","name":"案件編號"},{"key":"district","name":"行政區"},{"key":"address","name":"案件地址"},{"key":"violation_date","name":"案件日期"},{"key":"violation_time","name":"案件時間"},{"key":"status_code","name":"無法辨識原因"}]
91	trafficviolation_today	當日違規案件	circle	geojson	big		{"circle-color":"#FF0808"}	[{"key":"violation_id","name":"案件編號"},{"key":"district","name":"行政區"},{"key":"address","name":"案件地址"},{"key":"violation_date","name":"案件日期"},{"key":"violation_time","name":"案件時間"}]
94	trafficviolation	台北市違規案件	circle	geojson	big	\N	{"circle-color":"#fc888a"}	[{"key":"violation_id","name":"案件編號"},{"key":"district","name":"行政區"},{"key":"address","name":"案件地址"},{"key":"violation_date","name":"案件日期"},{"key":"violation_time","name":"案件時間"}]
\.


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components (id, index, name, history_config, map_config_ids, map_config, chart_config, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history) FROM stdin;
82	welfare_institutions	社福機構	\N	{64}	\N	\N	{"mode": "byParam", "byParam": {"xParam": "main_type"}}	static	\N	\N	\N	社會局	顯示社會福利機構點位及機構類型	顯示社會福利機構點位及機構類型，資料來源為台北市社會局內部資料，每月15日更新。	根據機構空間的分佈情況，檢視社會福利機構是否均勻分布，同時整合市有土地、社會住宅等潛在可使用之空間，以研擬增設位置與類型的方案。	{https://data.taipei/dataset/detail?id=cabdf272-e0ec-4e4e-9136-f4b8596f35d9}	{tuic}	2023-12-20 13:56:00+08	2023-12-20 13:56:00+08	two_d	select main_type as x_axis,count(*) as data from socl_welfare_organization_plc group by main_type order by data desc	\N
30	building_unsued	閒置市有財產	\N	{42,43}	\N	\N	{"mode":"byLayer"}	static	\N	\N	\N	財政局	\N	\N	\N	{}	{tuic}	2023-12-20 13:56:00+08	2024-01-11 14:01:02.392686+08	map_legend	select '閒置市有公有地' as name, count(*) as value, 'fill' as type from building_unsued_land\nunion all\nselect '閒置市有(公用)建物' as name, count(*) as value, 'circle' as type from building_unsued_public	\N
90	welfare_population	社福人口	\N	{}	\N	\N	\N	static	\N	\N	\N	社會局	顯示社會福利人口（身障、低收、中低收、低收身障）的比例	顯示社會福利人口（身障、低收、中低收、低收身障）的比例，資料來源為台北市社會局內部資料，每月15號更新。	社福人口比例的資料能讓我們了解台北市社會福利的需求變化，從而規劃更貼近民眾需求的社會福利措施。	{}	{tuic}	2023-12-20 13:56:00+08	2024-01-09 11:32:59.233032+08	three_d	SELECT x_axis, y_axis, data FROM (SELECT district AS x_axis, '低收' AS y_axis, is_low_income AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '中低收' AS y_axis, is_low_middle_income AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '身障補助' AS y_axis, is_disabled_allowance AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '身障' AS y_axis, is_disabled AS data FROM app_calcu_monthly_socl_welfare_people_ppl) AS combined_data WHERE x_axis != 'e' ORDER BY ARRAY_POSITION(ARRAY['北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區']::varchar[], combined_data.x_axis), ARRAY_POSITION(ARRAY['低收', '中低收', '身障補助', '身障'], combined_data.y_axis);	\N
7	patrol_criminalcase	刑事統計	\N	{}	\N	\N	\N	year_ago	now	1	month	警察局	顯示近兩年每月的刑案統計資訊	顯示近兩年每月的刑案統計資訊，資料來源為台北市主計處開放資料，每月更新。	藉由掌握台北市刑事案件近2年的統計資訊，我們可以瞭解案件的增減趨勢及相關特徵，有助於制定更有效的治安策略。	{https://data.taipei/dataset/detail?id=dc7e246a-a88e-42f8-8cd6-9739209af774}	{tuic}	2023-12-20 13:56:00+08	2024-01-17 14:53:41.810511+08	time	WITH date_range AS (\n  SELECT\n    '2022-01-01 00:00:00+00'::timestamp with time zone AS start_time,\n    '2025-12-31 00:00:00+00'::timestamp with time zone AS end_time\n)\nSELECT "年月別" as x_axis, '發生件數' as y_axis, "發生件數[件]" as data FROM public.patrol_criminal_case \nWHERE 年月別 BETWEEN  (SELECT start_time FROM date_range) AND (SELECT end_time FROM date_range)\nUNION ALL\nSELECT "年月別" as x_axis, '破獲件數' as y_axis, "破獲件數/總計[件]" as data FROM public.patrol_criminal_case\nWHERE 年月別 BETWEEN  (SELECT start_time FROM date_range) AND (SELECT end_time FROM date_range)	\N
43	pump_status	抽水站狀態	\N	{50}	\N	\N	{"mode":"byParam","byParam":{"yParam":"all_pumb_lights"}}	current	\N	10	minute	工務局水利處	顯示當前全市開啟的抽水站數量	顯示當前全市開啟的抽水站數量，資料來源為工務局水利處內部資料，每十分鐘更新。	考慮當日天氣及「水位監測」組件的資料，來探討抽水站的運作狀況與水位異常之間的關聯性。	{}	{tuic}	2023-12-20 13:56:00+08	2024-01-25 17:36:14.565347+08	percent	SELECT '啟動抽水站' AS x_axis,\n  CASE\n    WHEN all_pumb_lights = '+' THEN '啟動中'\n    WHEN all_pumb_lights = '-' THEN '未啟動'\n    ELSE '未啟用'\n  END AS y_axis,\n  COUNT(*) AS data\nFROM patrol_rain_floodgate\nGROUP BY\n  CASE\n    WHEN all_pumb_lights = '+' THEN '啟動中'\n    WHEN all_pumb_lights = '-' THEN '未啟動'\n    ELSE '未啟用'\n  END;	\N
69	speed_camera	測速執法設置點	null	{92}	\N	\N	{"mode":"byParam","byParam":{"xParam":"設置市區鄉鎮"}}	quarter_ago	now	10	minute	政府開放資料平台	提供全國各警察機關測速執法地點等資訊。	提供全國各警察機關測速執法地點等資訊。	顯示全國各警察機關測速執法地點、速限等資訊。	{}	{ChatGPT}	2025-01-01 12:20:00+08	2025-01-11 04:38:57.495598+08	two_d	SELECT 設置市區鄉鎮 AS x_axis, COUNT(*) AS data\nFROM public.speed_camera\nWHERE 設置市區鄉鎮 IS NOT NULL\nGROUP BY 設置市區鄉鎮\nORDER BY ARRAY_POSITION(\n    ARRAY['中正區', '大同區', '士林區', '北投區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大安區', '萬華區', '文山區']::varchar[], 設置市區鄉鎮\n);	\N
71	trafficviolation	台北市違規案件	null	{91,94}	\N	\N	{"mode":"byParam","byParam":{"xParam":"location"}}	quarter_ago	now	10	minute	ChatGPT	顯示違規事件	顯示違規事件	顯示違規事件	{}	{ChatGPT}	2025-01-02 12:20:00+08	2025-01-10 13:51:24.594766+08	two_d	SELECT district AS x_axis, COUNT(*) AS data\nFROM public.traffic_violation\nWHERE district IS NOT NULL\nGROUP BY district ORDER BY ARRAY_POSITION(\n    ARRAY['中正區', '大同區', '士林區', '北投區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大安區', '萬華區', '文山區']::varchar[], district\n);	\N
44	vehicle_model	違規車型	null	\N	\N	\N	null	quarter_ago	now	10	minute	全國違規案件處理檔	顯示違規車型種類	顯示違規車型種類	顯示違規車型種類	{}	{全國違規案件處理檔}	2025-01-10 17:00:00+08	2025-01-11 04:38:26.150783+08	two_d	SELECT \n    vehicle_type AS x_axis,\n    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM traffic_violation)), 0) AS "data"\nFROM \n    traffic_violation\nGROUP BY \n    vehicle_type\nORDER BY \n    "data" DESC;	\N
45	order_rate	開單率	null	\N	\N	\N	null	quarter_ago	now	10	minute	全國違規案件處理檔	顯示智慧燈桿回傳後目前開單率	顯示智慧燈桿回傳後目前開單率	顯示智慧燈桿回傳後目前開單率	{}	{全國違規案件處理檔}	2025-01-10 17:00:00+08	2025-01-11 04:38:38.901795+08	percent	SELECT '開單率' AS x_axis, y_axis, DATA FROM\n(\nSELECT '已開單' AS y_axis, COUNT(*) AS DATA FROM public.traffic_violation \nWHERE status_code = 30\nUNION ALL\nSELECT '未開單' AS y_axis, COUNT(*) AS DATA FROM public.traffic_violation \nWHERE status_code != '30'\n)	\N
72	abandoned	無法辨識案件	null	{95}	\N	\N	null	static	\N	10	minute	交通AI辨識系統	提供AI辨識系統無法辨識案件	提供AI辨識系統無法辨識案件	提供AI辨識系統無法辨識案件	{}	{AI辨識子系統}	2025-01-08 07:20:00+08	2025-01-08 12:36:53.57383+08	two_d	SELECT district AS x_axis, COUNT(*) AS data\nFROM public.traffic_violation\nWHERE district IS NOT NULL\n  AND status_code > 20\n  AND status_code < 24\nGROUP BY district\nORDER BY ARRAY_POSITION(\n    ARRAY['中正區', '大同區', '士林區', '北投區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大安區', '萬華區', '文山區']::varchar[], district\n);	\N
70	trafficviolation_poly	違規案件分佈	null	{93}	\N	\N	{"mode":"byParam","byParam":{"xParam":"location"}}	quarter_ago	now	10	minute	ChatGPT	顯示交通違規分佈	顯示交通違規分佈	顯示交通違規分佈	{}	{ChatGPT}	2025-01-03 07:20:00+08	2025-01-11 04:39:15.79835+08	two_d	SELECT district AS x_axis, COUNT(*) AS data\nFROM public.traffic_violation\nWHERE district IS NOT NULL\nGROUP BY district ORDER BY ARRAY_POSITION(\n    ARRAY['中正區', '大同區', '士林區', '北投區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大安區', '萬華區', '文山區']::varchar[], district\n);	\N
73	illegal_plate	非法車牌案件	null	{96}	\N	\N	{"mode":"byParam","byParam":{"xParam":"district"}}	static	\N	10	minute	全國違規案件處理檔	顯示非法車牌案件之分佈	顯示非法車牌案件之分佈	顯示非法車牌案件之分佈	{}	{全國違規案件處理檔}	2025-01-08 07:20:00+08	2025-01-10 17:28:15.546144+08	two_d	SELECT district AS x_axis, COUNT(*) AS data\nFROM public.traffic_violation\nWHERE district IS NOT NULL\n  AND status_code > 23\n  AND status_code < 26\nGROUP BY district\nORDER BY ARRAY_POSITION(\n    ARRAY['中正區', '大同區', '士林區', '北投區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大安區', '萬華區', '文山區']::varchar[], district\n);	\N
\.


--
-- Data for Name: contributors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributors (id, user_id, user_name, image, link, identity, description, include, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dashboard_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_groups (dashboard_id, group_id) FROM stdin;
72	42
73	1
74	1
\.


--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboards (id, index, name, components, icon, updated_at, created_at) FROM stdin;
72	9428d4c744c6	收藏組件	\N	favorite	2024-12-25 02:01:16.241158+08	2024-12-25 02:01:16.241158+08
74	map-layers	圖資資訊	{69}	star	2025-01-08 19:57:55.037803+08	2025-01-02 20:09:24.03392+08
73	Taipei_traffic_violations	台北交通違規案件	{71,70,72,73,44,45}	traffic	2025-01-10 17:12:15.40665+08	2025-01-01 20:49:12.106472+08
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, is_personal, create_by) FROM stdin;
1	public	f	\N
42	user: 1's personal group	t	1
\.


--
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (id, type, description, distance, latitude, longitude, place, "time", status) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, title, user_name, user_id, context, description, decision_desc, status, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, access_control, modify, read) FROM stdin;
1	admin	t	t	t
2	editor	f	t	t
3	viewer	f	f	t
4	admin	t	t	t
5	editor	f	t	t
6	viewer	f	f	t
7	admin	t	t	t
8	editor	f	t	t
9	viewer	f	f	t
10	admin	t	t	t
11	editor	f	t	t
12	viewer	f	f	t
13	admin	t	t	t
14	editor	f	t	t
15	viewer	f	f	t
16	admin	t	t	t
17	editor	f	t	t
18	viewer	f	f	t
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: view_points; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_points (id, user_id, center_x, center_y, zoom, pitch, bearing, name, point_type) FROM stdin;
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
-- Name: auth_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_users_id_seq', 6, true);


--
-- Name: component_maps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.component_maps_id_seq', 93, true);


--
-- Name: components_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.components_id_seq', 71, true);


--
-- Name: contributors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributors_id_seq', 1, false);


--
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboards_id_seq', 74, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 42, true);


--
-- Name: incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_id_seq', 1, false);


--
-- Name: issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issues_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 18, true);


--
-- Name: view_points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.view_points_id_seq', 1, false);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: auth_user_group_roles auth_user_group_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT auth_user_group_roles_pkey PRIMARY KEY (auth_user_id, group_id, role_id);


--
-- Name: auth_users auth_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key UNIQUE (email);


--
-- Name: auth_users auth_users_idno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_idno_key UNIQUE (idno);


--
-- Name: auth_users auth_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_pkey PRIMARY KEY (id);


--
-- Name: auth_users auth_users_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_uuid_key UNIQUE (uuid);


--
-- Name: component_charts component_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_charts
    ADD CONSTRAINT component_charts_pkey PRIMARY KEY (index);


--
-- Name: component_maps component_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_maps
    ADD CONSTRAINT component_maps_pkey PRIMARY KEY (id);


--
-- Name: components components_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_index_key UNIQUE (index);


--
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: contributors contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT contributors_pkey PRIMARY KEY (id);


--
-- Name: dashboard_groups dashboard_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT dashboard_groups_pkey PRIMARY KEY (dashboard_id, group_id);


--
-- Name: dashboards dashboards_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_index_key UNIQUE (index);


--
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: view_points view_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points
    ADD CONSTRAINT view_points_pkey PRIMARY KEY (id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_auth_user FOREIGN KEY (auth_user_id) REFERENCES public.auth_users(id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_group FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: dashboard_groups fk_dashboard_groups_dashboard; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT fk_dashboard_groups_dashboard FOREIGN KEY (dashboard_id) REFERENCES public.dashboards(id);


--
-- Name: dashboard_groups fk_dashboard_groups_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT fk_dashboard_groups_group FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: groups fk_groups_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT fk_groups_auth_user FOREIGN KEY (create_by) REFERENCES public.auth_users(id);


--
-- Name: view_points fk_view_points_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points
    ADD CONSTRAINT fk_view_points_auth_user FOREIGN KEY (user_id) REFERENCES public.auth_users(id);


--
-- PostgreSQL database dump complete
--

