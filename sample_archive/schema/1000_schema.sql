--
-- PostgreSQL database dump
--

-- Dumped from database version 10.22 (Debian 10.22-1.pgdg90+1)
-- Dumped by pg_dump version 13.2

-- Started on 2023-01-26 14:33:10

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--
DO
$do$
BEGIN
   IF EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'aptible') THEN

      RAISE NOTICE 'Role "aptible" already exists. Skipping.';
   ELSE
      CREATE ROLE aptible;
   END IF;
END
$do$;

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 538 (class 1255 OID 552189)
-- Name: aes_decrypt(text); Type: FUNCTION; Schema: public; Owner: aptible
--

CREATE FUNCTION public.aes_decrypt(value text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	decrypted bytea;
    decrypted_ascii text;
BEGIN
    decrypted := decrypt(decode(substring(value from 6), 'hex'), '807b93b369bc2b159809dc1aa0a6083b', 'aes');
    decrypted_ascii := '';
    
    FOR i IN 0..15 LOOP
        IF get_byte(decrypted, i) > 0 THEN
            decrypted_ascii := decrypted_ascii || chr(get_byte(decrypted, i));
        ELSE
            EXIT;
        END IF;
    END LOOP; 

    RETURN decrypted_ascii;

EXCEPTION WHEN others THEN
    RAISE NOTICE 'Error decrypting value';
    RETURN value;
END;
$$;


ALTER FUNCTION public.aes_decrypt(value text) OWNER TO aptible;

SET default_tablespace = '';

--
-- TOC entry 199 (class 1259 OID 16392)
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.account_emailaddress (
    id integer NOT NULL,
    user_id integer NOT NULL,
    email character varying(254) NOT NULL,
    verified boolean NOT NULL,
    "primary" boolean NOT NULL
);


ALTER TABLE public.account_emailaddress OWNER TO aptible;

--
-- TOC entry 200 (class 1259 OID 16395)
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.account_emailaddress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailaddress_id_seq OWNER TO aptible;

--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 200
-- Name: account_emailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.account_emailaddress_id_seq OWNED BY public.account_emailaddress.id;


--
-- TOC entry 201 (class 1259 OID 16397)
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.account_emailconfirmation (
    id integer NOT NULL,
    email_address_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    sent timestamp with time zone,
    key character varying(64) NOT NULL
);


ALTER TABLE public.account_emailconfirmation OWNER TO aptible;

--
-- TOC entry 202 (class 1259 OID 16400)
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.account_emailconfirmation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailconfirmation_id_seq OWNER TO aptible;

--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 202
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.account_emailconfirmation_id_seq OWNED BY public.account_emailconfirmation.id;


--
-- TOC entry 203 (class 1259 OID 16402)
-- Name: admin_tools_dashboard_preferences; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.admin_tools_dashboard_preferences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    data text NOT NULL,
    dashboard_id character varying(100) NOT NULL
);


ALTER TABLE public.admin_tools_dashboard_preferences OWNER TO aptible;

--
-- TOC entry 204 (class 1259 OID 16408)
-- Name: admin_tools_dashboard_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.admin_tools_dashboard_preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_tools_dashboard_preferences_id_seq OWNER TO aptible;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 204
-- Name: admin_tools_dashboard_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.admin_tools_dashboard_preferences_id_seq OWNED BY public.admin_tools_dashboard_preferences.id;


--
-- TOC entry 205 (class 1259 OID 16410)
-- Name: admin_tools_menu_bookmark; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.admin_tools_menu_bookmark (
    id integer NOT NULL,
    user_id integer NOT NULL,
    url character varying(255) NOT NULL,
    title character varying(255) NOT NULL
);


ALTER TABLE public.admin_tools_menu_bookmark OWNER TO aptible;

--
-- TOC entry 206 (class 1259 OID 16416)
-- Name: admin_tools_menu_bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.admin_tools_menu_bookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_tools_menu_bookmark_id_seq OWNER TO aptible;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 206
-- Name: admin_tools_menu_bookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.admin_tools_menu_bookmark_id_seq OWNED BY public.admin_tools_menu_bookmark.id;


--
-- TOC entry 401 (class 1259 OID 579834)
-- Name: analytics_categorytopicmap; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_categorytopicmap (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    sentiment character varying(8) NOT NULL,
    category_id integer NOT NULL,
    category_name character varying(255) NOT NULL,
    topic_id integer NOT NULL,
    topic_name character varying(255) NOT NULL
);


ALTER TABLE public.analytics_categorytopicmap OWNER TO aptible;

--
-- TOC entry 400 (class 1259 OID 579832)
-- Name: analytics_categorytopicmap_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_categorytopicmap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_categorytopicmap_id_seq OWNER TO aptible;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 400
-- Name: analytics_categorytopicmap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_categorytopicmap_id_seq OWNED BY public.analytics_categorytopicmap.id;


--
-- TOC entry 403 (class 1259 OID 579845)
-- Name: analytics_categorytopictooltip; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_categorytopictooltip (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    type_name character varying(8) NOT NULL,
    type_id integer NOT NULL,
    html text NOT NULL,
    sentiment character varying(8) NOT NULL
);


ALTER TABLE public.analytics_categorytopictooltip OWNER TO aptible;

--
-- TOC entry 402 (class 1259 OID 579843)
-- Name: analytics_categorytopictooltip_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_categorytopictooltip_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_categorytopictooltip_id_seq OWNER TO aptible;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 402
-- Name: analytics_categorytopictooltip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_categorytopictooltip_id_seq OWNED BY public.analytics_categorytopictooltip.id;


--
-- TOC entry 477 (class 1259 OID 999975)
-- Name: analytics_data_nps; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_data_nps (
    customer_id integer,
    customer_name character varying(50),
    customer_specialty character varying(50),
    organization_id integer,
    organization_name character varying(255),
    patientvisithistory_id integer,
    visit_type character varying(255),
    date_seen date,
    provider_id integer,
    provider_name character varying(128),
    site_id integer,
    site_name character varying(255),
    site_manager_name character varying(255),
    survey_request_id integer,
    phone_number_id integer,
    includes_provider_nps boolean,
    is_nps_request boolean,
    is_undeliverable_number boolean,
    survey_response_id integer,
    response_date timestamp with time zone,
    date_seen_week date,
    date_seen_month date,
    score integer,
    provider_score smallint,
    cohort_id integer,
    id integer NOT NULL
);


ALTER TABLE public.analytics_data_nps OWNER TO aptible;

--
-- TOC entry 478 (class 1259 OID 999981)
-- Name: analytics_data_nps_tmp_id_seq1; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_data_nps_tmp_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_data_nps_tmp_id_seq1 OWNER TO aptible;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 478
-- Name: analytics_data_nps_tmp_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_data_nps_tmp_id_seq1 OWNED BY public.analytics_data_nps.id;


--
-- TOC entry 479 (class 1259 OID 1000000)
-- Name: analytics_data_tickets; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_data_tickets (
    customer_id integer,
    customer_name character varying(50),
    site_id integer,
    site_name character varying(255),
    ticket_id integer,
    type character varying(50),
    closed integer,
    created_date date,
    created_date_month date,
    open_date date,
    close_date date,
    days_to_open integer,
    days_to_close integer,
    days_to_close_full integer,
    id integer NOT NULL
);


ALTER TABLE public.analytics_data_tickets OWNER TO aptible;

--
-- TOC entry 480 (class 1259 OID 1000003)
-- Name: analytics_data_tickets_tmp_id_seq1; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_data_tickets_tmp_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_data_tickets_tmp_id_seq1 OWNER TO aptible;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 480
-- Name: analytics_data_tickets_tmp_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_data_tickets_tmp_id_seq1 OWNED BY public.analytics_data_tickets.id;


--
-- TOC entry 481 (class 1259 OID 1000013)
-- Name: analytics_data_topics; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_data_topics (
    customer_id integer,
    customer_specialty character varying(50),
    site_id integer,
    site_name character varying(255),
    survey_response_id integer,
    type text,
    type_id integer,
    sentiment text,
    match_value double precision,
    customer_value double precision,
    date_seen date
);


ALTER TABLE public.analytics_data_topics OWNER TO aptible;

--
-- TOC entry 207 (class 1259 OID 16418)
-- Name: analytics_endpointaccess; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_endpointaccess (
    id integer NOT NULL,
    url character varying(255) NOT NULL,
    accessed_at timestamp with time zone NOT NULL,
    method character varying(10),
    "user" character varying(255),
    parameters text
);


ALTER TABLE public.analytics_endpointaccess OWNER TO aptible;

--
-- TOC entry 208 (class 1259 OID 16424)
-- Name: analytics_endpointaccess_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_endpointaccess_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_endpointaccess_id_seq OWNER TO aptible;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 208
-- Name: analytics_endpointaccess_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_endpointaccess_id_seq OWNED BY public.analytics_endpointaccess.id;


--
-- TOC entry 209 (class 1259 OID 16426)
-- Name: analytics_providerengagement; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_providerengagement (
    id integer NOT NULL,
    provider_id integer NOT NULL,
    accessed_at timestamp with time zone NOT NULL,
    access_type character varying(64) NOT NULL,
    details text,
    accessed_via character varying(1024)
);


ALTER TABLE public.analytics_providerengagement OWNER TO aptible;

--
-- TOC entry 210 (class 1259 OID 16432)
-- Name: analytics_providerengagement_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_providerengagement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_providerengagement_id_seq OWNER TO aptible;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 210
-- Name: analytics_providerengagement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_providerengagement_id_seq OWNED BY public.analytics_providerengagement.id;


--
-- TOC entry 353 (class 1259 OID 65814)
-- Name: analytics_rebuild; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_rebuild (
    id integer NOT NULL,
    rebuild_at timestamp with time zone NOT NULL
);


ALTER TABLE public.analytics_rebuild OWNER TO aptible;

--
-- TOC entry 352 (class 1259 OID 65812)
-- Name: analytics_rebuild_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_rebuild_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_rebuild_id_seq OWNER TO aptible;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 352
-- Name: analytics_rebuild_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_rebuild_id_seq OWNED BY public.analytics_rebuild.id;


--
-- TOC entry 399 (class 1259 OID 551879)
-- Name: analytics_siteengagement; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_siteengagement (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    email character varying(255) NOT NULL,
    site_id integer NOT NULL,
    event character varying(25) NOT NULL
);


ALTER TABLE public.analytics_siteengagement OWNER TO aptible;

--
-- TOC entry 398 (class 1259 OID 551877)
-- Name: analytics_siteengagement_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_siteengagement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_siteengagement_id_seq OWNER TO aptible;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 398
-- Name: analytics_siteengagement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_siteengagement_id_seq OWNED BY public.analytics_siteengagement.id;


--
-- TOC entry 365 (class 1259 OID 187574)
-- Name: analytics_socialmediareviewrequest; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.analytics_socialmediareviewrequest (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    visit_date date NOT NULL,
    review_targets character varying(255),
    patient_name character varying(255),
    patient_id character varying(255),
    email character varying(255),
    google_clicked boolean NOT NULL,
    yelp_clicked boolean NOT NULL,
    facebook_clicked boolean NOT NULL,
    customer_id integer NOT NULL,
    outgoing_sms_message_id integer,
    patient_visit_id integer,
    phone_number_id integer NOT NULL,
    site_id integer NOT NULL,
    provider_id integer,
    is_interstitial boolean NOT NULL,
    interstitial_clicked boolean NOT NULL
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.analytics_socialmediareviewrequest OWNER TO aptible;

--
-- TOC entry 364 (class 1259 OID 187572)
-- Name: analytics_socialmediareviewrequest_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.analytics_socialmediareviewrequest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_socialmediareviewrequest_id_seq OWNER TO aptible;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 364
-- Name: analytics_socialmediareviewrequest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.analytics_socialmediareviewrequest_id_seq OWNED BY public.analytics_socialmediareviewrequest.id;


--
-- TOC entry 211 (class 1259 OID 16434)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO aptible;

--
-- TOC entry 212 (class 1259 OID 16437)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO aptible;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 212
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 213 (class 1259 OID 16439)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO aptible;

--
-- TOC entry 214 (class 1259 OID 16442)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO aptible;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 214
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 215 (class 1259 OID 16444)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO aptible;

--
-- TOC entry 216 (class 1259 OID 16447)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO aptible;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 216
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 217 (class 1259 OID 16449)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO aptible;

--
-- TOC entry 218 (class 1259 OID 16452)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO aptible;

--
-- TOC entry 219 (class 1259 OID 16455)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO aptible;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 219
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 220 (class 1259 OID 16457)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO aptible;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 220
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 221 (class 1259 OID 16459)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO aptible;

--
-- TOC entry 222 (class 1259 OID 16462)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO aptible;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 222
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 223 (class 1259 OID 16464)
-- Name: axes_accessattempt; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.axes_accessattempt (
    id integer NOT NULL,
    user_agent character varying(255) NOT NULL,
    ip_address inet,
    username character varying(255),
    http_accept character varying(1025) NOT NULL,
    path_info character varying(255) NOT NULL,
    attempt_time timestamp with time zone NOT NULL,
    get_data text NOT NULL,
    post_data text NOT NULL,
    failures_since_start integer NOT NULL,
    CONSTRAINT axes_accessattempt_failures_since_start_check CHECK ((failures_since_start >= 0))
);


ALTER TABLE public.axes_accessattempt OWNER TO aptible;

--
-- TOC entry 224 (class 1259 OID 16471)
-- Name: axes_accessattempt_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.axes_accessattempt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.axes_accessattempt_id_seq OWNER TO aptible;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 224
-- Name: axes_accessattempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.axes_accessattempt_id_seq OWNED BY public.axes_accessattempt.id;


--
-- TOC entry 225 (class 1259 OID 16473)
-- Name: axes_accesslog; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.axes_accesslog (
    id integer NOT NULL,
    user_agent character varying(255) NOT NULL,
    ip_address inet,
    username character varying(255),
    http_accept character varying(1025) NOT NULL,
    path_info character varying(255) NOT NULL,
    attempt_time timestamp with time zone NOT NULL,
    logout_time timestamp with time zone
);


ALTER TABLE public.axes_accesslog OWNER TO aptible;

--
-- TOC entry 226 (class 1259 OID 16479)
-- Name: axes_accesslog_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.axes_accesslog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.axes_accesslog_id_seq OWNER TO aptible;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 226
-- Name: axes_accesslog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.axes_accesslog_id_seq OWNED BY public.axes_accesslog.id;


--
-- TOC entry 227 (class 1259 OID 16481)
-- Name: callfile; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.callfile (
    id integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    message character varying(160),
    is_processed boolean NOT NULL,
    sms_template character varying(50),
    belongs_to_id integer,
    exclude_from_reporting boolean NOT NULL,
    processed_on timestamp with time zone,
    is_persistent_callfile boolean NOT NULL,
    immediate boolean NOT NULL
);


ALTER TABLE public.callfile OWNER TO aptible;

--
-- TOC entry 228 (class 1259 OID 16484)
-- Name: callfile_customer; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.callfile_customer (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    slug character varying(15),
    scheduled_send_hour integer,
    scheduled_send_time_zone character varying(50) NOT NULL,
    operations_contact_name character varying(255),
    operations_contact_email character varying(255),
    nps_request_text character varying(160),
    from_number character varying(500),
    receives_email_alerts_for_detractors boolean NOT NULL,
    webform_nps_request_text character varying(160),
    provider_email_alerts_enabled_for_month_to_date_scores boolean NOT NULL,
    management_email_alerts_enabled_for_weekly_provider_scorecards boolean NOT NULL,
    management_email_list text,
    send_provider_month_to_date_email_alerts_on integer,
    send_management_alerts_for_provider_scorecards_on integer,
    receives_detractor_alerts_in_real_time boolean NOT NULL,
    receives_detractor_alerts_for_scores_lower_than integer NOT NULL,
    send_management_alerts_with_ticket_recaps_on integer,
    score_change_alerts_go_to character varying(1000),
    docutap_integration_customer_code character varying(100),
    medical_director_email_list character varying(1000),
    nps_post_conversation_reminder_7_8 character varying(160),
    nps_post_conversation_reminder_9_10 character varying(160),
    nps_post_conversation_reminder_0_4 character varying(160),
    docutap_go_live_date date,
    docutap_only_import_these_sites character varying(2000),
    performed_initial_dt_site_import boolean NOT NULL,
    re_survey_patients_after_x_days integer,
    sends_surveys_on_weekends boolean NOT NULL,
    send_management_alerts_for_site_scorecards_on integer,
    send_post_conversation_reminders_if_no_nps_comment boolean NOT NULL,
    reputation_dot_com_nps_survey_template_id character varying(2000),
    organization_id integer,
    external_id character varying(255) NOT NULL,
    uses_reputation_dot_com_surveys_v3 boolean NOT NULL,
    label character varying(255) NOT NULL,
    drchrono_access_token character varying(255) NOT NULL,
    drchrono_refresh_token character varying(255) NOT NULL,
    is_drchrono_integration boolean NOT NULL,
    is_athena_integration boolean NOT NULL,
    drchrono_status_fields character varying(255) NOT NULL,
    specialty character varying(50) NOT NULL,
    api_key character varying(255),
    docutap_integration_aes_key text,
    reputation_dot_com_api_key character varying(255),
    is_provider_alerts_anonymous boolean NOT NULL,
    allowed_user_email_domains character varying(255)[] NOT NULL,
    patient_id_migration_began_at timestamp with time zone,
    provider_memo text NOT NULL,
    site_memo text NOT NULL,
    is_enterprise_customer boolean NOT NULL,
    nextgen jsonb,
    is_active boolean NOT NULL,
    provider_nps_request_text character varying(160) NOT NULL,
    default_interaction_group_id integer
);


ALTER TABLE public.callfile_customer OWNER TO aptible;

--
-- TOC entry 229 (class 1259 OID 16490)
-- Name: callfile_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.callfile_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callfile_customer_id_seq OWNER TO aptible;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 229
-- Name: callfile_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.callfile_customer_id_seq OWNED BY public.callfile_customer.id;


--
-- TOC entry 230 (class 1259 OID 16492)
-- Name: callfile_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.callfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callfile_id_seq OWNER TO aptible;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 230
-- Name: callfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.callfile_id_seq OWNED BY public.callfile.id;


--
-- TOC entry 231 (class 1259 OID 16494)
-- Name: callfile_sms_template; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.callfile_sms_template (
    id integer NOT NULL
);


ALTER TABLE public.callfile_sms_template OWNER TO aptible;

--
-- TOC entry 232 (class 1259 OID 16497)
-- Name: callfile_sms_template_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.callfile_sms_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callfile_sms_template_id_seq OWNER TO aptible;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 232
-- Name: callfile_sms_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.callfile_sms_template_id_seq OWNED BY public.callfile_sms_template.id;


--
-- TOC entry 233 (class 1259 OID 16499)
-- Name: callfile_status; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.callfile_status (
    id integer NOT NULL
);


ALTER TABLE public.callfile_status OWNER TO aptible;

--
-- TOC entry 234 (class 1259 OID 16502)
-- Name: callfile_status_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.callfile_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callfile_status_id_seq OWNER TO aptible;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 234
-- Name: callfile_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.callfile_status_id_seq OWNED BY public.callfile_status.id;


--
-- TOC entry 339 (class 1259 OID 54250)
-- Name: conversations_contact; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_contact (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    first_name character varying(255) NOT NULL,
    phone_number character varying(10) NOT NULL,
    customer_id integer NOT NULL,
    site_id integer,
    email character varying(254) NOT NULL,
    last_name character varying(255) NOT NULL,
    is_opted_in_to_sms boolean NOT NULL,
    uuid uuid NOT NULL,
    channel character varying(25) NOT NULL
);


ALTER TABLE public.conversations_contact OWNER TO aptible;

--
-- TOC entry 338 (class 1259 OID 54248)
-- Name: conversations_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_contact_id_seq OWNER TO aptible;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 338
-- Name: conversations_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_contact_id_seq OWNED BY public.conversations_contact.id;


--
-- TOC entry 341 (class 1259 OID 54258)
-- Name: conversations_conversation; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_conversation (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    sent_from character varying(255) NOT NULL,
    status character varying(25) NOT NULL,
    clarification_attempts integer NOT NULL,
    comment text,
    answer text,
    score integer,
    contact_id integer NOT NULL,
    conversation_type_id integer NOT NULL,
    customer_id integer NOT NULL,
    channel character varying(25) NOT NULL,
    uuid uuid NOT NULL
);


ALTER TABLE public.conversations_conversation OWNER TO aptible;

--
-- TOC entry 340 (class 1259 OID 54256)
-- Name: conversations_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_conversation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_conversation_id_seq OWNER TO aptible;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 340
-- Name: conversations_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_conversation_id_seq OWNED BY public.conversations_conversation.id;


--
-- TOC entry 343 (class 1259 OID 54269)
-- Name: conversations_conversationtype; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_conversationtype (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    interactor_class character varying(255) NOT NULL,
    customer_id integer NOT NULL,
    summary character varying(255) NOT NULL,
    email_reply_to character varying(255) NOT NULL,
    email_sent_from character varying(255) NOT NULL,
    phone_number_sent_from character varying(10) NOT NULL
);


ALTER TABLE public.conversations_conversationtype OWNER TO aptible;

--
-- TOC entry 342 (class 1259 OID 54267)
-- Name: conversations_conversationtype_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_conversationtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_conversationtype_id_seq OWNER TO aptible;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 342
-- Name: conversations_conversationtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_conversationtype_id_seq OWNED BY public.conversations_conversationtype.id;


--
-- TOC entry 351 (class 1259 OID 54313)
-- Name: conversations_conversationtype_templates; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_conversationtype_templates (
    id integer NOT NULL,
    conversationtype_id integer NOT NULL,
    template_id integer NOT NULL
);


ALTER TABLE public.conversations_conversationtype_templates OWNER TO aptible;

--
-- TOC entry 350 (class 1259 OID 54311)
-- Name: conversations_conversationtype_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_conversationtype_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_conversationtype_templates_id_seq OWNER TO aptible;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 350
-- Name: conversations_conversationtype_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_conversationtype_templates_id_seq OWNED BY public.conversations_conversationtype_templates.id;


--
-- TOC entry 345 (class 1259 OID 54280)
-- Name: conversations_inboundmessage; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_inboundmessage (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    channel character varying(25) NOT NULL,
    sent_from character varying(255) NOT NULL,
    sent_to character varying(255) NOT NULL,
    body text NOT NULL,
    contact_id integer NOT NULL,
    conversation_id integer,
    service character varying(255) NOT NULL,
    subject text NOT NULL,
    external_id character varying(255) NOT NULL,
    mailbox_hash character varying(255) NOT NULL
);


ALTER TABLE public.conversations_inboundmessage OWNER TO aptible;

--
-- TOC entry 344 (class 1259 OID 54278)
-- Name: conversations_inboundmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_inboundmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_inboundmessage_id_seq OWNER TO aptible;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 344
-- Name: conversations_inboundmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_inboundmessage_id_seq OWNED BY public.conversations_inboundmessage.id;


--
-- TOC entry 357 (class 1259 OID 80094)
-- Name: conversations_optin; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_optin (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    slug character varying(50) NOT NULL,
    terms_and_conditions text NOT NULL,
    customer_id integer NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.conversations_optin OWNER TO aptible;

--
-- TOC entry 356 (class 1259 OID 80092)
-- Name: conversations_optin_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_optin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_optin_id_seq OWNER TO aptible;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 356
-- Name: conversations_optin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_optin_id_seq OWNED BY public.conversations_optin.id;


--
-- TOC entry 347 (class 1259 OID 54291)
-- Name: conversations_outboundmessage; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_outboundmessage (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    channel character varying(25) NOT NULL,
    sent_from character varying(255) NOT NULL,
    sent_to character varying(255) NOT NULL,
    body text NOT NULL,
    message_type character varying(255) NOT NULL,
    is_sent boolean NOT NULL,
    contact_id integer NOT NULL,
    conversation_id integer NOT NULL,
    subject text NOT NULL,
    service character varying(255) NOT NULL,
    external_id character varying(255) NOT NULL,
    mailbox_hash character varying(255) NOT NULL
);


ALTER TABLE public.conversations_outboundmessage OWNER TO aptible;

--
-- TOC entry 346 (class 1259 OID 54289)
-- Name: conversations_outboundmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_outboundmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_outboundmessage_id_seq OWNER TO aptible;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 346
-- Name: conversations_outboundmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_outboundmessage_id_seq OWNED BY public.conversations_outboundmessage.id;


--
-- TOC entry 349 (class 1259 OID 54302)
-- Name: conversations_template; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.conversations_template (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    reference_name character varying(255) NOT NULL,
    message_type character varying(255) NOT NULL,
    body text NOT NULL,
    is_default boolean NOT NULL,
    subject text NOT NULL
);


ALTER TABLE public.conversations_template OWNER TO aptible;

--
-- TOC entry 348 (class 1259 OID 54300)
-- Name: conversations_template_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.conversations_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_template_id_seq OWNER TO aptible;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 348
-- Name: conversations_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.conversations_template_id_seq OWNED BY public.conversations_template.id;


--
-- TOC entry 323 (class 1259 OID 24753)
-- Name: customer_comment_agg; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_comment_agg (
    id integer NOT NULL,
    source character varying(50) NOT NULL,
    fingerprint character varying(500) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    comment_data text NOT NULL,
    status character varying(50) NOT NULL,
    source_unique text,
    score character varying(50),
    comment_owner_id integer
);


ALTER TABLE public.customer_comment_agg OWNER TO aptible;

--
-- TOC entry 322 (class 1259 OID 24751)
-- Name: customer_comment_agg_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_comment_agg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_comment_agg_id_seq OWNER TO aptible;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 322
-- Name: customer_comment_agg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_comment_agg_id_seq OWNED BY public.customer_comment_agg.id;


--
-- TOC entry 405 (class 1259 OID 596372)
-- Name: customer_deprecatedphonenumber; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_deprecatedphonenumber (
    id integer NOT NULL,
    phone_number character varying(10) NOT NULL
);


ALTER TABLE public.customer_deprecatedphonenumber OWNER TO aptible;

--
-- TOC entry 404 (class 1259 OID 596370)
-- Name: customer_deprecatedphonenumber_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_deprecatedphonenumber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_deprecatedphonenumber_id_seq OWNER TO aptible;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 404
-- Name: customer_deprecatedphonenumber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_deprecatedphonenumber_id_seq OWNED BY public.customer_deprecatedphonenumber.id;


--
-- TOC entry 414 (class 1259 OID 802592)
-- Name: customer_legacyidentifier; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_legacyidentifier (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    value character varying(255) NOT NULL,
    patient_id integer NOT NULL
);


ALTER TABLE public.customer_legacyidentifier OWNER TO aptible;

--
-- TOC entry 413 (class 1259 OID 802590)
-- Name: customer_legacyidentifier_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_legacyidentifier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_legacyidentifier_id_seq OWNER TO aptible;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 413
-- Name: customer_legacyidentifier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_legacyidentifier_id_seq OWNED BY public.customer_legacyidentifier.id;


--
-- TOC entry 325 (class 1259 OID 24793)
-- Name: customer_linkclicktracking; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_linkclicktracking (
    id integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    for_date date,
    link_target character varying(50) NOT NULL,
    links_sent integer,
    click_count integer,
    for_site_id integer
);


ALTER TABLE public.customer_linkclicktracking OWNER TO aptible;

--
-- TOC entry 324 (class 1259 OID 24791)
-- Name: customer_linkclicktracking_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_linkclicktracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_linkclicktracking_id_seq OWNER TO aptible;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 324
-- Name: customer_linkclicktracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_linkclicktracking_id_seq OWNED BY public.customer_linkclicktracking.id;


--
-- TOC entry 331 (class 1259 OID 26377)
-- Name: customer_mergedentityhistory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_mergedentityhistory (
    id integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    old_entity_id integer,
    new_entity_id integer,
    entity_type character varying(50) NOT NULL,
    related_customer_id integer NOT NULL
);


ALTER TABLE public.customer_mergedentityhistory OWNER TO aptible;

--
-- TOC entry 330 (class 1259 OID 26375)
-- Name: customer_mergedentityhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_mergedentityhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_mergedentityhistory_id_seq OWNER TO aptible;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 330
-- Name: customer_mergedentityhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_mergedentityhistory_id_seq OWNED BY public.customer_mergedentityhistory.id;


--
-- TOC entry 363 (class 1259 OID 160729)
-- Name: customer_organization; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_organization (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    management_email_list character varying(1000),
    send_region_score_emails_on integer,
    prefix character varying(32)
);


ALTER TABLE public.customer_organization OWNER TO aptible;

--
-- TOC entry 362 (class 1259 OID 160727)
-- Name: customer_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_organization_id_seq OWNER TO aptible;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 362
-- Name: customer_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_organization_id_seq OWNED BY public.customer_organization.id;


--
-- TOC entry 369 (class 1259 OID 238283)
-- Name: customer_patient; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_patient (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(500),
    gender character varying(50),
    date_of_birth date,
    external_patient_id character varying(50),
    created_from_phone_number boolean NOT NULL,
    from_phone_number_id integer,
    uuid uuid NOT NULL,
    customer_id integer NOT NULL
)
WITH (autovacuum_vacuum_cost_limit='600', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.customer_patient OWNER TO aptible;

--
-- TOC entry 368 (class 1259 OID 238281)
-- Name: customer_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_patient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_patient_id_seq OWNER TO aptible;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 368
-- Name: customer_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_patient_id_seq OWNED BY public.customer_patient.id;


--
-- TOC entry 235 (class 1259 OID 16504)
-- Name: customer_patientoptin; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_patientoptin (
    id integer NOT NULL,
    opted_in_at timestamp with time zone NOT NULL,
    logged_in_user_id integer,
    errors text,
    related_phone_number_string character varying(10),
    customer_id integer
);


ALTER TABLE public.customer_patientoptin OWNER TO aptible;

--
-- TOC entry 236 (class 1259 OID 16510)
-- Name: customer_patientoptin_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_patientoptin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_patientoptin_id_seq OWNER TO aptible;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 236
-- Name: customer_patientoptin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_patientoptin_id_seq OWNED BY public.customer_patientoptin.id;


--
-- TOC entry 237 (class 1259 OID 16512)
-- Name: customer_patientoptout; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_patientoptout (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    created_by_id integer,
    phone_number_string character varying(10),
    successfully_opted_out_phone_number boolean NOT NULL,
    result text,
    associated_customer_ids character varying(1000)
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.customer_patientoptout OWNER TO aptible;

--
-- TOC entry 238 (class 1259 OID 16518)
-- Name: customer_patientoptout_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_patientoptout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_patientoptout_id_seq OWNER TO aptible;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 238
-- Name: customer_patientoptout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_patientoptout_id_seq OWNED BY public.customer_patientoptout.id;


--
-- TOC entry 239 (class 1259 OID 16520)
-- Name: customer_patientvisithistory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_patientvisithistory (
    id integer NOT NULL,
    created_on date NOT NULL,
    date_seen date NOT NULL,
    is_return_visit_after_bad_experience boolean NOT NULL,
    phone_number_id integer NOT NULL,
    visit_was_surveyed boolean NOT NULL,
    site_id integer,
    provider_id integer,
    is_persistent boolean NOT NULL,
    reason_for_visit character varying(255),
    visit_type character varying(255),
    related_patient_id integer,
    is_enrolled boolean
)
WITH (autovacuum_vacuum_cost_limit='600', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.customer_patientvisithistory OWNER TO aptible;

--
-- TOC entry 240 (class 1259 OID 16523)
-- Name: customer_patientvisithistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_patientvisithistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_patientvisithistory_id_seq OWNER TO aptible;

--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 240
-- Name: customer_patientvisithistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_patientvisithistory_id_seq OWNED BY public.customer_patientvisithistory.id;


--
-- TOC entry 241 (class 1259 OID 16525)
-- Name: customer_phonenumbermismatch; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_phonenumbermismatch (
    id integer NOT NULL,
    phone_number_id integer NOT NULL,
    existing_patient_id character varying(255),
    new_patient_id character varying(255),
    existing_name character varying(255),
    new_name character varying(255),
    existing_age integer,
    new_age integer,
    existing_last_treated_at_name character varying(255),
    new_last_treated_at_name character varying(255)
);


ALTER TABLE public.customer_phonenumbermismatch OWNER TO aptible;

--
-- TOC entry 242 (class 1259 OID 16531)
-- Name: customer_phonenumbermismatch_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_phonenumbermismatch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_phonenumbermismatch_id_seq OWNER TO aptible;

--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 242
-- Name: customer_phonenumbermismatch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_phonenumbermismatch_id_seq OWNED BY public.customer_phonenumbermismatch.id;


--
-- TOC entry 243 (class 1259 OID 16533)
-- Name: customer_provider; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_provider (
    id integer NOT NULL,
    created_on date NOT NULL,
    name character varying(128) NOT NULL,
    employed_by_id integer,
    pseudonyms character varying(1000) NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64) NOT NULL,
    preferred_contact_method character varying(32) NOT NULL,
    phone_number character varying(10),
    has_been_sent_welcome_email boolean NOT NULL,
    is_active boolean NOT NULL,
    no_email_needed boolean NOT NULL
);


ALTER TABLE public.customer_provider OWNER TO aptible;

--
-- TOC entry 244 (class 1259 OID 16539)
-- Name: customer_provider_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_provider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_provider_id_seq OWNER TO aptible;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 244
-- Name: customer_provider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_provider_id_seq OWNED BY public.customer_provider.id;


--
-- TOC entry 245 (class 1259 OID 16541)
-- Name: customer_scheduledappointment; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_scheduledappointment (
    id integer NOT NULL,
    created_on date NOT NULL,
    date date NOT NULL,
    patient_id integer NOT NULL,
    site_id integer NOT NULL,
    time_string character varying(15) NOT NULL
);


ALTER TABLE public.customer_scheduledappointment OWNER TO aptible;

--
-- TOC entry 246 (class 1259 OID 16544)
-- Name: customer_scheduledappointment_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_scheduledappointment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_scheduledappointment_id_seq OWNER TO aptible;

--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 246
-- Name: customer_scheduledappointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_scheduledappointment_id_seq OWNED BY public.customer_scheduledappointment.id;


--
-- TOC entry 247 (class 1259 OID 16546)
-- Name: customer_site; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_site (
    id integer NOT NULL,
    created_on date NOT NULL,
    owned_by_id integer,
    pseudonyms character varying(1000) NOT NULL,
    name character varying(255) NOT NULL,
    manager_name character varying(255),
    manager_email character varying(255),
    yelp_review_url character varying(255),
    google_review_url character varying(1000),
    facebook_review_url character varying(255),
    reputation_dot_com_location_id character varying(255),
    reputation_dot_com_ticket_owner_email character varying(255),
    patient_facing_name character varying(50),
    external_id character varying(255) NOT NULL,
    smart_survey_group character varying(255) NOT NULL,
    alerts_page_uuid uuid NOT NULL,
    is_site_alerts_enabled boolean NOT NULL,
    site_alerts_emails character varying(255)[] NOT NULL,
    site_alerts_send_day character varying(9) NOT NULL,
    social_links_missing_alert_sent_on timestamp with time zone,
    social_links_missing_alert_disabled_at timestamp with time zone,
    request_provider_nps boolean NOT NULL,
    meta jsonb
);


ALTER TABLE public.customer_site OWNER TO aptible;

--
-- TOC entry 248 (class 1259 OID 16552)
-- Name: customer_site_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_site_id_seq OWNER TO aptible;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 248
-- Name: customer_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_site_id_seq OWNED BY public.customer_site.id;


--
-- TOC entry 249 (class 1259 OID 16554)
-- Name: customer_usertocustomer; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.customer_usertocustomer (
    id integer NOT NULL,
    user_ref_id integer,
    customer_ref_id integer
);


ALTER TABLE public.customer_usertocustomer OWNER TO aptible;

--
-- TOC entry 250 (class 1259 OID 16557)
-- Name: customer_usertocustomer_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.customer_usertocustomer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_usertocustomer_id_seq OWNER TO aptible;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 250
-- Name: customer_usertocustomer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.customer_usertocustomer_id_seq OWNED BY public.customer_usertocustomer.id;


--
-- TOC entry 251 (class 1259 OID 16559)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO aptible;

--
-- TOC entry 252 (class 1259 OID 16566)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO aptible;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 252
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 253 (class 1259 OID 16568)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO aptible;

--
-- TOC entry 254 (class 1259 OID 16571)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO aptible;

--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 254
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 255 (class 1259 OID 16573)
-- Name: django_cron_cronjoblog; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_cron_cronjoblog (
    id integer NOT NULL,
    code character varying(64) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    is_success boolean NOT NULL,
    message text NOT NULL,
    ran_at_time time without time zone
);


ALTER TABLE public.django_cron_cronjoblog OWNER TO aptible;

--
-- TOC entry 256 (class 1259 OID 16579)
-- Name: django_cron_cronjoblog_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.django_cron_cronjoblog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_cron_cronjoblog_id_seq OWNER TO aptible;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 256
-- Name: django_cron_cronjoblog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.django_cron_cronjoblog_id_seq OWNED BY public.django_cron_cronjoblog.id;


--
-- TOC entry 321 (class 1259 OID 22482)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO aptible;

--
-- TOC entry 320 (class 1259 OID 22480)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO aptible;

--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 320
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 257 (class 1259 OID 16581)
-- Name: django_session; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO aptible;

--
-- TOC entry 258 (class 1259 OID 16587)
-- Name: django_site; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO aptible;

--
-- TOC entry 259 (class 1259 OID 16590)
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO aptible;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 259
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- TOC entry 423 (class 1259 OID 806089)
-- Name: domain_adminasset; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_adminasset (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    uuid uuid NOT NULL,
    asset character varying(100) NOT NULL
);


ALTER TABLE public.domain_adminasset OWNER TO aptible;

--
-- TOC entry 319 (class 1259 OID 19285)
-- Name: domain_integration_file_tracking; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_integration_file_tracking (
    id integer NOT NULL,
    file_name character varying(255),
    state character varying(24),
    event_time timestamp with time zone,
    customer_id integer,
    data_source character varying(255)
);


ALTER TABLE public.domain_integration_file_tracking OWNER TO aptible;

--
-- TOC entry 318 (class 1259 OID 19283)
-- Name: domain_integration_file_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_integration_file_tracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_integration_file_tracking_id_seq OWNER TO aptible;

--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 318
-- Name: domain_integration_file_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_integration_file_tracking_id_seq OWNED BY public.domain_integration_file_tracking.id;


--
-- TOC entry 355 (class 1259 OID 70889)
-- Name: domain_killswitch; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_killswitch (
    id integer NOT NULL,
    callfile_processing_enabled boolean NOT NULL
);


ALTER TABLE public.domain_killswitch OWNER TO aptible;

--
-- TOC entry 354 (class 1259 OID 70887)
-- Name: domain_killswitch_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_killswitch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_killswitch_id_seq OWNER TO aptible;

--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 354
-- Name: domain_killswitch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_killswitch_id_seq OWNED BY public.domain_killswitch.id;


--
-- TOC entry 260 (class 1259 OID 16592)
-- Name: domain_onetimelink; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_onetimelink (
    id integer NOT NULL,
    unique_slug character varying(50) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    was_seen boolean NOT NULL,
    link_type character varying(50),
    args text,
    was_seen_on timestamp with time zone
);


ALTER TABLE public.domain_onetimelink OWNER TO aptible;

--
-- TOC entry 261 (class 1259 OID 16598)
-- Name: domain_onetimelink_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_onetimelink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_onetimelink_id_seq OWNER TO aptible;

--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 261
-- Name: domain_onetimelink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_onetimelink_id_seq OWNED BY public.domain_onetimelink.id;


--
-- TOC entry 262 (class 1259 OID 16600)
-- Name: domain_stagedfilelog; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_stagedfilelog (
    id integer NOT NULL,
    success boolean NOT NULL,
    original_filename character varying(1000) NOT NULL,
    event_timestamp timestamp with time zone,
    local_filename character varying(1000) NOT NULL,
    user_id integer NOT NULL,
    details character varying(5000) NOT NULL,
    customer character varying(256),
    username character varying(256)
);


ALTER TABLE public.domain_stagedfilelog OWNER TO aptible;

--
-- TOC entry 263 (class 1259 OID 16606)
-- Name: domain_stagedfilelog_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_stagedfilelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_stagedfilelog_id_seq OWNER TO aptible;

--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 263
-- Name: domain_stagedfilelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_stagedfilelog_id_seq OWNED BY public.domain_stagedfilelog.id;


--
-- TOC entry 337 (class 1259 OID 33698)
-- Name: domain_thirdpartyapiuser; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_thirdpartyapiuser (
    id integer NOT NULL,
    name character varying(255),
    created_on timestamp with time zone,
    has_access_to_customer_ids character varying(1000),
    api_key character varying(255)
);


ALTER TABLE public.domain_thirdpartyapiuser OWNER TO aptible;

--
-- TOC entry 336 (class 1259 OID 33696)
-- Name: domain_thirdpartyapiuser_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_thirdpartyapiuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_thirdpartyapiuser_id_seq OWNER TO aptible;

--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 336
-- Name: domain_thirdpartyapiuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_thirdpartyapiuser_id_seq OWNED BY public.domain_thirdpartyapiuser.id;


--
-- TOC entry 317 (class 1259 OID 17801)
-- Name: domain_usersessionhistory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.domain_usersessionhistory (
    id integer NOT NULL,
    associated_user_id integer NOT NULL,
    date_in_est date,
    session_key character varying(255),
    session_started_on timestamp with time zone,
    session_last_touched_on timestamp with time zone
);


ALTER TABLE public.domain_usersessionhistory OWNER TO aptible;

--
-- TOC entry 316 (class 1259 OID 17799)
-- Name: domain_usersessionhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.domain_usersessionhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_usersessionhistory_id_seq OWNER TO aptible;

--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 316
-- Name: domain_usersessionhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.domain_usersessionhistory_id_seq OWNED BY public.domain_usersessionhistory.id;


--
-- TOC entry 469 (class 1259 OID 882927)
-- Name: immediate_heldvisit; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.immediate_heldvisit (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    hold_until timestamp with time zone,
    enrolled_at timestamp with time zone,
    "on" date NOT NULL,
    at timestamp with time zone,
    classification character varying(128) NOT NULL,
    description character varying(255) NOT NULL,
    identifier character varying(128) NOT NULL,
    phone character varying(128) NOT NULL,
    email character varying(254) NOT NULL,
    surname character varying(64) NOT NULL,
    forename character varying(64) NOT NULL,
    birthdate date,
    site character varying(128) NOT NULL,
    provider character varying(128) NOT NULL,
    schedule_id integer NOT NULL,
    site_meta jsonb,
    kafka_visit_type character varying(128) NOT NULL
);


ALTER TABLE public.immediate_heldvisit OWNER TO aptible;

--
-- TOC entry 468 (class 1259 OID 882925)
-- Name: immediate_heldvisit_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.immediate_heldvisit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.immediate_heldvisit_id_seq OWNER TO aptible;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 468
-- Name: immediate_heldvisit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.immediate_heldvisit_id_seq OWNED BY public.immediate_heldvisit.id;


--
-- TOC entry 467 (class 1259 OID 882917)
-- Name: immediate_immediateschedule; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.immediate_immediateschedule (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enabled boolean NOT NULL,
    opening time without time zone NOT NULL,
    closing time without time zone NOT NULL,
    customer_id integer NOT NULL,
    delay interval NOT NULL,
    whitelist boolean NOT NULL,
    eps_visits boolean NOT NULL,
    workcomp_visits boolean NOT NULL
);


ALTER TABLE public.immediate_immediateschedule OWNER TO aptible;

--
-- TOC entry 466 (class 1259 OID 882915)
-- Name: immediate_immediateschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.immediate_immediateschedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.immediate_immediateschedule_id_seq OWNER TO aptible;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 466
-- Name: immediate_immediateschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.immediate_immediateschedule_id_seq OWNED BY public.immediate_immediateschedule.id;


--
-- TOC entry 473 (class 1259 OID 965253)
-- Name: immediate_mappingkey; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.immediate_mappingkey (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    key character varying(64) NOT NULL,
    schedule_id integer NOT NULL,
    delay interval
);


ALTER TABLE public.immediate_mappingkey OWNER TO aptible;

--
-- TOC entry 472 (class 1259 OID 965251)
-- Name: immediate_mappingkey_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.immediate_mappingkey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.immediate_mappingkey_id_seq OWNER TO aptible;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 472
-- Name: immediate_mappingkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.immediate_mappingkey_id_seq OWNED BY public.immediate_mappingkey.id;


--
-- TOC entry 475 (class 1259 OID 965298)
-- Name: immediate_whitelistedsite; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.immediate_whitelistedsite (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    schedule_id integer NOT NULL
);


ALTER TABLE public.immediate_whitelistedsite OWNER TO aptible;

--
-- TOC entry 474 (class 1259 OID 965296)
-- Name: immediate_whitelistedsite_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.immediate_whitelistedsite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.immediate_whitelistedsite_id_seq OWNER TO aptible;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 474
-- Name: immediate_whitelistedsite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.immediate_whitelistedsite_id_seq OWNED BY public.immediate_whitelistedsite.id;


--
-- TOC entry 383 (class 1259 OID 538689)
-- Name: mercury_conversation; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_conversation (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    sent_from character varying(10) NOT NULL,
    sent_to character varying(10) NOT NULL,
    status character varying(25) NOT NULL,
    context text NOT NULL,
    interaction_id integer NOT NULL,
    interaction_group_id integer NOT NULL,
    phone_number_id integer NOT NULL,
    created_date date NOT NULL,
    boolean_slot_0 boolean,
    boolean_slot_1 boolean,
    boolean_slot_2 boolean,
    integer_slot_0 integer,
    text_slot_0 character varying(255) NOT NULL,
    text_slot_1 character varying(255) NOT NULL,
    text_slot_2 character varying(255) NOT NULL,
    text_slot_3 character varying(255) NOT NULL,
    text_slot_4 character varying(255) NOT NULL,
    date_slot_0 date
);


ALTER TABLE public.mercury_conversation OWNER TO aptible;

--
-- TOC entry 382 (class 1259 OID 538687)
-- Name: mercury_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_conversation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_conversation_id_seq OWNER TO aptible;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 382
-- Name: mercury_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_conversation_id_seq OWNED BY public.mercury_conversation.id;


--
-- TOC entry 385 (class 1259 OID 538700)
-- Name: mercury_inboundmessage; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_inboundmessage (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    external_id character varying(255) NOT NULL,
    sent_from character varying(10) NOT NULL,
    sent_to character varying(10) NOT NULL,
    body text NOT NULL,
    conversation_id integer,
    phone_number_id integer
);


ALTER TABLE public.mercury_inboundmessage OWNER TO aptible;

--
-- TOC entry 384 (class 1259 OID 538698)
-- Name: mercury_inboundmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_inboundmessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_inboundmessage_id_seq OWNER TO aptible;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 384
-- Name: mercury_inboundmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_inboundmessage_id_seq OWNED BY public.mercury_inboundmessage.id;


--
-- TOC entry 387 (class 1259 OID 538711)
-- Name: mercury_interaction; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_interaction (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    interactor_class character varying(100) NOT NULL,
    condition character varying(255) NOT NULL,
    is_default boolean NOT NULL,
    interaction_group_id integer NOT NULL,
    description character varying(255) NOT NULL,
    interactor_configuration character varying(255) NOT NULL,
    slots_configuration character varying(255) NOT NULL
);


ALTER TABLE public.mercury_interaction OWNER TO aptible;

--
-- TOC entry 386 (class 1259 OID 538709)
-- Name: mercury_interaction_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_interaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_interaction_id_seq OWNER TO aptible;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 386
-- Name: mercury_interaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_interaction_id_seq OWNED BY public.mercury_interaction.id;


--
-- TOC entry 389 (class 1259 OID 538719)
-- Name: mercury_interactiongroup; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_interactiongroup (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "group" character varying(255) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.mercury_interactiongroup OWNER TO aptible;

--
-- TOC entry 388 (class 1259 OID 538717)
-- Name: mercury_interactiongroup_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_interactiongroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_interactiongroup_id_seq OWNER TO aptible;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 388
-- Name: mercury_interactiongroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_interactiongroup_id_seq OWNED BY public.mercury_interactiongroup.id;


--
-- TOC entry 391 (class 1259 OID 538730)
-- Name: mercury_outboundmessage; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_outboundmessage (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    external_id character varying(255) NOT NULL,
    sent_from character varying(10) NOT NULL,
    sent_to character varying(10) NOT NULL,
    body text NOT NULL,
    message_type character varying(50) NOT NULL,
    is_sent boolean NOT NULL,
    conversation_id integer NOT NULL,
    phone_number_id integer
);


ALTER TABLE public.mercury_outboundmessage OWNER TO aptible;

--
-- TOC entry 390 (class 1259 OID 538728)
-- Name: mercury_outboundmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_outboundmessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_outboundmessage_id_seq OWNER TO aptible;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 390
-- Name: mercury_outboundmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_outboundmessage_id_seq OWNED BY public.mercury_outboundmessage.id;


--
-- TOC entry 393 (class 1259 OID 538741)
-- Name: mercury_phonenumber; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_phonenumber (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    uuid uuid NOT NULL,
    number character varying(10) NOT NULL,
    "group" character varying(255) NOT NULL
);


ALTER TABLE public.mercury_phonenumber OWNER TO aptible;

--
-- TOC entry 392 (class 1259 OID 538739)
-- Name: mercury_phonenumber_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_phonenumber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_phonenumber_id_seq OWNER TO aptible;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 392
-- Name: mercury_phonenumber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_phonenumber_id_seq OWNED BY public.mercury_phonenumber.id;


--
-- TOC entry 395 (class 1259 OID 538749)
-- Name: mercury_template; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.mercury_template (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    body text NOT NULL,
    interaction_id integer NOT NULL,
    outbound_message_type character varying(50) NOT NULL
);


ALTER TABLE public.mercury_template OWNER TO aptible;

--
-- TOC entry 394 (class 1259 OID 538747)
-- Name: mercury_template_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.mercury_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mercury_template_id_seq OWNER TO aptible;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 394
-- Name: mercury_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.mercury_template_id_seq OWNED BY public.mercury_template.id;


--
-- TOC entry 416 (class 1259 OID 804557)
-- Name: notices_autoresponse; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.notices_autoresponse (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    envelope_id integer NOT NULL,
    message_id integer
);


ALTER TABLE public.notices_autoresponse OWNER TO aptible;

--
-- TOC entry 415 (class 1259 OID 804555)
-- Name: notices_autoresponse_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.notices_autoresponse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notices_autoresponse_id_seq OWNER TO aptible;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 415
-- Name: notices_autoresponse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.notices_autoresponse_id_seq OWNED BY public.notices_autoresponse.id;


--
-- TOC entry 418 (class 1259 OID 804565)
-- Name: notices_batch; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.notices_batch (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    opening date NOT NULL,
    closing date NOT NULL,
    preparing_at timestamp with time zone,
    prepared_at timestamp with time zone,
    preparation_exception_at timestamp with time zone,
    sending_at timestamp with time zone,
    completed_at timestamp with time zone,
    notice_id integer NOT NULL,
    send_at timestamp with time zone
);


ALTER TABLE public.notices_batch OWNER TO aptible;

--
-- TOC entry 417 (class 1259 OID 804563)
-- Name: notices_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.notices_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notices_batch_id_seq OWNER TO aptible;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 417
-- Name: notices_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.notices_batch_id_seq OWNED BY public.notices_batch.id;


--
-- TOC entry 420 (class 1259 OID 804573)
-- Name: notices_envelope; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.notices_envelope (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    exception_at timestamp with time zone,
    batch_id integer NOT NULL,
    message_id integer,
    notice_id integer NOT NULL,
    patient_id integer NOT NULL,
    phone_id integer NOT NULL,
    visit_id integer NOT NULL
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.notices_envelope OWNER TO aptible;

--
-- TOC entry 419 (class 1259 OID 804571)
-- Name: notices_envelope_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.notices_envelope_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notices_envelope_id_seq OWNER TO aptible;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 419
-- Name: notices_envelope_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.notices_envelope_id_seq OWNED BY public.notices_envelope.id;


--
-- TOC entry 422 (class 1259 OID 804583)
-- Name: notices_notice; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.notices_notice (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content text NOT NULL,
    auto_response text NOT NULL,
    customer_id integer NOT NULL,
    auto_response_period interval NOT NULL
);


ALTER TABLE public.notices_notice OWNER TO aptible;

--
-- TOC entry 421 (class 1259 OID 804581)
-- Name: notices_notice_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.notices_notice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notices_notice_id_seq OWNER TO aptible;

--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 421
-- Name: notices_notice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.notices_notice_id_seq OWNED BY public.notices_notice.id;


--
-- TOC entry 377 (class 1259 OID 356566)
-- Name: nps_sitesocialmediainterstitialpage; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.nps_sitesocialmediainterstitialpage (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    template text NOT NULL,
    site_id integer NOT NULL,
    display_facebook_review_url boolean NOT NULL,
    display_google_review_url boolean NOT NULL,
    display_yelp_review_url boolean NOT NULL,
    review_site_order character varying(255) NOT NULL
);


ALTER TABLE public.nps_sitesocialmediainterstitialpage OWNER TO aptible;

--
-- TOC entry 376 (class 1259 OID 356564)
-- Name: nps_sitesocialmediainterstitialpage_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.nps_sitesocialmediainterstitialpage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nps_sitesocialmediainterstitialpage_id_seq OWNER TO aptible;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 376
-- Name: nps_sitesocialmediainterstitialpage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.nps_sitesocialmediainterstitialpage_id_seq OWNED BY public.nps_sitesocialmediainterstitialpage.id;


--
-- TOC entry 371 (class 1259 OID 315976)
-- Name: nps_socialmediainterstitial; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.nps_socialmediainterstitial (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    uuid uuid NOT NULL,
    social_media_type character varying(25) NOT NULL,
    redirect_to_url text,
    phone_number_id integer NOT NULL,
    site_social_media_interstitial_page_id integer
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.nps_socialmediainterstitial OWNER TO aptible;

--
-- TOC entry 370 (class 1259 OID 315974)
-- Name: nps_socialmediainterstitial_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.nps_socialmediainterstitial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nps_socialmediainterstitial_id_seq OWNER TO aptible;

--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 370
-- Name: nps_socialmediainterstitial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.nps_socialmediainterstitial_id_seq OWNED BY public.nps_socialmediainterstitial.id;


--
-- TOC entry 373 (class 1259 OID 315987)
-- Name: nps_visit; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.nps_visit (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    http_user_agent text NOT NULL,
    social_media_interstitial_id integer NOT NULL
);


ALTER TABLE public.nps_visit OWNER TO aptible;

--
-- TOC entry 372 (class 1259 OID 315985)
-- Name: nps_visit_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.nps_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nps_visit_id_seq OWNER TO aptible;

--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 372
-- Name: nps_visit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.nps_visit_id_seq OWNED BY public.nps_visit.id;


--
-- TOC entry 264 (class 1259 OID 16608)
-- Name: phone_number; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.phone_number (
    id integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    belongs_to_id integer NOT NULL,
    do_not_contact boolean NOT NULL,
    confirmed_mobile_number boolean NOT NULL,
    last_four character varying(20) NOT NULL,
    contact_for_follow_up boolean NOT NULL,
    treated_by character varying(255),
    is_disgruntled_user boolean NOT NULL,
    is_undeliverable_number boolean NOT NULL,
    sent_request_for_contact_to_customer boolean NOT NULL,
    last_attempted_contact_on date,
    customer_facility character varying(255),
    number_of_times_seen integer,
    contact_for_follow_up_requested_at timestamp with time zone,
    sent_request_for_contact_to_customer_at timestamp with time zone,
    last_treated_by_id integer,
    age integer,
    last_treated_for character varying(255),
    last_treated_at_id integer,
    email character varying(500),
    gender character varying(50),
    date_of_birth date,
    notes character varying(1000),
    opt_out_confirmation_sent_on timestamp with time zone,
    wrong_number boolean NOT NULL,
    checked_undelievered_number_against_api boolean NOT NULL,
    verified_landline boolean NOT NULL,
    verified_mobile boolean NOT NULL,
    last_used_from_number_for_contact character varying(100),
    external_patient_id character varying(255),
    first_name character varying(255) NOT NULL,
    last_name character varying(255),
    last_seen_on character varying(255),
    phone_number character varying(255) NOT NULL
)
WITH (autovacuum_vacuum_cost_limit='600', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.phone_number OWNER TO aptible;

--
-- TOC entry 265 (class 1259 OID 16614)
-- Name: phone_number_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.phone_number_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phone_number_id_seq OWNER TO aptible;

--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 265
-- Name: phone_number_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.phone_number_id_seq OWNED BY public.phone_number.id;


--
-- TOC entry 266 (class 1259 OID 16616)
-- Name: reminders_reminder; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reminders_reminder (
    id integer NOT NULL,
    type character varying(32) NOT NULL,
    is_set_for_id integer NOT NULL,
    scheduled_send_hour integer,
    scheduled_send_time_zone character varying(50) NOT NULL
);


ALTER TABLE public.reminders_reminder OWNER TO aptible;

--
-- TOC entry 267 (class 1259 OID 16619)
-- Name: reminders_reminder_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reminders_reminder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reminders_reminder_id_seq OWNER TO aptible;

--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 267
-- Name: reminders_reminder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reminders_reminder_id_seq OWNED BY public.reminders_reminder.id;


--
-- TOC entry 465 (class 1259 OID 875407)
-- Name: reputation_actionthreshold; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_actionthreshold (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    threshold smallint NOT NULL,
    account_id integer NOT NULL,
    actor_id integer NOT NULL,
    CONSTRAINT reputation_actionthreshold_threshold_check CHECK ((threshold >= 0))
);


ALTER TABLE public.reputation_actionthreshold OWNER TO aptible;

--
-- TOC entry 464 (class 1259 OID 875405)
-- Name: reputation_actionthreshold_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_actionthreshold_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_actionthreshold_id_seq OWNER TO aptible;

--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 464
-- Name: reputation_actionthreshold_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_actionthreshold_id_seq OWNED BY public.reputation_actionthreshold.id;


--
-- TOC entry 471 (class 1259 OID 923168)
-- Name: reputation_competitor; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_competitor (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    place_id character varying(64) NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE public.reputation_competitor OWNER TO aptible;

--
-- TOC entry 470 (class 1259 OID 923166)
-- Name: reputation_competitor_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_competitor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_competitor_id_seq OWNER TO aptible;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 470
-- Name: reputation_competitor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_competitor_id_seq OWNED BY public.reputation_competitor.id;


--
-- TOC entry 451 (class 1259 OID 851689)
-- Name: reputation_gmbaccount; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmbaccount (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(128) NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE public.reputation_gmbaccount OWNER TO aptible;

--
-- TOC entry 450 (class 1259 OID 851687)
-- Name: reputation_gmbaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmbaccount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmbaccount_id_seq OWNER TO aptible;

--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 450
-- Name: reputation_gmbaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmbaccount_id_seq OWNED BY public.reputation_gmbaccount.id;


--
-- TOC entry 453 (class 1259 OID 851697)
-- Name: reputation_gmblocation; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmblocation (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(128) NOT NULL,
    account_id integer NOT NULL,
    site_id integer NOT NULL,
    place_id character varying(64) NOT NULL,
    keyword character varying(64) NOT NULL
);


ALTER TABLE public.reputation_gmblocation OWNER TO aptible;

--
-- TOC entry 452 (class 1259 OID 851695)
-- Name: reputation_gmblocation_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmblocation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmblocation_id_seq OWNER TO aptible;

--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 452
-- Name: reputation_gmblocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmblocation_id_seq OWNED BY public.reputation_gmblocation.id;


--
-- TOC entry 459 (class 1259 OID 851729)
-- Name: reputation_gmbnotification; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmbnotification (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    notes text NOT NULL,
    review_id integer NOT NULL
);


ALTER TABLE public.reputation_gmbnotification OWNER TO aptible;

--
-- TOC entry 458 (class 1259 OID 851727)
-- Name: reputation_gmbnotification_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmbnotification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmbnotification_id_seq OWNER TO aptible;

--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 458
-- Name: reputation_gmbnotification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmbnotification_id_seq OWNED BY public.reputation_gmbnotification.id;


--
-- TOC entry 461 (class 1259 OID 851740)
-- Name: reputation_gmbnotifyee; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmbnotifyee (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    email character varying(254) NOT NULL,
    threshold smallint NOT NULL,
    customer_id integer NOT NULL,
    CONSTRAINT reputation_gmbnotifyee_threshold_check CHECK ((threshold >= 0))
);


ALTER TABLE public.reputation_gmbnotifyee OWNER TO aptible;

--
-- TOC entry 460 (class 1259 OID 851738)
-- Name: reputation_gmbnotifyee_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmbnotifyee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmbnotifyee_id_seq OWNER TO aptible;

--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 460
-- Name: reputation_gmbnotifyee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmbnotifyee_id_seq OWNED BY public.reputation_gmbnotifyee.id;


--
-- TOC entry 457 (class 1259 OID 851718)
-- Name: reputation_gmbreplyaction; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmbreplyaction (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    action character varying(64) NOT NULL,
    text text NOT NULL,
    review_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.reputation_gmbreplyaction OWNER TO aptible;

--
-- TOC entry 456 (class 1259 OID 851716)
-- Name: reputation_gmbreplyaction_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmbreplyaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmbreplyaction_id_seq OWNER TO aptible;

--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 456
-- Name: reputation_gmbreplyaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmbreplyaction_id_seq OWNED BY public.reputation_gmbreplyaction.id;


--
-- TOC entry 455 (class 1259 OID 851707)
-- Name: reputation_gmbreview; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_gmbreview (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(512) NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE public.reputation_gmbreview OWNER TO aptible;

--
-- TOC entry 454 (class 1259 OID 851705)
-- Name: reputation_gmbreview_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_gmbreview_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_gmbreview_id_seq OWNER TO aptible;

--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 454
-- Name: reputation_gmbreview_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_gmbreview_id_seq OWNED BY public.reputation_gmbreview.id;


--
-- TOC entry 463 (class 1259 OID 875378)
-- Name: reputation_reviewticket; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reputation_reviewticket (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    creator_id integer NOT NULL,
    review_id integer NOT NULL,
    ticket_id integer NOT NULL,
    automatic boolean NOT NULL
);


ALTER TABLE public.reputation_reviewticket OWNER TO aptible;

--
-- TOC entry 462 (class 1259 OID 875376)
-- Name: reputation_reviewticket_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reputation_reviewticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reputation_reviewticket_id_seq OWNER TO aptible;

--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 462
-- Name: reputation_reviewticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reputation_reviewticket_id_seq OWNED BY public.reputation_reviewticket.id;


--
-- TOC entry 359 (class 1259 OID 120236)
-- Name: reviews_feed; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reviews_feed (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    activation_date date NOT NULL,
    uuid uuid NOT NULL,
    pagination_size integer NOT NULL,
    site_id integer NOT NULL,
    css text NOT NULL,
    address_locality character varying(255) NOT NULL,
    address_region character varying(2) NOT NULL,
    postal_code character varying(10) NOT NULL,
    street_address character varying(255) NOT NULL,
    telephone character varying(25) NOT NULL
);


ALTER TABLE public.reviews_feed OWNER TO aptible;

--
-- TOC entry 358 (class 1259 OID 120234)
-- Name: reviews_feed_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reviews_feed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_feed_id_seq OWNER TO aptible;

--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 358
-- Name: reviews_feed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reviews_feed_id_seq OWNED BY public.reviews_feed.id;


--
-- TOC entry 361 (class 1259 OID 120246)
-- Name: reviews_review; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.reviews_review (
    id integer NOT NULL,
    published_at timestamp with time zone NOT NULL,
    date_of_visit date NOT NULL,
    score integer NOT NULL,
    comment text NOT NULL,
    feed_id integer NOT NULL,
    ticket_id integer NOT NULL
);


ALTER TABLE public.reviews_review OWNER TO aptible;

--
-- TOC entry 360 (class 1259 OID 120244)
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.reviews_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_review_id_seq OWNER TO aptible;

--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 360
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews_review.id;


--
-- TOC entry 407 (class 1259 OID 676806)
-- Name: securedrop_drop; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.securedrop_drop (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    text text NOT NULL,
    is_dropped boolean NOT NULL,
    company character varying(255) NOT NULL,
    email character varying(255) NOT NULL
);


ALTER TABLE public.securedrop_drop OWNER TO aptible;

--
-- TOC entry 406 (class 1259 OID 676804)
-- Name: securedrop_drop_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.securedrop_drop_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.securedrop_drop_id_seq OWNER TO aptible;

--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 406
-- Name: securedrop_drop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.securedrop_drop_id_seq OWNED BY public.securedrop_drop.id;


--
-- TOC entry 409 (class 1259 OID 676817)
-- Name: securedrop_pickup; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.securedrop_pickup (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    text text NOT NULL,
    is_picked_up boolean NOT NULL
);


ALTER TABLE public.securedrop_pickup OWNER TO aptible;

--
-- TOC entry 408 (class 1259 OID 676815)
-- Name: securedrop_pickup_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.securedrop_pickup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.securedrop_pickup_id_seq OWNER TO aptible;

--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 408
-- Name: securedrop_pickup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.securedrop_pickup_id_seq OWNED BY public.securedrop_pickup.id;


--
-- TOC entry 268 (class 1259 OID 16621)
-- Name: sms_callfilehistory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sms_callfilehistory (
    id integer NOT NULL,
    created_on date NOT NULL,
    phone_number_id integer NOT NULL,
    callfile_id integer NOT NULL
)
WITH (autovacuum_vacuum_cost_limit='400', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.sms_callfilehistory OWNER TO aptible;

--
-- TOC entry 269 (class 1259 OID 16624)
-- Name: sms_callfilehistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sms_callfilehistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_callfilehistory_id_seq OWNER TO aptible;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 269
-- Name: sms_callfilehistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sms_callfilehistory_id_seq OWNED BY public.sms_callfilehistory.id;


--
-- TOC entry 270 (class 1259 OID 16626)
-- Name: sms_message; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sms_message (
    id integer NOT NULL,
    intended_recipient_id integer NOT NULL,
    message character varying(1000),
    status character varying(20),
    created_on timestamp with time zone,
    plivo_message_uuid character varying(50),
    calibrater_template character varying(50),
    twilio_message_sid character varying(50),
    sms_gateway character varying(50),
    twilio_error_code character varying(50),
    twilio_error_message character varying(50),
    likely_from_number character varying(10),
    destination character varying(128)
)
WITH (autovacuum_vacuum_cost_limit='800', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.sms_message OWNER TO aptible;

--
-- TOC entry 271 (class 1259 OID 16632)
-- Name: sms_message_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sms_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_message_id_seq OWNER TO aptible;

--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 271
-- Name: sms_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sms_message_id_seq OWNED BY public.sms_message.id;


--
-- TOC entry 272 (class 1259 OID 16634)
-- Name: sms_message_incoming; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sms_message_incoming (
    id integer NOT NULL,
    message character varying(1000),
    from_number_id integer,
    created_on timestamp with time zone,
    to_number character varying(20),
    sms_gateway character varying(50),
    plivo_message_uuid character varying(50),
    twilio_message_sid character varying(50),
    last_outgoing_sms_template_used character varying(50),
    stripped_number_from_message integer,
    nps_response_with_no_number boolean NOT NULL,
    responded_with_sms_template character varying(50),
    was_reviewed_internally boolean NOT NULL,
    message_forwarded_to_customer boolean NOT NULL,
    is_potential_vignette boolean NOT NULL,
    was_converted_to_survey_response boolean NOT NULL,
    queued_to_forward_to_customer boolean NOT NULL,
    provider_nps_response_with_no_number boolean
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='600');


ALTER TABLE public.sms_message_incoming OWNER TO aptible;

--
-- TOC entry 273 (class 1259 OID 16640)
-- Name: sms_message_incoming_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sms_message_incoming_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_message_incoming_id_seq OWNER TO aptible;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 273
-- Name: sms_message_incoming_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sms_message_incoming_id_seq OWNED BY public.sms_message_incoming.id;


--
-- TOC entry 274 (class 1259 OID 16642)
-- Name: sms_message_incoming_unrecognized; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sms_message_incoming_unrecognized (
    id integer NOT NULL,
    from_number character varying(20),
    to_number character varying(20),
    message character varying(1000),
    created_on timestamp with time zone,
    sms_gateway character varying(51),
    message_id character varying(50)
);


ALTER TABLE public.sms_message_incoming_unrecognized OWNER TO aptible;

--
-- TOC entry 275 (class 1259 OID 16648)
-- Name: sms_message_incoming_unrecognized_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sms_message_incoming_unrecognized_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_message_incoming_unrecognized_id_seq OWNER TO aptible;

--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 275
-- Name: sms_message_incoming_unrecognized_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sms_message_incoming_unrecognized_id_seq OWNED BY public.sms_message_incoming_unrecognized.id;


--
-- TOC entry 276 (class 1259 OID 16650)
-- Name: socialaccount_socialaccount; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.socialaccount_socialaccount (
    id integer NOT NULL,
    user_id integer NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    provider character varying(30) NOT NULL,
    uid character varying(191) NOT NULL,
    extra_data text NOT NULL
);


ALTER TABLE public.socialaccount_socialaccount OWNER TO aptible;

--
-- TOC entry 277 (class 1259 OID 16656)
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.socialaccount_socialaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialaccount_id_seq OWNER TO aptible;

--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 277
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.socialaccount_socialaccount_id_seq OWNED BY public.socialaccount_socialaccount.id;


--
-- TOC entry 278 (class 1259 OID 16658)
-- Name: socialaccount_socialapp; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.socialaccount_socialapp (
    id integer NOT NULL,
    provider character varying(30) NOT NULL,
    name character varying(40) NOT NULL,
    key character varying(191) NOT NULL,
    secret character varying(191) NOT NULL,
    client_id character varying(191) NOT NULL
);


ALTER TABLE public.socialaccount_socialapp OWNER TO aptible;

--
-- TOC entry 279 (class 1259 OID 16661)
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.socialaccount_socialapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialapp_id_seq OWNER TO aptible;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 279
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.socialaccount_socialapp_id_seq OWNED BY public.socialaccount_socialapp.id;


--
-- TOC entry 280 (class 1259 OID 16663)
-- Name: socialaccount_socialapp_sites; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.socialaccount_socialapp_sites (
    id integer NOT NULL,
    socialapp_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialapp_sites OWNER TO aptible;

--
-- TOC entry 281 (class 1259 OID 16666)
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.socialaccount_socialapp_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialapp_sites_id_seq OWNER TO aptible;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 281
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.socialaccount_socialapp_sites_id_seq OWNED BY public.socialaccount_socialapp_sites.id;


--
-- TOC entry 282 (class 1259 OID 16668)
-- Name: socialaccount_socialtoken; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.socialaccount_socialtoken (
    id integer NOT NULL,
    app_id integer NOT NULL,
    account_id integer NOT NULL,
    token text NOT NULL,
    token_secret text NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.socialaccount_socialtoken OWNER TO aptible;

--
-- TOC entry 283 (class 1259 OID 16674)
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.socialaccount_socialtoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.socialaccount_socialtoken_id_seq OWNER TO aptible;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 283
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.socialaccount_socialtoken_id_seq OWNED BY public.socialaccount_socialtoken.id;


--
-- TOC entry 449 (class 1259 OID 846491)
-- Name: sources_customercode; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sources_customercode (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    code character varying(128) NOT NULL,
    customer_id integer NOT NULL,
    source_id integer NOT NULL
);


ALTER TABLE public.sources_customercode OWNER TO aptible;

--
-- TOC entry 448 (class 1259 OID 846489)
-- Name: sources_customercode_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sources_customercode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sources_customercode_id_seq OWNER TO aptible;

--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 448
-- Name: sources_customercode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sources_customercode_id_seq OWNED BY public.sources_customercode.id;


--
-- TOC entry 447 (class 1259 OID 846480)
-- Name: sources_internalasset; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sources_internalasset (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(256) NOT NULL,
    succeeded_at timestamp with time zone,
    failed_at timestamp with time zone,
    notes text NOT NULL,
    source_id integer NOT NULL,
    file character varying(512) NOT NULL
);


ALTER TABLE public.sources_internalasset OWNER TO aptible;

--
-- TOC entry 446 (class 1259 OID 846478)
-- Name: sources_internalasset_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sources_internalasset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sources_internalasset_id_seq OWNER TO aptible;

--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 446
-- Name: sources_internalasset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sources_internalasset_id_seq OWNED BY public.sources_internalasset.id;


--
-- TOC entry 443 (class 1259 OID 846461)
-- Name: sources_internalsource; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sources_internalsource (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    directory character varying(128) NOT NULL,
    pattern character varying(128) NOT NULL,
    "time" time without time zone NOT NULL,
    deactivated_at timestamp with time zone,
    integration character varying(64) NOT NULL,
    organization_id integer,
    customer_id integer,
    opening date
);


ALTER TABLE public.sources_internalsource OWNER TO aptible;

--
-- TOC entry 442 (class 1259 OID 846459)
-- Name: sources_internalsource_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sources_internalsource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sources_internalsource_id_seq OWNER TO aptible;

--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 442
-- Name: sources_internalsource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sources_internalsource_id_seq OWNED BY public.sources_internalsource.id;


--
-- TOC entry 445 (class 1259 OID 846469)
-- Name: sources_internalsourcecheck; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sources_internalsourcecheck (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    checked_at timestamp with time zone NOT NULL,
    notes text NOT NULL,
    source_id integer NOT NULL
);


ALTER TABLE public.sources_internalsourcecheck OWNER TO aptible;

--
-- TOC entry 444 (class 1259 OID 846467)
-- Name: sources_internalsourcecheck_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.sources_internalsourcecheck_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sources_internalsourcecheck_id_seq OWNER TO aptible;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 444
-- Name: sources_internalsourcecheck_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.sources_internalsourcecheck_id_seq OWNED BY public.sources_internalsourcecheck.id;


--
-- TOC entry 284 (class 1259 OID 16676)
-- Name: south_migrationhistory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.south_migrationhistory (
    id integer NOT NULL,
    app_name character varying(255) NOT NULL,
    migration character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.south_migrationhistory OWNER TO aptible;

--
-- TOC entry 285 (class 1259 OID 16682)
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.south_migrationhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.south_migrationhistory_id_seq OWNER TO aptible;

--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 285
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.south_migrationhistory_id_seq OWNED BY public.south_migrationhistory.id;


--
-- TOC entry 410 (class 1259 OID 780076)
-- Name: sso_samlprovider; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.sso_samlprovider (
    uuid uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    meta character varying(200) NOT NULL,
    organization_id integer NOT NULL
);


ALTER TABLE public.sso_samlprovider OWNER TO aptible;

--
-- TOC entry 286 (class 1259 OID 16684)
-- Name: stage_raw_files_for_import; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.stage_raw_files_for_import (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    created_on timestamp with time zone,
    asset character varying(100) NOT NULL
);


ALTER TABLE public.stage_raw_files_for_import OWNER TO aptible;

--
-- TOC entry 287 (class 1259 OID 16687)
-- Name: stage_raw_files_for_import_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.stage_raw_files_for_import_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stage_raw_files_for_import_id_seq OWNER TO aptible;

--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 287
-- Name: stage_raw_files_for_import_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.stage_raw_files_for_import_id_seq OWNED BY public.stage_raw_files_for_import.id;


--
-- TOC entry 288 (class 1259 OID 16689)
-- Name: staged_patient_data; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.staged_patient_data (
    id integer NOT NULL,
    patient_name character varying(255),
    date_of_service date,
    facility character varying(255),
    phone1_type character varying(255),
    phone2 character varying(255),
    phone2_type character varying(255),
    phone3 character varying(255),
    phone3_type character varying(255),
    age character varying(255),
    email character varying(255),
    date_of_birth date,
    external_patient_id character varying(255),
    treated_by character varying(255),
    phone_number character varying(255),
    reason_for_visit character varying(255),
    patient_first_name character varying(255),
    patient_last_name character varying(255),
    visit_type character varying(255)
);


ALTER TABLE public.staged_patient_data OWNER TO aptible;

--
-- TOC entry 289 (class 1259 OID 16695)
-- Name: staged_patient_data_holding; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.staged_patient_data_holding (
    id integer NOT NULL,
    patient_first_name character varying(255),
    patient_last_name character varying(255),
    external_patient_id character varying(255),
    date_of_service date,
    facility character varying(255),
    treated_by character varying(255),
    phone_number character varying(255),
    reason_for_visit character varying(255),
    age character varying(255),
    email character varying(255),
    date_of_birth date,
    customer_id integer,
    visit_type character varying(255)
);


ALTER TABLE public.staged_patient_data_holding OWNER TO aptible;

--
-- TOC entry 290 (class 1259 OID 16701)
-- Name: staged_patient_data_holding_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.staged_patient_data_holding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staged_patient_data_holding_id_seq OWNER TO aptible;

--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 290
-- Name: staged_patient_data_holding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.staged_patient_data_holding_id_seq OWNED BY public.staged_patient_data_holding.id;


--
-- TOC entry 291 (class 1259 OID 16703)
-- Name: staged_patient_data_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.staged_patient_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staged_patient_data_id_seq OWNER TO aptible;

--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 291
-- Name: staged_patient_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.staged_patient_data_id_seq OWNED BY public.staged_patient_data.id;


--
-- TOC entry 375 (class 1259 OID 349044)
-- Name: surveys_commentcategorization; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_commentcategorization (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    match_value double precision,
    ticket_type character varying(255) NOT NULL,
    customer_value double precision,
    survey_response_id integer NOT NULL,
    prediction_match boolean NOT NULL
);


ALTER TABLE public.surveys_commentcategorization OWNER TO aptible;

--
-- TOC entry 374 (class 1259 OID 349042)
-- Name: surveys_commentcategorization_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_commentcategorization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_commentcategorization_id_seq OWNER TO aptible;

--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 374
-- Name: surveys_commentcategorization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_commentcategorization_id_seq OWNED BY public.surveys_commentcategorization.id;


--
-- TOC entry 379 (class 1259 OID 532155)
-- Name: surveys_commentcategory; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_commentcategory (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    match_value double precision,
    category_id integer,
    category_name character varying(255) NOT NULL,
    survey_response_id integer NOT NULL
);


ALTER TABLE public.surveys_commentcategory OWNER TO aptible;

--
-- TOC entry 378 (class 1259 OID 532153)
-- Name: surveys_commentcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_commentcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_commentcategory_id_seq OWNER TO aptible;

--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 378
-- Name: surveys_commentcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_commentcategory_id_seq OWNED BY public.surveys_commentcategory.id;


--
-- TOC entry 381 (class 1259 OID 532165)
-- Name: surveys_commenttopic; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_commenttopic (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    match_value double precision,
    topic_id integer,
    topic_name character varying(255) NOT NULL,
    topic_sentiment character varying(255) NOT NULL,
    survey_response_id integer NOT NULL
);


ALTER TABLE public.surveys_commenttopic OWNER TO aptible;

--
-- TOC entry 380 (class 1259 OID 532163)
-- Name: surveys_commenttopic_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_commenttopic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_commenttopic_id_seq OWNER TO aptible;

--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 380
-- Name: surveys_commenttopic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_commenttopic_id_seq OWNED BY public.surveys_commenttopic.id;


--
-- TOC entry 292 (class 1259 OID 16717)
-- Name: surveys_npsscorechange; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_npsscorechange (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    old_score integer,
    new_score integer,
    initiating_user_id integer,
    related_nps_survey_response_id integer NOT NULL,
    change_reason character varying(1000) NOT NULL,
    is_provider_score boolean
);


ALTER TABLE public.surveys_npsscorechange OWNER TO aptible;

--
-- TOC entry 293 (class 1259 OID 16723)
-- Name: surveys_npsscorechange_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_npsscorechange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_npsscorechange_id_seq OWNER TO aptible;

--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 293
-- Name: surveys_npsscorechange_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_npsscorechange_id_seq OWNED BY public.surveys_npsscorechange.id;


--
-- TOC entry 367 (class 1259 OID 207460)
-- Name: surveys_npsscoreremoval; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_npsscoreremoval (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    customer_id integer NOT NULL,
    nps_survey_response_id integer NOT NULL,
    provider_id integer NOT NULL,
    user_id integer,
    removal_reason character varying(1000) NOT NULL
);


ALTER TABLE public.surveys_npsscoreremoval OWNER TO aptible;

--
-- TOC entry 366 (class 1259 OID 207458)
-- Name: surveys_npsscoreremoval_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_npsscoreremoval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_npsscoreremoval_id_seq OWNER TO aptible;

--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 366
-- Name: surveys_npsscoreremoval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_npsscoreremoval_id_seq OWNED BY public.surveys_npsscoreremoval.id;


--
-- TOC entry 294 (class 1259 OID 16725)
-- Name: surveys_npssurveyresponse; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_npssurveyresponse (
    surveyresponse_ptr_id integer NOT NULL,
    nps_score integer,
    comments character varying(1000),
    seen_by_comment_categorizer boolean NOT NULL,
    customer_id integer,
    provider_nps_score smallint,
    CONSTRAINT surveys_npssurveyresponse_provider_nps_score_check CHECK ((provider_nps_score >= 0))
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='600');


ALTER TABLE public.surveys_npssurveyresponse OWNER TO aptible;

--
-- TOC entry 397 (class 1259 OID 542615)
-- Name: surveys_smartsurveytemplatedefault; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_smartsurveytemplatedefault (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    outbound_message_type character varying(50) NOT NULL,
    body text NOT NULL
);


ALTER TABLE public.surveys_smartsurveytemplatedefault OWNER TO aptible;

--
-- TOC entry 396 (class 1259 OID 542613)
-- Name: surveys_smartsurveytemplatedefault_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_smartsurveytemplatedefault_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_smartsurveytemplatedefault_id_seq OWNER TO aptible;

--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 396
-- Name: surveys_smartsurveytemplatedefault_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_smartsurveytemplatedefault_id_seq OWNED BY public.surveys_smartsurveytemplatedefault.id;


--
-- TOC entry 295 (class 1259 OID 16731)
-- Name: surveys_survey; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_survey (
    id integer NOT NULL,
    full_url character varying(255),
    typeform_survey_uid character varying(50),
    survey_type character varying(50)
);


ALTER TABLE public.surveys_survey OWNER TO aptible;

--
-- TOC entry 296 (class 1259 OID 16734)
-- Name: surveys_survey_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_survey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_survey_id_seq OWNER TO aptible;

--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 296
-- Name: surveys_survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_survey_id_seq OWNED BY public.surveys_survey.id;


--
-- TOC entry 297 (class 1259 OID 16736)
-- Name: surveys_survey_request; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_survey_request (
    id integer NOT NULL,
    sent_to_id integer,
    unique_short_slug character varying(50) NOT NULL,
    full_url_with_query_params character varying(255),
    is_instance_of_id integer,
    created_on timestamp with time zone NOT NULL,
    response_has_been_processed boolean NOT NULL,
    externally_shortened_url character varying(255),
    associated_patient_visit_id integer,
    includes_provider_nps boolean,
    is_nps_request boolean
)
WITH (autovacuum_vacuum_cost_limit='600', autovacuum_analyze_scale_factor='.01', autovacuum_vacuum_scale_factor='.02');


ALTER TABLE public.surveys_survey_request OWNER TO aptible;

--
-- TOC entry 298 (class 1259 OID 16742)
-- Name: surveys_survey_request_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_survey_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_survey_request_id_seq OWNER TO aptible;

--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 298
-- Name: surveys_survey_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_survey_request_id_seq OWNED BY public.surveys_survey_request.id;


--
-- TOC entry 299 (class 1259 OID 16744)
-- Name: surveys_surveyresponse; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.surveys_surveyresponse (
    id integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    response_to_id integer NOT NULL,
    typeform_response_id integer,
    typeform_response_token character varying(100),
    sent_to_customer boolean NOT NULL,
    sent_to_customer_on timestamp with time zone,
    was_reviewed_internally boolean NOT NULL
);


ALTER TABLE public.surveys_surveyresponse OWNER TO aptible;

--
-- TOC entry 300 (class 1259 OID 16747)
-- Name: surveys_surveyresponse_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.surveys_surveyresponse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_surveyresponse_id_seq OWNER TO aptible;

--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 300
-- Name: surveys_surveyresponse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.surveys_surveyresponse_id_seq OWNED BY public.surveys_surveyresponse.id;


--
-- TOC entry 441 (class 1259 OID 809898)
-- Name: teams_dm; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_dm (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content text NOT NULL,
    exception_at timestamp with time zone,
    member_id integer NOT NULL,
    message_id integer,
    sender_id integer NOT NULL
);


ALTER TABLE public.teams_dm OWNER TO aptible;

--
-- TOC entry 440 (class 1259 OID 809896)
-- Name: teams_dm_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_dm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_dm_id_seq OWNER TO aptible;

--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 440
-- Name: teams_dm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_dm_id_seq OWNED BY public.teams_dm.id;


--
-- TOC entry 425 (class 1259 OID 809422)
-- Name: teams_envelope; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_envelope (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    exception_at timestamp with time zone,
    member_id integer NOT NULL,
    message_id integer,
    notice_id integer NOT NULL,
    disabled_at timestamp with time zone
);


ALTER TABLE public.teams_envelope OWNER TO aptible;

--
-- TOC entry 424 (class 1259 OID 809420)
-- Name: teams_envelope_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_envelope_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_envelope_id_seq OWNER TO aptible;

--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 424
-- Name: teams_envelope_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_envelope_id_seq OWNED BY public.teams_envelope.id;


--
-- TOC entry 427 (class 1259 OID 809430)
-- Name: teams_member; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_member (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    deactivated_at timestamp with time zone,
    provider_id integer,
    team_id integer NOT NULL,
    welcomed_at timestamp with time zone,
    unsubscribed_at timestamp with time zone
);


ALTER TABLE public.teams_member OWNER TO aptible;

--
-- TOC entry 426 (class 1259 OID 809428)
-- Name: teams_member_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_member_id_seq OWNER TO aptible;

--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 426
-- Name: teams_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_member_id_seq OWNED BY public.teams_member.id;


--
-- TOC entry 429 (class 1259 OID 809438)
-- Name: teams_messagein; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_messagein (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    source character varying(128) NOT NULL,
    destination character varying(128) NOT NULL,
    plivo_uuid uuid,
    content text NOT NULL,
    cue_id integer,
    member_id integer NOT NULL,
    source_phone_id integer
);


ALTER TABLE public.teams_messagein OWNER TO aptible;

--
-- TOC entry 428 (class 1259 OID 809436)
-- Name: teams_messagein_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_messagein_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_messagein_id_seq OWNER TO aptible;

--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 428
-- Name: teams_messagein_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_messagein_id_seq OWNED BY public.teams_messagein.id;


--
-- TOC entry 431 (class 1259 OID 809451)
-- Name: teams_messageout; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_messageout (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    source character varying(128) NOT NULL,
    destination character varying(128) NOT NULL,
    plivo_uuid uuid,
    content text NOT NULL,
    status character varying(16) NOT NULL,
    mocked boolean NOT NULL,
    destination_phone_id integer,
    member_id integer NOT NULL
);


ALTER TABLE public.teams_messageout OWNER TO aptible;

--
-- TOC entry 430 (class 1259 OID 809449)
-- Name: teams_messageout_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_messageout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_messageout_id_seq OWNER TO aptible;

--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 430
-- Name: teams_messageout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_messageout_id_seq OWNED BY public.teams_messageout.id;


--
-- TOC entry 433 (class 1259 OID 809464)
-- Name: teams_notice; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_notice (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content text NOT NULL,
    prepared_at timestamp with time zone,
    approved_at timestamp with time zone,
    completed_at timestamp with time zone,
    sender_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE public.teams_notice OWNER TO aptible;

--
-- TOC entry 432 (class 1259 OID 809462)
-- Name: teams_notice_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_notice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_notice_id_seq OWNER TO aptible;

--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 432
-- Name: teams_notice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_notice_id_seq OWNED BY public.teams_notice.id;


--
-- TOC entry 435 (class 1259 OID 809475)
-- Name: teams_phone; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_phone (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    number character varying(128) NOT NULL,
    member_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE public.teams_phone OWNER TO aptible;

--
-- TOC entry 434 (class 1259 OID 809473)
-- Name: teams_phone_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_phone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_phone_id_seq OWNER TO aptible;

--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 434
-- Name: teams_phone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_phone_id_seq OWNED BY public.teams_phone.id;


--
-- TOC entry 437 (class 1259 OID 809483)
-- Name: teams_receipt; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_receipt (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authority_id integer NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE public.teams_receipt OWNER TO aptible;

--
-- TOC entry 436 (class 1259 OID 809481)
-- Name: teams_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_receipt_id_seq OWNER TO aptible;

--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 436
-- Name: teams_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_receipt_id_seq OWNED BY public.teams_receipt.id;


--
-- TOC entry 439 (class 1259 OID 809493)
-- Name: teams_team; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.teams_team (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    customer_id integer NOT NULL,
    welcome text NOT NULL
);


ALTER TABLE public.teams_team OWNER TO aptible;

--
-- TOC entry 438 (class 1259 OID 809491)
-- Name: teams_team_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.teams_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_team_id_seq OWNER TO aptible;

--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 438
-- Name: teams_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.teams_team_id_seq OWNED BY public.teams_team.id;


--
-- TOC entry 301 (class 1259 OID 16749)
-- Name: ticket_adhoc_employee; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_adhoc_employee (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    owned_by_cust_id integer NOT NULL,
    created_by_id integer NOT NULL,
    created_on date NOT NULL
);


ALTER TABLE public.ticket_adhoc_employee OWNER TO aptible;

--
-- TOC entry 302 (class 1259 OID 16752)
-- Name: ticket_adhoc_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_adhoc_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_adhoc_employee_id_seq OWNER TO aptible;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 302
-- Name: ticket_adhoc_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_adhoc_employee_id_seq OWNED BY public.ticket_adhoc_employee.id;


--
-- TOC entry 303 (class 1259 OID 16754)
-- Name: ticket_category; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_category (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    name character varying(50) NOT NULL,
    slug character varying(50),
    description character varying(255),
    created_on date NOT NULL
);


ALTER TABLE public.ticket_category OWNER TO aptible;

--
-- TOC entry 304 (class 1259 OID 16757)
-- Name: ticket_category_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_category_id_seq OWNER TO aptible;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 304
-- Name: ticket_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_category_id_seq OWNED BY public.ticket_category.id;


--
-- TOC entry 329 (class 1259 OID 25207)
-- Name: ticket_cohort; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_cohort (
    id integer NOT NULL,
    created_on date NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.ticket_cohort OWNER TO aptible;

--
-- TOC entry 327 (class 1259 OID 25199)
-- Name: ticket_customer_cohort; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_customer_cohort (
    id integer NOT NULL,
    customer_ref_id integer,
    cohort_ref_id integer
);


ALTER TABLE public.ticket_customer_cohort OWNER TO aptible;

--
-- TOC entry 326 (class 1259 OID 25197)
-- Name: ticket_customer_priority_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_customer_priority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_customer_priority_id_seq OWNER TO aptible;

--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 326
-- Name: ticket_customer_priority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_customer_priority_id_seq OWNED BY public.ticket_customer_cohort.id;


--
-- TOC entry 335 (class 1259 OID 33176)
-- Name: ticket_draftnote; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_draftnote (
    id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    ticket_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.ticket_draftnote OWNER TO aptible;

--
-- TOC entry 334 (class 1259 OID 33174)
-- Name: ticket_draftnote_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_draftnote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_draftnote_id_seq OWNER TO aptible;

--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 334
-- Name: ticket_draftnote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_draftnote_id_seq OWNED BY public.ticket_draftnote.id;


--
-- TOC entry 305 (class 1259 OID 16759)
-- Name: ticket_employee_lookup; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_employee_lookup (
    id integer NOT NULL,
    owned_by_ticket_id integer NOT NULL,
    system_user_id integer,
    system_provider_id integer,
    adhoc_employee_id integer
);


ALTER TABLE public.ticket_employee_lookup OWNER TO aptible;

--
-- TOC entry 306 (class 1259 OID 16762)
-- Name: ticket_employee_lookup_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_employee_lookup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_employee_lookup_id_seq OWNER TO aptible;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 306
-- Name: ticket_employee_lookup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_employee_lookup_id_seq OWNED BY public.ticket_employee_lookup.id;


--
-- TOC entry 333 (class 1259 OID 32783)
-- Name: ticket_note; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_note (
    id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    ticket_id integer NOT NULL,
    user_id integer,
    is_legacy boolean NOT NULL
);


ALTER TABLE public.ticket_note OWNER TO aptible;

--
-- TOC entry 332 (class 1259 OID 32781)
-- Name: ticket_note_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_note_id_seq OWNER TO aptible;

--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 332
-- Name: ticket_note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_note_id_seq OWNED BY public.ticket_note.id;


--
-- TOC entry 307 (class 1259 OID 16764)
-- Name: ticket_patient_ticket; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_patient_ticket (
    ticket_ptr_id integer NOT NULL,
    related_patient_visit_id integer,
    type character varying(50) NOT NULL
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.ticket_patient_ticket OWNER TO aptible;

--
-- TOC entry 328 (class 1259 OID 25205)
-- Name: ticket_priority_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_priority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_priority_id_seq OWNER TO aptible;

--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 328
-- Name: ticket_priority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_priority_id_seq OWNED BY public.ticket_cohort.id;


--
-- TOC entry 308 (class 1259 OID 16767)
-- Name: ticket_status_history; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_status_history (
    id integer NOT NULL,
    user_id integer,
    old_status character varying(255),
    new_status character varying(255),
    created_on date NOT NULL,
    related_ticket_id integer NOT NULL
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.ticket_status_history OWNER TO aptible;

--
-- TOC entry 309 (class 1259 OID 16773)
-- Name: ticket_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_status_history_id_seq OWNER TO aptible;

--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 309
-- Name: ticket_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_status_history_id_seq OWNED BY public.ticket_status_history.id;


--
-- TOC entry 310 (class 1259 OID 16775)
-- Name: ticket_tag; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_tag (
    id integer NOT NULL,
    category_id integer,
    name character varying(50) NOT NULL,
    slug character varying(50),
    description character varying(255),
    created_on date NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE public.ticket_tag OWNER TO aptible;

--
-- TOC entry 311 (class 1259 OID 16778)
-- Name: ticket_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_tag_id_seq OWNER TO aptible;

--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 311
-- Name: ticket_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_tag_id_seq OWNED BY public.ticket_tag.id;


--
-- TOC entry 312 (class 1259 OID 16780)
-- Name: ticket_ticket; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.ticket_ticket (
    id integer NOT NULL,
    owner_id integer,
    status character varying(255),
    source character varying(255),
    content_type_id integer,
    object_id integer,
    related_site_id integer,
    related_provider_id integer,
    phone_number_id integer,
    tag_id integer,
    notes_and_follow_up text,
    created_on date NOT NULL,
    date_of_incident date,
    manually_entered_comment text,
    manually_entered_patient_or_visit_info character varying(255),
    related_customer_id integer,
    cohort_id integer,
    patient_id integer,
    CONSTRAINT ticket_ticket_object_id_check CHECK ((object_id >= 0))
)
WITH (autovacuum_analyze_scale_factor='.02', autovacuum_vacuum_scale_factor='.04', autovacuum_vacuum_cost_limit='400');


ALTER TABLE public.ticket_ticket OWNER TO aptible;

--
-- TOC entry 313 (class 1259 OID 16787)
-- Name: ticket_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.ticket_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_ticket_id_seq OWNER TO aptible;

--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 313
-- Name: ticket_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.ticket_ticket_id_seq OWNED BY public.ticket_ticket.id;


--
-- TOC entry 314 (class 1259 OID 16789)
-- Name: user_meta; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.user_meta (
    id integer NOT NULL,
    user_id integer,
    password_change_date date,
    password_black_list text
);


ALTER TABLE public.user_meta OWNER TO aptible;

--
-- TOC entry 315 (class 1259 OID 16795)
-- Name: user_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: aptible
--

CREATE SEQUENCE public.user_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_meta_id_seq OWNER TO aptible;

--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 315
-- Name: user_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aptible
--

ALTER SEQUENCE public.user_meta_id_seq OWNED BY public.user_meta.id;


--
-- TOC entry 411 (class 1259 OID 792817)
-- Name: whitelists_address; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.whitelists_address (
    uuid uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    value inet NOT NULL,
    whitelist_id uuid NOT NULL
);


ALTER TABLE public.whitelists_address OWNER TO aptible;

--
-- TOC entry 412 (class 1259 OID 792825)
-- Name: whitelists_whitelist; Type: TABLE; Schema: public; Owner: aptible
--

CREATE TABLE public.whitelists_whitelist (
    uuid uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE public.whitelists_whitelist OWNER TO aptible;

--
-- TOC entry 3656 (class 2604 OID 16455)
-- Name: account_emailaddress id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailaddress ALTER COLUMN id SET DEFAULT nextval('public.account_emailaddress_id_seq'::regclass);


--
-- TOC entry 3657 (class 2604 OID 16456)
-- Name: account_emailconfirmation id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailconfirmation ALTER COLUMN id SET DEFAULT nextval('public.account_emailconfirmation_id_seq'::regclass);


--
-- TOC entry 3658 (class 2604 OID 16457)
-- Name: admin_tools_dashboard_preferences id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_dashboard_preferences ALTER COLUMN id SET DEFAULT nextval('public.admin_tools_dashboard_preferences_id_seq'::regclass);


--
-- TOC entry 3659 (class 2604 OID 16458)
-- Name: admin_tools_menu_bookmark id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_menu_bookmark ALTER COLUMN id SET DEFAULT nextval('public.admin_tools_menu_bookmark_id_seq'::regclass);


--
-- TOC entry 3759 (class 2604 OID 579837)
-- Name: analytics_categorytopicmap id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_categorytopicmap ALTER COLUMN id SET DEFAULT nextval('public.analytics_categorytopicmap_id_seq'::regclass);


--
-- TOC entry 3760 (class 2604 OID 579848)
-- Name: analytics_categorytopictooltip id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_categorytopictooltip ALTER COLUMN id SET DEFAULT nextval('public.analytics_categorytopictooltip_id_seq'::regclass);


--
-- TOC entry 3797 (class 2604 OID 999983)
-- Name: analytics_data_nps id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_data_nps ALTER COLUMN id SET DEFAULT nextval('public.analytics_data_nps_tmp_id_seq1'::regclass);


--
-- TOC entry 3798 (class 2604 OID 1000005)
-- Name: analytics_data_tickets id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_data_tickets ALTER COLUMN id SET DEFAULT nextval('public.analytics_data_tickets_tmp_id_seq1'::regclass);


--
-- TOC entry 3660 (class 2604 OID 16461)
-- Name: analytics_endpointaccess id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_endpointaccess ALTER COLUMN id SET DEFAULT nextval('public.analytics_endpointaccess_id_seq'::regclass);


--
-- TOC entry 3661 (class 2604 OID 16462)
-- Name: analytics_providerengagement id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_providerengagement ALTER COLUMN id SET DEFAULT nextval('public.analytics_providerengagement_id_seq'::regclass);


--
-- TOC entry 3735 (class 2604 OID 16463)
-- Name: analytics_rebuild id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_rebuild ALTER COLUMN id SET DEFAULT nextval('public.analytics_rebuild_id_seq'::regclass);


--
-- TOC entry 3758 (class 2604 OID 551882)
-- Name: analytics_siteengagement id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_siteengagement ALTER COLUMN id SET DEFAULT nextval('public.analytics_siteengagement_id_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 16464)
-- Name: analytics_socialmediareviewrequest id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest ALTER COLUMN id SET DEFAULT nextval('public.analytics_socialmediareviewrequest_id_seq'::regclass);


--
-- TOC entry 3662 (class 2604 OID 16465)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 3663 (class 2604 OID 16466)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 3664 (class 2604 OID 16467)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 3665 (class 2604 OID 16468)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 3666 (class 2604 OID 16469)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 3667 (class 2604 OID 16470)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 3668 (class 2604 OID 16471)
-- Name: axes_accessattempt id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.axes_accessattempt ALTER COLUMN id SET DEFAULT nextval('public.axes_accessattempt_id_seq'::regclass);


--
-- TOC entry 3670 (class 2604 OID 16472)
-- Name: axes_accesslog id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.axes_accesslog ALTER COLUMN id SET DEFAULT nextval('public.axes_accesslog_id_seq'::regclass);


--
-- TOC entry 3671 (class 2604 OID 16473)
-- Name: callfile id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile ALTER COLUMN id SET DEFAULT nextval('public.callfile_id_seq'::regclass);


--
-- TOC entry 3672 (class 2604 OID 16474)
-- Name: callfile_customer id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_customer ALTER COLUMN id SET DEFAULT nextval('public.callfile_customer_id_seq'::regclass);


--
-- TOC entry 3673 (class 2604 OID 16475)
-- Name: callfile_sms_template id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_sms_template ALTER COLUMN id SET DEFAULT nextval('public.callfile_sms_template_id_seq'::regclass);


--
-- TOC entry 3674 (class 2604 OID 16476)
-- Name: callfile_status id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_status ALTER COLUMN id SET DEFAULT nextval('public.callfile_status_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 16477)
-- Name: conversations_contact id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_contact ALTER COLUMN id SET DEFAULT nextval('public.conversations_contact_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 16478)
-- Name: conversations_conversation id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversation ALTER COLUMN id SET DEFAULT nextval('public.conversations_conversation_id_seq'::regclass);


--
-- TOC entry 3730 (class 2604 OID 16479)
-- Name: conversations_conversationtype id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype ALTER COLUMN id SET DEFAULT nextval('public.conversations_conversationtype_id_seq'::regclass);


--
-- TOC entry 3734 (class 2604 OID 16480)
-- Name: conversations_conversationtype_templates id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype_templates ALTER COLUMN id SET DEFAULT nextval('public.conversations_conversationtype_templates_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 16481)
-- Name: conversations_inboundmessage id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_inboundmessage ALTER COLUMN id SET DEFAULT nextval('public.conversations_inboundmessage_id_seq'::regclass);


--
-- TOC entry 3737 (class 2604 OID 16482)
-- Name: conversations_optin id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_optin ALTER COLUMN id SET DEFAULT nextval('public.conversations_optin_id_seq'::regclass);


--
-- TOC entry 3732 (class 2604 OID 16483)
-- Name: conversations_outboundmessage id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_outboundmessage ALTER COLUMN id SET DEFAULT nextval('public.conversations_outboundmessage_id_seq'::regclass);


--
-- TOC entry 3733 (class 2604 OID 16484)
-- Name: conversations_template id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_template ALTER COLUMN id SET DEFAULT nextval('public.conversations_template_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 16485)
-- Name: customer_comment_agg id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_comment_agg ALTER COLUMN id SET DEFAULT nextval('public.customer_comment_agg_id_seq'::regclass);


--
-- TOC entry 3761 (class 2604 OID 596375)
-- Name: customer_deprecatedphonenumber id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_deprecatedphonenumber ALTER COLUMN id SET DEFAULT nextval('public.customer_deprecatedphonenumber_id_seq'::regclass);


--
-- TOC entry 3764 (class 2604 OID 802595)
-- Name: customer_legacyidentifier id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_legacyidentifier ALTER COLUMN id SET DEFAULT nextval('public.customer_legacyidentifier_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16486)
-- Name: customer_linkclicktracking id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_linkclicktracking ALTER COLUMN id SET DEFAULT nextval('public.customer_linkclicktracking_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 16487)
-- Name: customer_mergedentityhistory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_mergedentityhistory ALTER COLUMN id SET DEFAULT nextval('public.customer_mergedentityhistory_id_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 16488)
-- Name: customer_organization id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_organization ALTER COLUMN id SET DEFAULT nextval('public.customer_organization_id_seq'::regclass);


--
-- TOC entry 3743 (class 2604 OID 16489)
-- Name: customer_patient id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patient ALTER COLUMN id SET DEFAULT nextval('public.customer_patient_id_seq'::regclass);


--
-- TOC entry 3675 (class 2604 OID 16490)
-- Name: customer_patientoptin id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptin ALTER COLUMN id SET DEFAULT nextval('public.customer_patientoptin_id_seq'::regclass);


--
-- TOC entry 3676 (class 2604 OID 16491)
-- Name: customer_patientoptout id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptout ALTER COLUMN id SET DEFAULT nextval('public.customer_patientoptout_id_seq'::regclass);


--
-- TOC entry 3677 (class 2604 OID 16492)
-- Name: customer_patientvisithistory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory ALTER COLUMN id SET DEFAULT nextval('public.customer_patientvisithistory_id_seq'::regclass);


--
-- TOC entry 3678 (class 2604 OID 16493)
-- Name: customer_phonenumbermismatch id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_phonenumbermismatch ALTER COLUMN id SET DEFAULT nextval('public.customer_phonenumbermismatch_id_seq'::regclass);


--
-- TOC entry 3679 (class 2604 OID 16494)
-- Name: customer_provider id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_provider ALTER COLUMN id SET DEFAULT nextval('public.customer_provider_id_seq'::regclass);


--
-- TOC entry 3680 (class 2604 OID 16495)
-- Name: customer_scheduledappointment id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_scheduledappointment ALTER COLUMN id SET DEFAULT nextval('public.customer_scheduledappointment_id_seq'::regclass);


--
-- TOC entry 3681 (class 2604 OID 16496)
-- Name: customer_site id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_site ALTER COLUMN id SET DEFAULT nextval('public.customer_site_id_seq'::regclass);


--
-- TOC entry 3682 (class 2604 OID 16497)
-- Name: customer_usertocustomer id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_usertocustomer ALTER COLUMN id SET DEFAULT nextval('public.customer_usertocustomer_id_seq'::regclass);


--
-- TOC entry 3683 (class 2604 OID 16498)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 3685 (class 2604 OID 16499)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 3686 (class 2604 OID 16500)
-- Name: django_cron_cronjoblog id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_cron_cronjoblog ALTER COLUMN id SET DEFAULT nextval('public.django_cron_cronjoblog_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 16501)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 3687 (class 2604 OID 16502)
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- TOC entry 3718 (class 2604 OID 16503)
-- Name: domain_integration_file_tracking id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_integration_file_tracking ALTER COLUMN id SET DEFAULT nextval('public.domain_integration_file_tracking_id_seq'::regclass);


--
-- TOC entry 3736 (class 2604 OID 16504)
-- Name: domain_killswitch id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_killswitch ALTER COLUMN id SET DEFAULT nextval('public.domain_killswitch_id_seq'::regclass);


--
-- TOC entry 3688 (class 2604 OID 16505)
-- Name: domain_onetimelink id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_onetimelink ALTER COLUMN id SET DEFAULT nextval('public.domain_onetimelink_id_seq'::regclass);


--
-- TOC entry 3689 (class 2604 OID 16506)
-- Name: domain_stagedfilelog id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_stagedfilelog ALTER COLUMN id SET DEFAULT nextval('public.domain_stagedfilelog_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 16507)
-- Name: domain_thirdpartyapiuser id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_thirdpartyapiuser ALTER COLUMN id SET DEFAULT nextval('public.domain_thirdpartyapiuser_id_seq'::regclass);


--
-- TOC entry 3717 (class 2604 OID 16508)
-- Name: domain_usersessionhistory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_usersessionhistory ALTER COLUMN id SET DEFAULT nextval('public.domain_usersessionhistory_id_seq'::regclass);


--
-- TOC entry 3793 (class 2604 OID 882930)
-- Name: immediate_heldvisit id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_heldvisit ALTER COLUMN id SET DEFAULT nextval('public.immediate_heldvisit_id_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 882920)
-- Name: immediate_immediateschedule id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_immediateschedule ALTER COLUMN id SET DEFAULT nextval('public.immediate_immediateschedule_id_seq'::regclass);


--
-- TOC entry 3795 (class 2604 OID 965256)
-- Name: immediate_mappingkey id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_mappingkey ALTER COLUMN id SET DEFAULT nextval('public.immediate_mappingkey_id_seq'::regclass);


--
-- TOC entry 3796 (class 2604 OID 965301)
-- Name: immediate_whitelistedsite id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_whitelistedsite ALTER COLUMN id SET DEFAULT nextval('public.immediate_whitelistedsite_id_seq'::regclass);


--
-- TOC entry 3750 (class 2604 OID 538692)
-- Name: mercury_conversation id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_conversation ALTER COLUMN id SET DEFAULT nextval('public.mercury_conversation_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 538703)
-- Name: mercury_inboundmessage id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_inboundmessage ALTER COLUMN id SET DEFAULT nextval('public.mercury_inboundmessage_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 538714)
-- Name: mercury_interaction id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interaction ALTER COLUMN id SET DEFAULT nextval('public.mercury_interaction_id_seq'::regclass);


--
-- TOC entry 3753 (class 2604 OID 538722)
-- Name: mercury_interactiongroup id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interactiongroup ALTER COLUMN id SET DEFAULT nextval('public.mercury_interactiongroup_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 538733)
-- Name: mercury_outboundmessage id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_outboundmessage ALTER COLUMN id SET DEFAULT nextval('public.mercury_outboundmessage_id_seq'::regclass);


--
-- TOC entry 3755 (class 2604 OID 538744)
-- Name: mercury_phonenumber id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_phonenumber ALTER COLUMN id SET DEFAULT nextval('public.mercury_phonenumber_id_seq'::regclass);


--
-- TOC entry 3756 (class 2604 OID 538752)
-- Name: mercury_template id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_template ALTER COLUMN id SET DEFAULT nextval('public.mercury_template_id_seq'::regclass);


--
-- TOC entry 3765 (class 2604 OID 804560)
-- Name: notices_autoresponse id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_autoresponse ALTER COLUMN id SET DEFAULT nextval('public.notices_autoresponse_id_seq'::regclass);


--
-- TOC entry 3766 (class 2604 OID 804568)
-- Name: notices_batch id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_batch ALTER COLUMN id SET DEFAULT nextval('public.notices_batch_id_seq'::regclass);


--
-- TOC entry 3767 (class 2604 OID 804576)
-- Name: notices_envelope id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope ALTER COLUMN id SET DEFAULT nextval('public.notices_envelope_id_seq'::regclass);


--
-- TOC entry 3768 (class 2604 OID 804586)
-- Name: notices_notice id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_notice ALTER COLUMN id SET DEFAULT nextval('public.notices_notice_id_seq'::regclass);


--
-- TOC entry 3747 (class 2604 OID 16509)
-- Name: nps_sitesocialmediainterstitialpage id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_sitesocialmediainterstitialpage ALTER COLUMN id SET DEFAULT nextval('public.nps_sitesocialmediainterstitialpage_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 16510)
-- Name: nps_socialmediainterstitial id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_socialmediainterstitial ALTER COLUMN id SET DEFAULT nextval('public.nps_socialmediainterstitial_id_seq'::regclass);


--
-- TOC entry 3745 (class 2604 OID 16511)
-- Name: nps_visit id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_visit ALTER COLUMN id SET DEFAULT nextval('public.nps_visit_id_seq'::regclass);


--
-- TOC entry 3690 (class 2604 OID 16512)
-- Name: phone_number id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.phone_number ALTER COLUMN id SET DEFAULT nextval('public.phone_number_id_seq'::regclass);


--
-- TOC entry 3691 (class 2604 OID 16513)
-- Name: reminders_reminder id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reminders_reminder ALTER COLUMN id SET DEFAULT nextval('public.reminders_reminder_id_seq'::regclass);


--
-- TOC entry 3790 (class 2604 OID 875410)
-- Name: reputation_actionthreshold id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_actionthreshold ALTER COLUMN id SET DEFAULT nextval('public.reputation_actionthreshold_id_seq'::regclass);


--
-- TOC entry 3794 (class 2604 OID 923171)
-- Name: reputation_competitor id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_competitor ALTER COLUMN id SET DEFAULT nextval('public.reputation_competitor_id_seq'::regclass);


--
-- TOC entry 3782 (class 2604 OID 851692)
-- Name: reputation_gmbaccount id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbaccount ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmbaccount_id_seq'::regclass);


--
-- TOC entry 3783 (class 2604 OID 851700)
-- Name: reputation_gmblocation id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmblocation_id_seq'::regclass);


--
-- TOC entry 3786 (class 2604 OID 851732)
-- Name: reputation_gmbnotification id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotification ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmbnotification_id_seq'::regclass);


--
-- TOC entry 3787 (class 2604 OID 851743)
-- Name: reputation_gmbnotifyee id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotifyee ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmbnotifyee_id_seq'::regclass);


--
-- TOC entry 3785 (class 2604 OID 851721)
-- Name: reputation_gmbreplyaction id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreplyaction ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmbreplyaction_id_seq'::regclass);


--
-- TOC entry 3784 (class 2604 OID 851710)
-- Name: reputation_gmbreview id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreview ALTER COLUMN id SET DEFAULT nextval('public.reputation_gmbreview_id_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 875381)
-- Name: reputation_reviewticket id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket ALTER COLUMN id SET DEFAULT nextval('public.reputation_reviewticket_id_seq'::regclass);


--
-- TOC entry 3738 (class 2604 OID 16514)
-- Name: reviews_feed id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_feed ALTER COLUMN id SET DEFAULT nextval('public.reviews_feed_id_seq'::regclass);


--
-- TOC entry 3739 (class 2604 OID 16515)
-- Name: reviews_review id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_review ALTER COLUMN id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- TOC entry 3762 (class 2604 OID 676809)
-- Name: securedrop_drop id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.securedrop_drop ALTER COLUMN id SET DEFAULT nextval('public.securedrop_drop_id_seq'::regclass);


--
-- TOC entry 3763 (class 2604 OID 676820)
-- Name: securedrop_pickup id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.securedrop_pickup ALTER COLUMN id SET DEFAULT nextval('public.securedrop_pickup_id_seq'::regclass);


--
-- TOC entry 3692 (class 2604 OID 16516)
-- Name: sms_callfilehistory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_callfilehistory ALTER COLUMN id SET DEFAULT nextval('public.sms_callfilehistory_id_seq'::regclass);


--
-- TOC entry 3693 (class 2604 OID 16517)
-- Name: sms_message id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message ALTER COLUMN id SET DEFAULT nextval('public.sms_message_id_seq'::regclass);


--
-- TOC entry 3694 (class 2604 OID 16518)
-- Name: sms_message_incoming id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message_incoming ALTER COLUMN id SET DEFAULT nextval('public.sms_message_incoming_id_seq'::regclass);


--
-- TOC entry 3695 (class 2604 OID 16519)
-- Name: sms_message_incoming_unrecognized id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message_incoming_unrecognized ALTER COLUMN id SET DEFAULT nextval('public.sms_message_incoming_unrecognized_id_seq'::regclass);


--
-- TOC entry 3696 (class 2604 OID 16520)
-- Name: socialaccount_socialaccount id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialaccount ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialaccount_id_seq'::regclass);


--
-- TOC entry 3697 (class 2604 OID 16521)
-- Name: socialaccount_socialapp id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialapp_id_seq'::regclass);


--
-- TOC entry 3698 (class 2604 OID 16522)
-- Name: socialaccount_socialapp_sites id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialapp_sites_id_seq'::regclass);


--
-- TOC entry 3699 (class 2604 OID 16523)
-- Name: socialaccount_socialtoken id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialtoken ALTER COLUMN id SET DEFAULT nextval('public.socialaccount_socialtoken_id_seq'::regclass);


--
-- TOC entry 3781 (class 2604 OID 846494)
-- Name: sources_customercode id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_customercode ALTER COLUMN id SET DEFAULT nextval('public.sources_customercode_id_seq'::regclass);


--
-- TOC entry 3780 (class 2604 OID 846483)
-- Name: sources_internalasset id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalasset ALTER COLUMN id SET DEFAULT nextval('public.sources_internalasset_id_seq'::regclass);


--
-- TOC entry 3778 (class 2604 OID 846464)
-- Name: sources_internalsource id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsource ALTER COLUMN id SET DEFAULT nextval('public.sources_internalsource_id_seq'::regclass);


--
-- TOC entry 3779 (class 2604 OID 846472)
-- Name: sources_internalsourcecheck id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsourcecheck ALTER COLUMN id SET DEFAULT nextval('public.sources_internalsourcecheck_id_seq'::regclass);


--
-- TOC entry 3700 (class 2604 OID 16524)
-- Name: south_migrationhistory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.south_migrationhistory ALTER COLUMN id SET DEFAULT nextval('public.south_migrationhistory_id_seq'::regclass);


--
-- TOC entry 3701 (class 2604 OID 16525)
-- Name: stage_raw_files_for_import id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.stage_raw_files_for_import ALTER COLUMN id SET DEFAULT nextval('public.stage_raw_files_for_import_id_seq'::regclass);


--
-- TOC entry 3702 (class 2604 OID 16526)
-- Name: staged_patient_data id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.staged_patient_data ALTER COLUMN id SET DEFAULT nextval('public.staged_patient_data_id_seq'::regclass);


--
-- TOC entry 3703 (class 2604 OID 16527)
-- Name: staged_patient_data_holding id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.staged_patient_data_holding ALTER COLUMN id SET DEFAULT nextval('public.staged_patient_data_holding_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 16528)
-- Name: surveys_commentcategorization id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategorization ALTER COLUMN id SET DEFAULT nextval('public.surveys_commentcategorization_id_seq'::regclass);


--
-- TOC entry 3748 (class 2604 OID 532158)
-- Name: surveys_commentcategory id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategory ALTER COLUMN id SET DEFAULT nextval('public.surveys_commentcategory_id_seq'::regclass);


--
-- TOC entry 3749 (class 2604 OID 532168)
-- Name: surveys_commenttopic id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commenttopic ALTER COLUMN id SET DEFAULT nextval('public.surveys_commenttopic_id_seq'::regclass);


--
-- TOC entry 3704 (class 2604 OID 16529)
-- Name: surveys_npsscorechange id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscorechange ALTER COLUMN id SET DEFAULT nextval('public.surveys_npsscorechange_id_seq'::regclass);


--
-- TOC entry 3742 (class 2604 OID 16530)
-- Name: surveys_npsscoreremoval id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval ALTER COLUMN id SET DEFAULT nextval('public.surveys_npsscoreremoval_id_seq'::regclass);


--
-- TOC entry 3757 (class 2604 OID 542618)
-- Name: surveys_smartsurveytemplatedefault id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_smartsurveytemplatedefault ALTER COLUMN id SET DEFAULT nextval('public.surveys_smartsurveytemplatedefault_id_seq'::regclass);


--
-- TOC entry 3706 (class 2604 OID 16531)
-- Name: surveys_survey id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey ALTER COLUMN id SET DEFAULT nextval('public.surveys_survey_id_seq'::regclass);


--
-- TOC entry 3707 (class 2604 OID 16532)
-- Name: surveys_survey_request id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request ALTER COLUMN id SET DEFAULT nextval('public.surveys_survey_request_id_seq'::regclass);


--
-- TOC entry 3708 (class 2604 OID 16533)
-- Name: surveys_surveyresponse id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_surveyresponse ALTER COLUMN id SET DEFAULT nextval('public.surveys_surveyresponse_id_seq'::regclass);


--
-- TOC entry 3777 (class 2604 OID 809901)
-- Name: teams_dm id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm ALTER COLUMN id SET DEFAULT nextval('public.teams_dm_id_seq'::regclass);


--
-- TOC entry 3769 (class 2604 OID 809425)
-- Name: teams_envelope id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope ALTER COLUMN id SET DEFAULT nextval('public.teams_envelope_id_seq'::regclass);


--
-- TOC entry 3770 (class 2604 OID 809433)
-- Name: teams_member id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member ALTER COLUMN id SET DEFAULT nextval('public.teams_member_id_seq'::regclass);


--
-- TOC entry 3771 (class 2604 OID 809441)
-- Name: teams_messagein id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein ALTER COLUMN id SET DEFAULT nextval('public.teams_messagein_id_seq'::regclass);


--
-- TOC entry 3772 (class 2604 OID 809454)
-- Name: teams_messageout id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messageout ALTER COLUMN id SET DEFAULT nextval('public.teams_messageout_id_seq'::regclass);


--
-- TOC entry 3773 (class 2604 OID 809467)
-- Name: teams_notice id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_notice ALTER COLUMN id SET DEFAULT nextval('public.teams_notice_id_seq'::regclass);


--
-- TOC entry 3774 (class 2604 OID 809478)
-- Name: teams_phone id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone ALTER COLUMN id SET DEFAULT nextval('public.teams_phone_id_seq'::regclass);


--
-- TOC entry 3775 (class 2604 OID 809486)
-- Name: teams_receipt id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_receipt ALTER COLUMN id SET DEFAULT nextval('public.teams_receipt_id_seq'::regclass);


--
-- TOC entry 3776 (class 2604 OID 809496)
-- Name: teams_team id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_team ALTER COLUMN id SET DEFAULT nextval('public.teams_team_id_seq'::regclass);


--
-- TOC entry 3709 (class 2604 OID 16534)
-- Name: ticket_adhoc_employee id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_adhoc_employee ALTER COLUMN id SET DEFAULT nextval('public.ticket_adhoc_employee_id_seq'::regclass);


--
-- TOC entry 3710 (class 2604 OID 16535)
-- Name: ticket_category id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_category ALTER COLUMN id SET DEFAULT nextval('public.ticket_category_id_seq'::regclass);


--
-- TOC entry 3723 (class 2604 OID 16536)
-- Name: ticket_cohort id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_cohort ALTER COLUMN id SET DEFAULT nextval('public.ticket_priority_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 16537)
-- Name: ticket_customer_cohort id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_customer_cohort ALTER COLUMN id SET DEFAULT nextval('public.ticket_customer_priority_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 16538)
-- Name: ticket_draftnote id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_draftnote ALTER COLUMN id SET DEFAULT nextval('public.ticket_draftnote_id_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 16539)
-- Name: ticket_employee_lookup id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup ALTER COLUMN id SET DEFAULT nextval('public.ticket_employee_lookup_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 16540)
-- Name: ticket_note id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_note ALTER COLUMN id SET DEFAULT nextval('public.ticket_note_id_seq'::regclass);


--
-- TOC entry 3712 (class 2604 OID 16541)
-- Name: ticket_status_history id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_status_history ALTER COLUMN id SET DEFAULT nextval('public.ticket_status_history_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 16542)
-- Name: ticket_tag id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_tag ALTER COLUMN id SET DEFAULT nextval('public.ticket_tag_id_seq'::regclass);


--
-- TOC entry 3714 (class 2604 OID 16543)
-- Name: ticket_ticket id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_ticket_id_seq'::regclass);


--
-- TOC entry 3716 (class 2604 OID 16544)
-- Name: user_meta id; Type: DEFAULT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.user_meta ALTER COLUMN id SET DEFAULT nextval('public.user_meta_id_seq'::regclass);


--
-- TOC entry 3800 (class 2606 OID 16545)
-- Name: account_emailaddress account_emailaddress_email_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_email_key UNIQUE (email);


--
-- TOC entry 3803 (class 2606 OID 16546)
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- TOC entry 3807 (class 2606 OID 16547)
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- TOC entry 3810 (class 2606 OID 16548)
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- TOC entry 3812 (class 2606 OID 16549)
-- Name: admin_tools_dashboard_preferences admin_tools_dashboard_prefer_dashboard_id_15012b2c90a6d8a0_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_dashboard_preferences
    ADD CONSTRAINT admin_tools_dashboard_prefer_dashboard_id_15012b2c90a6d8a0_uniq UNIQUE (dashboard_id, user_id);


--
-- TOC entry 3814 (class 2606 OID 16550)
-- Name: admin_tools_dashboard_preferences admin_tools_dashboard_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_dashboard_preferences
    ADD CONSTRAINT admin_tools_dashboard_preferences_pkey PRIMARY KEY (id);


--
-- TOC entry 3817 (class 2606 OID 16551)
-- Name: admin_tools_menu_bookmark admin_tools_menu_bookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_menu_bookmark
    ADD CONSTRAINT admin_tools_menu_bookmark_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 579842)
-- Name: analytics_categorytopicmap analytics_categorytopicmap_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_categorytopicmap
    ADD CONSTRAINT analytics_categorytopicmap_pkey PRIMARY KEY (id);


--
-- TOC entry 4274 (class 2606 OID 579853)
-- Name: analytics_categorytopictooltip analytics_categorytopictooltip_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_categorytopictooltip
    ADD CONSTRAINT analytics_categorytopictooltip_pkey PRIMARY KEY (id);


--
-- TOC entry 4532 (class 2606 OID 999985)
-- Name: analytics_data_nps analytics_data_nps_tmp_pkey1; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_data_nps
    ADD CONSTRAINT analytics_data_nps_tmp_pkey1 PRIMARY KEY (id);


--
-- TOC entry 4538 (class 2606 OID 1000007)
-- Name: analytics_data_tickets analytics_data_tickets_tmp_pkey1; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_data_tickets
    ADD CONSTRAINT analytics_data_tickets_tmp_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3820 (class 2606 OID 16554)
-- Name: analytics_endpointaccess analytics_endpointaccess_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_endpointaccess
    ADD CONSTRAINT analytics_endpointaccess_pkey PRIMARY KEY (id);


--
-- TOC entry 3823 (class 2606 OID 16555)
-- Name: analytics_providerengagement analytics_providerengagement_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_providerengagement
    ADD CONSTRAINT analytics_providerengagement_pkey PRIMARY KEY (id);


--
-- TOC entry 4165 (class 2606 OID 16556)
-- Name: analytics_rebuild analytics_rebuild_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_rebuild
    ADD CONSTRAINT analytics_rebuild_pkey PRIMARY KEY (id);


--
-- TOC entry 4270 (class 2606 OID 551884)
-- Name: analytics_siteengagement analytics_siteengagement_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_siteengagement
    ADD CONSTRAINT analytics_siteengagement_pkey PRIMARY KEY (id);


--
-- TOC entry 4198 (class 2606 OID 16557)
-- Name: analytics_socialmediareviewrequest analytics_socialmediareviewrequest_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT analytics_socialmediareviewrequest_pkey PRIMARY KEY (id);


--
-- TOC entry 3826 (class 2606 OID 831693)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3832 (class 2606 OID 16559)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- TOC entry 3835 (class 2606 OID 16560)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3829 (class 2606 OID 16561)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3838 (class 2606 OID 16562)
-- Name: auth_permission auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- TOC entry 3840 (class 2606 OID 16563)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3848 (class 2606 OID 16564)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3851 (class 2606 OID 16565)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- TOC entry 3842 (class 2606 OID 16566)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3854 (class 2606 OID 16567)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3857 (class 2606 OID 16568)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- TOC entry 3844 (class 2606 OID 723294)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 3860 (class 2606 OID 16570)
-- Name: axes_accessattempt axes_accessattempt_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.axes_accessattempt
    ADD CONSTRAINT axes_accessattempt_pkey PRIMARY KEY (id);


--
-- TOC entry 3867 (class 2606 OID 16571)
-- Name: axes_accesslog axes_accesslog_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.axes_accesslog
    ADD CONSTRAINT axes_accesslog_pkey PRIMARY KEY (id);


--
-- TOC entry 3878 (class 2606 OID 16572)
-- Name: callfile_customer callfile_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_customer
    ADD CONSTRAINT callfile_customer_pkey PRIMARY KEY (id);


--
-- TOC entry 3874 (class 2606 OID 16573)
-- Name: callfile callfile_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile
    ADD CONSTRAINT callfile_pkey PRIMARY KEY (id);


--
-- TOC entry 3880 (class 2606 OID 16574)
-- Name: callfile_sms_template callfile_sms_template_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_sms_template
    ADD CONSTRAINT callfile_sms_template_pkey PRIMARY KEY (id);


--
-- TOC entry 3882 (class 2606 OID 16575)
-- Name: callfile_status callfile_status_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_status
    ADD CONSTRAINT callfile_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 16576)
-- Name: conversations_contact conversations_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_contact
    ADD CONSTRAINT conversations_contact_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 16577)
-- Name: conversations_conversation conversations_conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversation
    ADD CONSTRAINT conversations_conversation_pkey PRIMARY KEY (id);


--
-- TOC entry 4159 (class 2606 OID 16578)
-- Name: conversations_conversationtype_templates conversations_conversationtyp_conversationtype_id_template__key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype_templates
    ADD CONSTRAINT conversations_conversationtyp_conversationtype_id_template__key UNIQUE (conversationtype_id, template_id);


--
-- TOC entry 4147 (class 2606 OID 16579)
-- Name: conversations_conversationtype conversations_conversationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype
    ADD CONSTRAINT conversations_conversationtype_pkey PRIMARY KEY (id);


--
-- TOC entry 4163 (class 2606 OID 16580)
-- Name: conversations_conversationtype_templates conversations_conversationtype_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype_templates
    ADD CONSTRAINT conversations_conversationtype_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 16581)
-- Name: conversations_inboundmessage conversations_inboundmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_inboundmessage
    ADD CONSTRAINT conversations_inboundmessage_pkey PRIMARY KEY (id);


--
-- TOC entry 4170 (class 2606 OID 16582)
-- Name: conversations_optin conversations_optin_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_optin
    ADD CONSTRAINT conversations_optin_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4172 (class 2606 OID 16583)
-- Name: conversations_optin conversations_optin_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_optin
    ADD CONSTRAINT conversations_optin_pkey PRIMARY KEY (id);


--
-- TOC entry 4155 (class 2606 OID 16584)
-- Name: conversations_outboundmessage conversations_outboundmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_outboundmessage
    ADD CONSTRAINT conversations_outboundmessage_pkey PRIMARY KEY (id);


--
-- TOC entry 4157 (class 2606 OID 16585)
-- Name: conversations_template conversations_template_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_template
    ADD CONSTRAINT conversations_template_pkey PRIMARY KEY (id);


--
-- TOC entry 4104 (class 2606 OID 16586)
-- Name: customer_comment_agg customer_comment_agg_fingerprint_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_comment_agg
    ADD CONSTRAINT customer_comment_agg_fingerprint_key UNIQUE (fingerprint);


--
-- TOC entry 4106 (class 2606 OID 16587)
-- Name: customer_comment_agg customer_comment_agg_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_comment_agg
    ADD CONSTRAINT customer_comment_agg_pkey PRIMARY KEY (id);


--
-- TOC entry 4276 (class 2606 OID 596377)
-- Name: customer_deprecatedphonenumber customer_deprecatedphonenumber_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_deprecatedphonenumber
    ADD CONSTRAINT customer_deprecatedphonenumber_pkey PRIMARY KEY (id);


--
-- TOC entry 4298 (class 2606 OID 802599)
-- Name: customer_legacyidentifier customer_legacyidentifier_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_legacyidentifier
    ADD CONSTRAINT customer_legacyidentifier_patient_id_key UNIQUE (patient_id);


--
-- TOC entry 4300 (class 2606 OID 802597)
-- Name: customer_legacyidentifier customer_legacyidentifier_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_legacyidentifier
    ADD CONSTRAINT customer_legacyidentifier_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 16588)
-- Name: customer_linkclicktracking customer_linkclicktracking_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_linkclicktracking
    ADD CONSTRAINT customer_linkclicktracking_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 16589)
-- Name: customer_mergedentityhistory customer_mergedentityhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_mergedentityhistory
    ADD CONSTRAINT customer_mergedentityhistory_pkey PRIMARY KEY (id);


--
-- TOC entry 4185 (class 2606 OID 16590)
-- Name: customer_organization customer_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_organization
    ADD CONSTRAINT customer_organization_pkey PRIMARY KEY (id);


--
-- TOC entry 4188 (class 2606 OID 802032)
-- Name: customer_organization customer_organization_prefix_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_organization
    ADD CONSTRAINT customer_organization_prefix_key UNIQUE (prefix);


--
-- TOC entry 4214 (class 2606 OID 16591)
-- Name: customer_patient customer_patient_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patient
    ADD CONSTRAINT customer_patient_pkey PRIMARY KEY (id);


--
-- TOC entry 3886 (class 2606 OID 16592)
-- Name: customer_patientoptin customer_patientoptin_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptin
    ADD CONSTRAINT customer_patientoptin_pkey PRIMARY KEY (id);


--
-- TOC entry 3891 (class 2606 OID 16593)
-- Name: customer_patientoptout customer_patientoptout_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptout
    ADD CONSTRAINT customer_patientoptout_pkey PRIMARY KEY (id);


--
-- TOC entry 3897 (class 2606 OID 16594)
-- Name: customer_patientvisithistory customer_patientvisithistory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory
    ADD CONSTRAINT customer_patientvisithistory_pkey PRIMARY KEY (id);


--
-- TOC entry 3902 (class 2606 OID 16595)
-- Name: customer_phonenumbermismatch customer_phonenumbermismatch_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_phonenumbermismatch
    ADD CONSTRAINT customer_phonenumbermismatch_pkey PRIMARY KEY (id);


--
-- TOC entry 3905 (class 2606 OID 809419)
-- Name: customer_provider customer_provider_employed_by_id_phone_number_3030fc0a_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_provider
    ADD CONSTRAINT customer_provider_employed_by_id_phone_number_3030fc0a_uniq UNIQUE (employed_by_id, phone_number);


--
-- TOC entry 3909 (class 2606 OID 16596)
-- Name: customer_provider customer_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_provider
    ADD CONSTRAINT customer_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 3912 (class 2606 OID 16597)
-- Name: customer_scheduledappointment customer_scheduledappointment_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_scheduledappointment
    ADD CONSTRAINT customer_scheduledappointment_pkey PRIMARY KEY (id);


--
-- TOC entry 3916 (class 2606 OID 16598)
-- Name: customer_site customer_site_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_site
    ADD CONSTRAINT customer_site_pkey PRIMARY KEY (id);


--
-- TOC entry 3919 (class 2606 OID 16599)
-- Name: customer_usertocustomer customer_usertocustomer_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_usertocustomer
    ADD CONSTRAINT customer_usertocustomer_pkey PRIMARY KEY (id);


--
-- TOC entry 3922 (class 2606 OID 16600)
-- Name: customer_usertocustomer customer_usertocustomer_user_ref_id_6de0951cb2506ca1_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_usertocustomer
    ADD CONSTRAINT customer_usertocustomer_user_ref_id_6de0951cb2506ca1_uniq UNIQUE (user_ref_id, customer_ref_id);


--
-- TOC entry 3925 (class 2606 OID 16601)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3928 (class 2606 OID 16602)
-- Name: django_content_type django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- TOC entry 3930 (class 2606 OID 16603)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3935 (class 2606 OID 16604)
-- Name: django_cron_cronjoblog django_cron_cronjoblog_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_cron_cronjoblog
    ADD CONSTRAINT django_cron_cronjoblog_pkey PRIMARY KEY (id);


--
-- TOC entry 4100 (class 2606 OID 16605)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3943 (class 2606 OID 16606)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 3947 (class 2606 OID 723305)
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- TOC entry 3949 (class 2606 OID 16607)
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- TOC entry 4335 (class 2606 OID 806093)
-- Name: domain_adminasset domain_adminasset_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_adminasset
    ADD CONSTRAINT domain_adminasset_pkey PRIMARY KEY (uuid);


--
-- TOC entry 4098 (class 2606 OID 16608)
-- Name: domain_integration_file_tracking domain_integration_file_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_integration_file_tracking
    ADD CONSTRAINT domain_integration_file_tracking_pkey PRIMARY KEY (id);


--
-- TOC entry 4167 (class 2606 OID 16609)
-- Name: domain_killswitch domain_killswitch_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_killswitch
    ADD CONSTRAINT domain_killswitch_pkey PRIMARY KEY (id);


--
-- TOC entry 3951 (class 2606 OID 16610)
-- Name: domain_onetimelink domain_onetimelink_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_onetimelink
    ADD CONSTRAINT domain_onetimelink_pkey PRIMARY KEY (id);


--
-- TOC entry 3953 (class 2606 OID 16611)
-- Name: domain_onetimelink domain_onetimelink_unique_slug_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_onetimelink
    ADD CONSTRAINT domain_onetimelink_unique_slug_key UNIQUE (unique_slug);


--
-- TOC entry 3956 (class 2606 OID 16612)
-- Name: domain_stagedfilelog domain_stagedfilelog_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_stagedfilelog
    ADD CONSTRAINT domain_stagedfilelog_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 16614)
-- Name: domain_thirdpartyapiuser domain_thirdpartyapiuser_name_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_thirdpartyapiuser
    ADD CONSTRAINT domain_thirdpartyapiuser_name_key UNIQUE (name);


--
-- TOC entry 4135 (class 2606 OID 16615)
-- Name: domain_thirdpartyapiuser domain_thirdpartyapiuser_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_thirdpartyapiuser
    ADD CONSTRAINT domain_thirdpartyapiuser_pkey PRIMARY KEY (id);


--
-- TOC entry 4094 (class 2606 OID 16616)
-- Name: domain_usersessionhistory domain_usersessionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_usersessionhistory
    ADD CONSTRAINT domain_usersessionhistory_pkey PRIMARY KEY (id);


--
-- TOC entry 4503 (class 2606 OID 882935)
-- Name: immediate_heldvisit immediate_heldvisit_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_heldvisit
    ADD CONSTRAINT immediate_heldvisit_pkey PRIMARY KEY (id);


--
-- TOC entry 4492 (class 2606 OID 882924)
-- Name: immediate_immediateschedule immediate_immediateschedule_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_immediateschedule
    ADD CONSTRAINT immediate_immediateschedule_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4494 (class 2606 OID 882922)
-- Name: immediate_immediateschedule immediate_immediateschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_immediateschedule
    ADD CONSTRAINT immediate_immediateschedule_pkey PRIMARY KEY (id);


--
-- TOC entry 4517 (class 2606 OID 965258)
-- Name: immediate_mappingkey immediate_mappingkey_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_mappingkey
    ADD CONSTRAINT immediate_mappingkey_pkey PRIMARY KEY (id);


--
-- TOC entry 4520 (class 2606 OID 965272)
-- Name: immediate_mappingkey immediate_mappingkey_schedule_id_key_822b64a3_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_mappingkey
    ADD CONSTRAINT immediate_mappingkey_schedule_id_key_822b64a3_uniq UNIQUE (schedule_id, key);


--
-- TOC entry 4523 (class 2606 OID 965303)
-- Name: immediate_whitelistedsite immediate_whitelistedsite_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_whitelistedsite
    ADD CONSTRAINT immediate_whitelistedsite_pkey PRIMARY KEY (id);


--
-- TOC entry 4526 (class 2606 OID 965310)
-- Name: immediate_whitelistedsite immediate_whitelistedsite_schedule_id_name_3ccf623b_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_whitelistedsite
    ADD CONSTRAINT immediate_whitelistedsite_schedule_id_name_3ccf623b_uniq UNIQUE (schedule_id, name);


--
-- TOC entry 4240 (class 2606 OID 538697)
-- Name: mercury_conversation mercury_conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_conversation
    ADD CONSTRAINT mercury_conversation_pkey PRIMARY KEY (id);


--
-- TOC entry 4247 (class 2606 OID 538708)
-- Name: mercury_inboundmessage mercury_inboundmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_inboundmessage
    ADD CONSTRAINT mercury_inboundmessage_pkey PRIMARY KEY (id);


--
-- TOC entry 4250 (class 2606 OID 538716)
-- Name: mercury_interaction mercury_interaction_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interaction
    ADD CONSTRAINT mercury_interaction_pkey PRIMARY KEY (id);


--
-- TOC entry 4253 (class 2606 OID 928509)
-- Name: mercury_interactiongroup mercury_interactiongroup_group_7aaf4a25_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interactiongroup
    ADD CONSTRAINT mercury_interactiongroup_group_7aaf4a25_uniq UNIQUE ("group");


--
-- TOC entry 4255 (class 2606 OID 538727)
-- Name: mercury_interactiongroup mercury_interactiongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interactiongroup
    ADD CONSTRAINT mercury_interactiongroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4259 (class 2606 OID 538738)
-- Name: mercury_outboundmessage mercury_outboundmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_outboundmessage
    ADD CONSTRAINT mercury_outboundmessage_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 538746)
-- Name: mercury_phonenumber mercury_phonenumber_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_phonenumber
    ADD CONSTRAINT mercury_phonenumber_pkey PRIMARY KEY (id);


--
-- TOC entry 4265 (class 2606 OID 538757)
-- Name: mercury_template mercury_template_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_template
    ADD CONSTRAINT mercury_template_pkey PRIMARY KEY (id);


--
-- TOC entry 4306 (class 2606 OID 804593)
-- Name: notices_autoresponse notices_autoresponse_message_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_autoresponse
    ADD CONSTRAINT notices_autoresponse_message_id_key UNIQUE (message_id);


--
-- TOC entry 4308 (class 2606 OID 804562)
-- Name: notices_autoresponse notices_autoresponse_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_autoresponse
    ADD CONSTRAINT notices_autoresponse_pkey PRIMARY KEY (id);


--
-- TOC entry 4313 (class 2606 OID 804570)
-- Name: notices_batch notices_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_batch
    ADD CONSTRAINT notices_batch_pkey PRIMARY KEY (id);


--
-- TOC entry 4320 (class 2606 OID 804580)
-- Name: notices_envelope notices_envelope_message_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_message_id_key UNIQUE (message_id);


--
-- TOC entry 4323 (class 2606 OID 804595)
-- Name: notices_envelope notices_envelope_notice_id_phone_id_fe79cadf_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_notice_id_phone_id_fe79cadf_uniq UNIQUE (notice_id, phone_id);


--
-- TOC entry 4327 (class 2606 OID 804578)
-- Name: notices_envelope notices_envelope_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 804591)
-- Name: notices_notice notices_notice_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_notice
    ADD CONSTRAINT notices_notice_pkey PRIMARY KEY (id);


--
-- TOC entry 4229 (class 2606 OID 16617)
-- Name: nps_sitesocialmediainterstitialpage nps_sitesocialmediainterstitialpage_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_sitesocialmediainterstitialpage
    ADD CONSTRAINT nps_sitesocialmediainterstitialpage_pkey PRIMARY KEY (id);


--
-- TOC entry 4231 (class 2606 OID 16618)
-- Name: nps_sitesocialmediainterstitialpage nps_sitesocialmediainterstitialpage_site_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_sitesocialmediainterstitialpage
    ADD CONSTRAINT nps_sitesocialmediainterstitialpage_site_id_key UNIQUE (site_id);


--
-- TOC entry 4220 (class 2606 OID 16619)
-- Name: nps_socialmediainterstitial nps_socialmediainterstitial_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_socialmediainterstitial
    ADD CONSTRAINT nps_socialmediainterstitial_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 16620)
-- Name: nps_visit nps_visit_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_visit
    ADD CONSTRAINT nps_visit_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 2606 OID 16621)
-- Name: phone_number phone_number_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT phone_number_pkey PRIMARY KEY (id);


--
-- TOC entry 3970 (class 2606 OID 16622)
-- Name: reminders_reminder reminders_reminder_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reminders_reminder
    ADD CONSTRAINT reminders_reminder_pkey PRIMARY KEY (id);


--
-- TOC entry 4489 (class 2606 OID 875413)
-- Name: reputation_actionthreshold reputation_actionthreshold_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_actionthreshold
    ADD CONSTRAINT reputation_actionthreshold_pkey PRIMARY KEY (id);


--
-- TOC entry 4508 (class 2606 OID 923182)
-- Name: reputation_competitor reputation_competitor_location_id_place_id_9fa4f262_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_competitor
    ADD CONSTRAINT reputation_competitor_location_id_place_id_9fa4f262_uniq UNIQUE (location_id, place_id);


--
-- TOC entry 4510 (class 2606 OID 923173)
-- Name: reputation_competitor reputation_competitor_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_competitor
    ADD CONSTRAINT reputation_competitor_pkey PRIMARY KEY (id);


--
-- TOC entry 4436 (class 2606 OID 851753)
-- Name: reputation_gmbaccount reputation_gmbaccount_customer_id_name_97f0f9f0_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbaccount
    ADD CONSTRAINT reputation_gmbaccount_customer_id_name_97f0f9f0_uniq UNIQUE (customer_id, name);


--
-- TOC entry 4438 (class 2606 OID 851694)
-- Name: reputation_gmbaccount reputation_gmbaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbaccount
    ADD CONSTRAINT reputation_gmbaccount_pkey PRIMARY KEY (id);


--
-- TOC entry 4441 (class 2606 OID 851818)
-- Name: reputation_gmblocation reputation_gmblocation_account_id_name_eda663e0_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocation_account_id_name_eda663e0_uniq UNIQUE (account_id, name);


--
-- TOC entry 4443 (class 2606 OID 851816)
-- Name: reputation_gmblocation reputation_gmblocation_account_id_site_id_46cb6d53_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocation_account_id_site_id_46cb6d53_uniq UNIQUE (account_id, site_id);


--
-- TOC entry 4448 (class 2606 OID 851702)
-- Name: reputation_gmblocation reputation_gmblocation_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocation_pkey PRIMARY KEY (id);


--
-- TOC entry 4452 (class 2606 OID 851704)
-- Name: reputation_gmblocation reputation_gmblocation_site_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocation_site_id_key UNIQUE (site_id);


--
-- TOC entry 4468 (class 2606 OID 851737)
-- Name: reputation_gmbnotification reputation_gmbnotification_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotification
    ADD CONSTRAINT reputation_gmbnotification_pkey PRIMARY KEY (id);


--
-- TOC entry 4470 (class 2606 OID 851809)
-- Name: reputation_gmbnotification reputation_gmbnotification_review_id_0e88eccb_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotification
    ADD CONSTRAINT reputation_gmbnotification_review_id_0e88eccb_uniq UNIQUE (review_id);


--
-- TOC entry 4474 (class 2606 OID 851805)
-- Name: reputation_gmbnotifyee reputation_gmbnotifyee_customer_id_email_4eacfcde_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotifyee
    ADD CONSTRAINT reputation_gmbnotifyee_customer_id_email_4eacfcde_uniq UNIQUE (customer_id, email);


--
-- TOC entry 4476 (class 2606 OID 851746)
-- Name: reputation_gmbnotifyee reputation_gmbnotifyee_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotifyee
    ADD CONSTRAINT reputation_gmbnotifyee_pkey PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 851726)
-- Name: reputation_gmbreplyaction reputation_gmbreplyaction_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreplyaction
    ADD CONSTRAINT reputation_gmbreplyaction_pkey PRIMARY KEY (id);


--
-- TOC entry 4456 (class 2606 OID 851774)
-- Name: reputation_gmbreview reputation_gmbreview_location_id_name_b133e014_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreview
    ADD CONSTRAINT reputation_gmbreview_location_id_name_b133e014_uniq UNIQUE (location_id, name);


--
-- TOC entry 4460 (class 2606 OID 851715)
-- Name: reputation_gmbreview reputation_gmbreview_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreview
    ADD CONSTRAINT reputation_gmbreview_pkey PRIMARY KEY (id);


--
-- TOC entry 4480 (class 2606 OID 875383)
-- Name: reputation_reviewticket reputation_reviewticket_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4482 (class 2606 OID 875385)
-- Name: reputation_reviewticket reputation_reviewticket_review_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewticket_review_id_key UNIQUE (review_id);


--
-- TOC entry 4484 (class 2606 OID 875387)
-- Name: reputation_reviewticket reputation_reviewticket_ticket_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewticket_ticket_id_key UNIQUE (ticket_id);


--
-- TOC entry 4175 (class 2606 OID 16623)
-- Name: reviews_feed reviews_feed_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_feed
    ADD CONSTRAINT reviews_feed_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 16624)
-- Name: reviews_feed reviews_feed_site_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_feed
    ADD CONSTRAINT reviews_feed_site_id_key UNIQUE (site_id);


--
-- TOC entry 4181 (class 2606 OID 16625)
-- Name: reviews_review reviews_review_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_review
    ADD CONSTRAINT reviews_review_pkey PRIMARY KEY (id);


--
-- TOC entry 4183 (class 2606 OID 16626)
-- Name: reviews_review reviews_review_ticket_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_review
    ADD CONSTRAINT reviews_review_ticket_id_key UNIQUE (ticket_id);


--
-- TOC entry 4278 (class 2606 OID 676814)
-- Name: securedrop_drop securedrop_drop_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.securedrop_drop
    ADD CONSTRAINT securedrop_drop_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 676825)
-- Name: securedrop_pickup securedrop_pickup_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.securedrop_pickup
    ADD CONSTRAINT securedrop_pickup_pkey PRIMARY KEY (id);


--
-- TOC entry 3974 (class 2606 OID 16627)
-- Name: sms_callfilehistory sms_callfilehistory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_callfilehistory
    ADD CONSTRAINT sms_callfilehistory_pkey PRIMARY KEY (id);


--
-- TOC entry 3986 (class 2606 OID 16628)
-- Name: sms_message_incoming sms_message_incoming_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message_incoming
    ADD CONSTRAINT sms_message_incoming_pkey PRIMARY KEY (id);


--
-- TOC entry 3991 (class 2606 OID 16629)
-- Name: sms_message_incoming_unrecognized sms_message_incoming_unrecognized_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message_incoming_unrecognized
    ADD CONSTRAINT sms_message_incoming_unrecognized_pkey PRIMARY KEY (id);


--
-- TOC entry 3980 (class 2606 OID 16630)
-- Name: sms_message sms_message_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message
    ADD CONSTRAINT sms_message_pkey PRIMARY KEY (id);


--
-- TOC entry 3993 (class 2606 OID 16631)
-- Name: socialaccount_socialaccount socialaccount_socialaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_pkey PRIMARY KEY (id);


--
-- TOC entry 3995 (class 2606 OID 16632)
-- Name: socialaccount_socialaccount socialaccount_socialaccount_uid_7df0d784122f58_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_uid_7df0d784122f58_uniq UNIQUE (uid, provider);


--
-- TOC entry 3998 (class 2606 OID 16633)
-- Name: socialaccount_socialapp socialaccount_socialapp_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp
    ADD CONSTRAINT socialaccount_socialapp_pkey PRIMARY KEY (id);


--
-- TOC entry 4000 (class 2606 OID 16634)
-- Name: socialaccount_socialapp_sites socialaccount_socialapp_site_socialapp_id_32340c070a77fe67_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp_site_socialapp_id_32340c070a77fe67_uniq UNIQUE (socialapp_id, site_id);


--
-- TOC entry 4002 (class 2606 OID 16635)
-- Name: socialaccount_socialapp_sites socialaccount_socialapp_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp_sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4008 (class 2606 OID 16636)
-- Name: socialaccount_socialtoken socialaccount_socialtoken_app_id_1307304fad2cbabe_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_app_id_1307304fad2cbabe_uniq UNIQUE (app_id, account_id);


--
-- TOC entry 4010 (class 2606 OID 16637)
-- Name: socialaccount_socialtoken socialaccount_socialtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_pkey PRIMARY KEY (id);


--
-- TOC entry 4429 (class 2606 OID 846496)
-- Name: sources_customercode sources_customercode_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_customercode
    ADD CONSTRAINT sources_customercode_pkey PRIMARY KEY (id);


--
-- TOC entry 4432 (class 2606 OID 846533)
-- Name: sources_customercode sources_customercode_source_id_code_9f82a459_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_customercode
    ADD CONSTRAINT sources_customercode_source_id_code_9f82a459_uniq UNIQUE (source_id, code);


--
-- TOC entry 4422 (class 2606 OID 846488)
-- Name: sources_internalasset sources_internalasset_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalasset
    ADD CONSTRAINT sources_internalasset_pkey PRIMARY KEY (id);


--
-- TOC entry 4425 (class 2606 OID 846517)
-- Name: sources_internalasset sources_internalasset_source_id_name_edf033ae_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalasset
    ADD CONSTRAINT sources_internalasset_source_id_name_edf033ae_uniq UNIQUE (source_id, name);


--
-- TOC entry 4413 (class 2606 OID 846466)
-- Name: sources_internalsource sources_internalsource_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsource
    ADD CONSTRAINT sources_internalsource_pkey PRIMARY KEY (id);


--
-- TOC entry 4416 (class 2606 OID 846477)
-- Name: sources_internalsourcecheck sources_internalsourcecheck_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsourcecheck
    ADD CONSTRAINT sources_internalsourcecheck_pkey PRIMARY KEY (id);


--
-- TOC entry 4012 (class 2606 OID 16638)
-- Name: south_migrationhistory south_migrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.south_migrationhistory
    ADD CONSTRAINT south_migrationhistory_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 780080)
-- Name: sso_samlprovider sso_samlprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sso_samlprovider
    ADD CONSTRAINT sso_samlprovider_pkey PRIMARY KEY (uuid);


--
-- TOC entry 4014 (class 2606 OID 16639)
-- Name: stage_raw_files_for_import stage_raw_files_for_import_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.stage_raw_files_for_import
    ADD CONSTRAINT stage_raw_files_for_import_pkey PRIMARY KEY (id);


--
-- TOC entry 4018 (class 2606 OID 16640)
-- Name: staged_patient_data_holding staged_patient_data_holding_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.staged_patient_data_holding
    ADD CONSTRAINT staged_patient_data_holding_pkey PRIMARY KEY (id);


--
-- TOC entry 4016 (class 2606 OID 16641)
-- Name: staged_patient_data staged_patient_data_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.staged_patient_data
    ADD CONSTRAINT staged_patient_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4225 (class 2606 OID 16644)
-- Name: surveys_commentcategorization surveys_commentcategorization_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategorization
    ADD CONSTRAINT surveys_commentcategorization_pkey PRIMARY KEY (id);


--
-- TOC entry 4227 (class 2606 OID 16645)
-- Name: surveys_commentcategorization surveys_commentcategorization_survey_response_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategorization
    ADD CONSTRAINT surveys_commentcategorization_survey_response_id_key UNIQUE (survey_response_id);


--
-- TOC entry 4233 (class 2606 OID 532160)
-- Name: surveys_commentcategory surveys_commentcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategory
    ADD CONSTRAINT surveys_commentcategory_pkey PRIMARY KEY (id);


--
-- TOC entry 4235 (class 2606 OID 532173)
-- Name: surveys_commenttopic surveys_commenttopic_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commenttopic
    ADD CONSTRAINT surveys_commenttopic_pkey PRIMARY KEY (id);


--
-- TOC entry 4021 (class 2606 OID 16646)
-- Name: surveys_npsscorechange surveys_npsscorechange_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscorechange
    ADD CONSTRAINT surveys_npsscorechange_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 16647)
-- Name: surveys_npsscoreremoval surveys_npsscoreremoval_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval
    ADD CONSTRAINT surveys_npsscoreremoval_pkey PRIMARY KEY (id);


--
-- TOC entry 4025 (class 2606 OID 16648)
-- Name: surveys_npssurveyresponse surveys_npssurveyresponse_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npssurveyresponse
    ADD CONSTRAINT surveys_npssurveyresponse_pkey PRIMARY KEY (surveyresponse_ptr_id);


--
-- TOC entry 4267 (class 2606 OID 542623)
-- Name: surveys_smartsurveytemplatedefault surveys_smartsurveytemplatedefault_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_smartsurveytemplatedefault
    ADD CONSTRAINT surveys_smartsurveytemplatedefault_pkey PRIMARY KEY (id);


--
-- TOC entry 4027 (class 2606 OID 16649)
-- Name: surveys_survey surveys_survey_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey
    ADD CONSTRAINT surveys_survey_pkey PRIMARY KEY (id);


--
-- TOC entry 4032 (class 2606 OID 16650)
-- Name: surveys_survey_request surveys_survey_request_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request
    ADD CONSTRAINT surveys_survey_request_pkey PRIMARY KEY (id);


--
-- TOC entry 4036 (class 2606 OID 16651)
-- Name: surveys_survey_request surveys_survey_request_unique_short_slug_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request
    ADD CONSTRAINT surveys_survey_request_unique_short_slug_key UNIQUE (unique_short_slug);


--
-- TOC entry 4039 (class 2606 OID 16652)
-- Name: surveys_surveyresponse surveys_surveyresponse_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_surveyresponse
    ADD CONSTRAINT surveys_surveyresponse_pkey PRIMARY KEY (id);


--
-- TOC entry 4405 (class 2606 OID 809908)
-- Name: teams_dm teams_dm_message_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm
    ADD CONSTRAINT teams_dm_message_id_key UNIQUE (message_id);


--
-- TOC entry 4407 (class 2606 OID 809906)
-- Name: teams_dm teams_dm_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm
    ADD CONSTRAINT teams_dm_pkey PRIMARY KEY (id);


--
-- TOC entry 4339 (class 2606 OID 809928)
-- Name: teams_envelope teams_envelope_message_id_76f74eca_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_message_id_76f74eca_uniq UNIQUE (message_id);


--
-- TOC entry 4342 (class 2606 OID 809508)
-- Name: teams_envelope teams_envelope_notice_id_member_id_62d12f76_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_notice_id_member_id_62d12f76_uniq UNIQUE (notice_id, member_id);


--
-- TOC entry 4344 (class 2606 OID 809427)
-- Name: teams_envelope teams_envelope_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 809435)
-- Name: teams_member teams_member_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member
    ADD CONSTRAINT teams_member_pkey PRIMARY KEY (id);


--
-- TOC entry 4349 (class 2606 OID 809502)
-- Name: teams_member teams_member_provider_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member
    ADD CONSTRAINT teams_member_provider_id_key UNIQUE (provider_id);


--
-- TOC entry 4352 (class 2606 OID 809506)
-- Name: teams_member teams_member_team_id_provider_id_ae05a4a0_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member
    ADD CONSTRAINT teams_member_team_id_provider_id_ae05a4a0_uniq UNIQUE (team_id, provider_id);


--
-- TOC entry 4359 (class 2606 OID 809446)
-- Name: teams_messagein teams_messagein_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein
    ADD CONSTRAINT teams_messagein_pkey PRIMARY KEY (id);


--
-- TOC entry 4361 (class 2606 OID 809448)
-- Name: teams_messagein teams_messagein_plivo_uuid_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein
    ADD CONSTRAINT teams_messagein_plivo_uuid_key UNIQUE (plivo_uuid);


--
-- TOC entry 4371 (class 2606 OID 809459)
-- Name: teams_messageout teams_messageout_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messageout
    ADD CONSTRAINT teams_messageout_pkey PRIMARY KEY (id);


--
-- TOC entry 4373 (class 2606 OID 809461)
-- Name: teams_messageout teams_messageout_plivo_uuid_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messageout
    ADD CONSTRAINT teams_messageout_plivo_uuid_key UNIQUE (plivo_uuid);


--
-- TOC entry 4378 (class 2606 OID 809472)
-- Name: teams_notice teams_notice_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_notice
    ADD CONSTRAINT teams_notice_pkey PRIMARY KEY (id);


--
-- TOC entry 4383 (class 2606 OID 809633)
-- Name: teams_phone teams_phone_member_id_6fff9efe_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone
    ADD CONSTRAINT teams_phone_member_id_6fff9efe_uniq UNIQUE (member_id);


--
-- TOC entry 4387 (class 2606 OID 809480)
-- Name: teams_phone teams_phone_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone
    ADD CONSTRAINT teams_phone_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 809504)
-- Name: teams_phone teams_phone_team_id_number_40e66a07_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone
    ADD CONSTRAINT teams_phone_team_id_number_40e66a07_uniq UNIQUE (team_id, number);


--
-- TOC entry 4394 (class 2606 OID 809490)
-- Name: teams_receipt teams_receipt_message_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_receipt
    ADD CONSTRAINT teams_receipt_message_id_key UNIQUE (message_id);


--
-- TOC entry 4396 (class 2606 OID 809488)
-- Name: teams_receipt teams_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_receipt
    ADD CONSTRAINT teams_receipt_pkey PRIMARY KEY (id);


--
-- TOC entry 4399 (class 2606 OID 809500)
-- Name: teams_team teams_team_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_team
    ADD CONSTRAINT teams_team_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4401 (class 2606 OID 809498)
-- Name: teams_team teams_team_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_team
    ADD CONSTRAINT teams_team_pkey PRIMARY KEY (id);


--
-- TOC entry 4043 (class 2606 OID 16653)
-- Name: ticket_adhoc_employee ticket_adhoc_employee_name_2bdfade200cd3618_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_adhoc_employee
    ADD CONSTRAINT ticket_adhoc_employee_name_2bdfade200cd3618_uniq UNIQUE (name, owned_by_cust_id);


--
-- TOC entry 4046 (class 2606 OID 16654)
-- Name: ticket_adhoc_employee ticket_adhoc_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_adhoc_employee
    ADD CONSTRAINT ticket_adhoc_employee_pkey PRIMARY KEY (id);


--
-- TOC entry 4049 (class 2606 OID 16655)
-- Name: ticket_category ticket_category_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_category
    ADD CONSTRAINT ticket_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 16656)
-- Name: ticket_customer_cohort ticket_customer_priority_customer_ref_id_7651221c4ca487b0_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_customer_cohort
    ADD CONSTRAINT ticket_customer_priority_customer_ref_id_7651221c4ca487b0_uniq UNIQUE (customer_ref_id, cohort_ref_id);


--
-- TOC entry 4115 (class 2606 OID 16657)
-- Name: ticket_customer_cohort ticket_customer_priority_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_customer_cohort
    ADD CONSTRAINT ticket_customer_priority_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 16658)
-- Name: ticket_draftnote ticket_draftnote_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_draftnote
    ADD CONSTRAINT ticket_draftnote_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 16659)
-- Name: ticket_draftnote ticket_draftnote_ticket_id_406f8c1a69caa0a7_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_draftnote
    ADD CONSTRAINT ticket_draftnote_ticket_id_406f8c1a69caa0a7_uniq UNIQUE (ticket_id, user_id);


--
-- TOC entry 4055 (class 2606 OID 16660)
-- Name: ticket_employee_lookup ticket_employee_lookup_owned_by_ticket_id_5e29d3e554a519e3_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT ticket_employee_lookup_owned_by_ticket_id_5e29d3e554a519e3_uniq UNIQUE (owned_by_ticket_id, system_user_id, adhoc_employee_id, system_provider_id);


--
-- TOC entry 4057 (class 2606 OID 16661)
-- Name: ticket_employee_lookup ticket_employee_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT ticket_employee_lookup_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 16662)
-- Name: ticket_note ticket_note_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_note
    ADD CONSTRAINT ticket_note_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 16663)
-- Name: ticket_patient_ticket ticket_patient_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_patient_ticket
    ADD CONSTRAINT ticket_patient_ticket_pkey PRIMARY KEY (ticket_ptr_id);


--
-- TOC entry 4117 (class 2606 OID 16664)
-- Name: ticket_cohort ticket_priority_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_cohort
    ADD CONSTRAINT ticket_priority_pkey PRIMARY KEY (id);


--
-- TOC entry 4065 (class 2606 OID 16665)
-- Name: ticket_status_history ticket_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_status_history
    ADD CONSTRAINT ticket_status_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4070 (class 2606 OID 16666)
-- Name: ticket_tag ticket_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_tag
    ADD CONSTRAINT ticket_tag_pkey PRIMARY KEY (id);


--
-- TOC entry 4080 (class 2606 OID 16667)
-- Name: ticket_ticket ticket_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT ticket_ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4088 (class 2606 OID 16668)
-- Name: user_meta user_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.user_meta
    ADD CONSTRAINT user_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4091 (class 2606 OID 16669)
-- Name: user_meta user_meta_user_id_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.user_meta
    ADD CONSTRAINT user_meta_user_id_uniq UNIQUE (user_id);


--
-- TOC entry 4287 (class 2606 OID 792824)
-- Name: whitelists_address whitelists_address_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_address
    ADD CONSTRAINT whitelists_address_pkey PRIMARY KEY (uuid);


--
-- TOC entry 4290 (class 2606 OID 792833)
-- Name: whitelists_address whitelists_address_whitelist_id_value_e76fe419_uniq; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_address
    ADD CONSTRAINT whitelists_address_whitelist_id_value_e76fe419_uniq UNIQUE (whitelist_id, value);


--
-- TOC entry 4293 (class 2606 OID 792831)
-- Name: whitelists_whitelist whitelists_whitelist_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_whitelist
    ADD CONSTRAINT whitelists_whitelist_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4295 (class 2606 OID 792829)
-- Name: whitelists_whitelist whitelists_whitelist_pkey; Type: CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_whitelist
    ADD CONSTRAINT whitelists_whitelist_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3801 (class 1259 OID 22493)
-- Name: account_emailaddress_email_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX account_emailaddress_email_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- TOC entry 3804 (class 1259 OID 17018)
-- Name: account_emailaddress_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX account_emailaddress_user_id ON public.account_emailaddress USING btree (user_id);


--
-- TOC entry 3805 (class 1259 OID 17019)
-- Name: account_emailconfirmation_email_address_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX account_emailconfirmation_email_address_id ON public.account_emailconfirmation USING btree (email_address_id);


--
-- TOC entry 3808 (class 1259 OID 17020)
-- Name: account_emailconfirmation_key_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX account_emailconfirmation_key_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- TOC entry 3815 (class 1259 OID 17021)
-- Name: admin_tools_dashboard_preferences_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX admin_tools_dashboard_preferences_user_id ON public.admin_tools_dashboard_preferences USING btree (user_id);


--
-- TOC entry 3818 (class 1259 OID 17022)
-- Name: admin_tools_menu_bookmark_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX admin_tools_menu_bookmark_user_id ON public.admin_tools_menu_bookmark USING btree (user_id);


--
-- TOC entry 4527 (class 1259 OID 999997)
-- Name: analytics_data_nps_tmp_cohort_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_cohort_id_idx1 ON public.analytics_data_nps USING btree (cohort_id);


--
-- TOC entry 4528 (class 1259 OID 999995)
-- Name: analytics_data_nps_tmp_customer_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_customer_id_idx1 ON public.analytics_data_nps USING btree (customer_id);


--
-- TOC entry 4529 (class 1259 OID 999999)
-- Name: analytics_data_nps_tmp_date_seen_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_date_seen_idx1 ON public.analytics_data_nps USING btree (date_seen);


--
-- TOC entry 4530 (class 1259 OID 999996)
-- Name: analytics_data_nps_tmp_organization_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_organization_id_idx1 ON public.analytics_data_nps USING btree (organization_id);


--
-- TOC entry 4533 (class 1259 OID 999993)
-- Name: analytics_data_nps_tmp_provider_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_provider_id_idx1 ON public.analytics_data_nps USING btree (provider_id);


--
-- TOC entry 4534 (class 1259 OID 999994)
-- Name: analytics_data_nps_tmp_site_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_site_id_idx1 ON public.analytics_data_nps USING btree (site_id);


--
-- TOC entry 4535 (class 1259 OID 999998)
-- Name: analytics_data_nps_tmp_survey_response_id_idx; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_nps_tmp_survey_response_id_idx ON public.analytics_data_nps USING btree (survey_response_id);


--
-- TOC entry 4536 (class 1259 OID 1000012)
-- Name: analytics_data_tickets_tmp_customer_id_idx1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_tickets_tmp_customer_id_idx1 ON public.analytics_data_tickets USING btree (customer_id);


--
-- TOC entry 4539 (class 1259 OID 1000019)
-- Name: analytics_data_topics_tmp_survey_response_id_idx; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_topics_tmp_survey_response_id_idx ON public.analytics_data_topics USING btree (survey_response_id);


--
-- TOC entry 4540 (class 1259 OID 1000020)
-- Name: analytics_data_topics_tmp_type_id_idx; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_data_topics_tmp_type_id_idx ON public.analytics_data_topics USING btree (type_id);


--
-- TOC entry 3821 (class 1259 OID 861491)
-- Name: analytics_providerengagement_access_type_20210112; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_providerengagement_access_type_20210112 ON public.analytics_providerengagement USING btree (access_type);


--
-- TOC entry 3824 (class 1259 OID 17023)
-- Name: analytics_providerengagement_provider_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_providerengagement_provider_id ON public.analytics_providerengagement USING btree (provider_id);


--
-- TOC entry 4268 (class 1259 OID 551890)
-- Name: analytics_siteengagement_9365d6e7; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_siteengagement_9365d6e7 ON public.analytics_siteengagement USING btree (site_id);


--
-- TOC entry 4189 (class 1259 OID 203762)
-- Name: analytics_socialmediarevie_review_targets_66586d86255ff6b7_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediarevie_review_targets_66586d86255ff6b7_like ON public.analytics_socialmediareviewrequest USING btree (review_targets varchar_pattern_ops);


--
-- TOC entry 4190 (class 1259 OID 203761)
-- Name: analytics_socialmediarevie_review_targets_66586d86255ff6b7_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediarevie_review_targets_66586d86255ff6b7_uniq ON public.analytics_socialmediareviewrequest USING btree (review_targets);


--
-- TOC entry 4191 (class 1259 OID 187613)
-- Name: analytics_socialmediareviewrequest_32ca2ddc; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_32ca2ddc ON public.analytics_socialmediareviewrequest USING btree (provider_id);


--
-- TOC entry 4192 (class 1259 OID 187609)
-- Name: analytics_socialmediareviewrequest_4d966fcc; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_4d966fcc ON public.analytics_socialmediareviewrequest USING btree (outgoing_sms_message_id);


--
-- TOC entry 4193 (class 1259 OID 187612)
-- Name: analytics_socialmediareviewrequest_9365d6e7; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_9365d6e7 ON public.analytics_socialmediareviewrequest USING btree (site_id);


--
-- TOC entry 4194 (class 1259 OID 187610)
-- Name: analytics_socialmediareviewrequest_b2cf4a61; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_b2cf4a61 ON public.analytics_socialmediareviewrequest USING btree (patient_visit_id);


--
-- TOC entry 4195 (class 1259 OID 187608)
-- Name: analytics_socialmediareviewrequest_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_cb24373b ON public.analytics_socialmediareviewrequest USING btree (customer_id);


--
-- TOC entry 4196 (class 1259 OID 187611)
-- Name: analytics_socialmediareviewrequest_d193b3fd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX analytics_socialmediareviewrequest_d193b3fd ON public.analytics_socialmediareviewrequest USING btree (phone_number_id);


--
-- TOC entry 3827 (class 1259 OID 831694)
-- Name: auth_group_name_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_group_name_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3830 (class 1259 OID 17025)
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_group_permissions_group_id ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3833 (class 1259 OID 17026)
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_group_permissions_permission_id ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3836 (class 1259 OID 17027)
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_permission_content_type_id ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3846 (class 1259 OID 17028)
-- Name: auth_user_groups_group_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_user_groups_group_id ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3849 (class 1259 OID 17029)
-- Name: auth_user_groups_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_user_groups_user_id ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3852 (class 1259 OID 17030)
-- Name: auth_user_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_user_user_permissions_permission_id ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3855 (class 1259 OID 17031)
-- Name: auth_user_user_permissions_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_user_user_permissions_user_id ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3845 (class 1259 OID 723295)
-- Name: auth_user_username_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX auth_user_username_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 3858 (class 1259 OID 22494)
-- Name: axes_accessattempt_ip_address_22297bc03370521a_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accessattempt_ip_address_22297bc03370521a_uniq ON public.axes_accessattempt USING btree (ip_address);


--
-- TOC entry 3861 (class 1259 OID 22497)
-- Name: axes_accessattempt_user_agent_1cd8e4105f576d11_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accessattempt_user_agent_1cd8e4105f576d11_like ON public.axes_accessattempt USING btree (user_agent varchar_pattern_ops);


--
-- TOC entry 3862 (class 1259 OID 22496)
-- Name: axes_accessattempt_user_agent_1cd8e4105f576d11_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accessattempt_user_agent_1cd8e4105f576d11_uniq ON public.axes_accessattempt USING btree (user_agent);


--
-- TOC entry 3863 (class 1259 OID 22499)
-- Name: axes_accessattempt_username_1ea27bec9024b12a_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accessattempt_username_1ea27bec9024b12a_like ON public.axes_accessattempt USING btree (username varchar_pattern_ops);


--
-- TOC entry 3864 (class 1259 OID 22498)
-- Name: axes_accessattempt_username_1ea27bec9024b12a_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accessattempt_username_1ea27bec9024b12a_uniq ON public.axes_accessattempt USING btree (username);


--
-- TOC entry 3865 (class 1259 OID 22500)
-- Name: axes_accesslog_ip_address_52f81dc056462c97_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accesslog_ip_address_52f81dc056462c97_uniq ON public.axes_accesslog USING btree (ip_address);


--
-- TOC entry 3868 (class 1259 OID 22503)
-- Name: axes_accesslog_user_agent_51311aa81987d594_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accesslog_user_agent_51311aa81987d594_like ON public.axes_accesslog USING btree (user_agent varchar_pattern_ops);


--
-- TOC entry 3869 (class 1259 OID 22502)
-- Name: axes_accesslog_user_agent_51311aa81987d594_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accesslog_user_agent_51311aa81987d594_uniq ON public.axes_accesslog USING btree (user_agent);


--
-- TOC entry 3870 (class 1259 OID 22505)
-- Name: axes_accesslog_username_7adb7ec8f767fe0b_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accesslog_username_7adb7ec8f767fe0b_like ON public.axes_accesslog USING btree (username varchar_pattern_ops);


--
-- TOC entry 3871 (class 1259 OID 22504)
-- Name: axes_accesslog_username_7adb7ec8f767fe0b_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX axes_accesslog_username_7adb7ec8f767fe0b_uniq ON public.axes_accesslog USING btree (username);


--
-- TOC entry 3872 (class 1259 OID 17033)
-- Name: callfile_belongs_to_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX callfile_belongs_to_id ON public.callfile USING btree (belongs_to_id);


--
-- TOC entry 3875 (class 1259 OID 160735)
-- Name: callfile_customer_26b2345e; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX callfile_customer_26b2345e ON public.callfile_customer USING btree (organization_id);


--
-- TOC entry 3876 (class 1259 OID 928511)
-- Name: callfile_customer_default_interaction_group_id_7e8bbd90; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX callfile_customer_default_interaction_group_id_7e8bbd90 ON public.callfile_customer USING btree (default_interaction_group_id);


--
-- TOC entry 4136 (class 1259 OID 54332)
-- Name: conversations_contact_9365d6e7; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_contact_9365d6e7 ON public.conversations_contact USING btree (site_id);


--
-- TOC entry 4137 (class 1259 OID 54331)
-- Name: conversations_contact_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_contact_cb24373b ON public.conversations_contact USING btree (customer_id);


--
-- TOC entry 4140 (class 1259 OID 54338)
-- Name: conversations_conversation_6d82f13d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversation_6d82f13d ON public.conversations_conversation USING btree (contact_id);


--
-- TOC entry 4141 (class 1259 OID 54381)
-- Name: conversations_conversation_7604609c; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversation_7604609c ON public.conversations_conversation USING btree (conversation_type_id);


--
-- TOC entry 4142 (class 1259 OID 54387)
-- Name: conversations_conversation_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversation_cb24373b ON public.conversations_conversation USING btree (customer_id);


--
-- TOC entry 4145 (class 1259 OID 54344)
-- Name: conversations_conversationtype_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversationtype_cb24373b ON public.conversations_conversationtype USING btree (customer_id);


--
-- TOC entry 4160 (class 1259 OID 54379)
-- Name: conversations_conversationtype_templates_4dcc30d4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversationtype_templates_4dcc30d4 ON public.conversations_conversationtype_templates USING btree (conversationtype_id);


--
-- TOC entry 4161 (class 1259 OID 54380)
-- Name: conversations_conversationtype_templates_74f53564; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_conversationtype_templates_74f53564 ON public.conversations_conversationtype_templates USING btree (template_id);


--
-- TOC entry 4148 (class 1259 OID 54355)
-- Name: conversations_inboundmessage_6d82f13d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_inboundmessage_6d82f13d ON public.conversations_inboundmessage USING btree (contact_id);


--
-- TOC entry 4149 (class 1259 OID 54356)
-- Name: conversations_inboundmessage_d52ac232; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_inboundmessage_d52ac232 ON public.conversations_inboundmessage USING btree (conversation_id);


--
-- TOC entry 4168 (class 1259 OID 80110)
-- Name: conversations_optin_2dbcba41; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_optin_2dbcba41 ON public.conversations_optin USING btree (slug);


--
-- TOC entry 4173 (class 1259 OID 80111)
-- Name: conversations_optin_slug_2f6625487ac501ac_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_optin_slug_2f6625487ac501ac_like ON public.conversations_optin USING btree (slug varchar_pattern_ops);


--
-- TOC entry 4152 (class 1259 OID 54367)
-- Name: conversations_outboundmessage_6d82f13d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_outboundmessage_6d82f13d ON public.conversations_outboundmessage USING btree (contact_id);


--
-- TOC entry 4153 (class 1259 OID 54368)
-- Name: conversations_outboundmessage_d52ac232; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX conversations_outboundmessage_d52ac232 ON public.conversations_outboundmessage USING btree (conversation_id);


--
-- TOC entry 4101 (class 1259 OID 24769)
-- Name: customer_comment_agg_7e86d60c; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_comment_agg_7e86d60c ON public.customer_comment_agg USING btree (comment_owner_id);


--
-- TOC entry 4102 (class 1259 OID 24770)
-- Name: customer_comment_agg_fingerprint_1112b6dac646f99e_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_comment_agg_fingerprint_1112b6dac646f99e_like ON public.customer_comment_agg USING btree (fingerprint varchar_pattern_ops);


--
-- TOC entry 4296 (class 1259 OID 802605)
-- Name: customer_legacyidentifier_created_at_bdc753f3; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_legacyidentifier_created_at_bdc753f3 ON public.customer_legacyidentifier USING btree (created_at);


--
-- TOC entry 4301 (class 1259 OID 802606)
-- Name: customer_legacyidentifier_value_577b3f25; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_legacyidentifier_value_577b3f25 ON public.customer_legacyidentifier USING btree (value);


--
-- TOC entry 4302 (class 1259 OID 802607)
-- Name: customer_legacyidentifier_value_577b3f25_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_legacyidentifier_value_577b3f25_like ON public.customer_legacyidentifier USING btree (value varchar_pattern_ops);


--
-- TOC entry 4107 (class 1259 OID 24804)
-- Name: customer_linkclicktracking_1a3917c2; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_linkclicktracking_1a3917c2 ON public.customer_linkclicktracking USING btree (for_site_id);


--
-- TOC entry 4118 (class 1259 OID 26388)
-- Name: customer_mergedentityhistory_ce9898af; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_mergedentityhistory_ce9898af ON public.customer_mergedentityhistory USING btree (related_customer_id);


--
-- TOC entry 4186 (class 1259 OID 802033)
-- Name: customer_organization_prefix_02f17946_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_organization_prefix_02f17946_like ON public.customer_organization USING btree (prefix varchar_pattern_ops);


--
-- TOC entry 4205 (class 1259 OID 238302)
-- Name: customer_patient_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_cb24373b ON public.customer_patient USING btree (customer_id);


--
-- TOC entry 4206 (class 1259 OID 238309)
-- Name: customer_patient_date_of_birth_5aae96f1e2c1d12c_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_date_of_birth_5aae96f1e2c1d12c_uniq ON public.customer_patient USING btree (date_of_birth);


--
-- TOC entry 4207 (class 1259 OID 238311)
-- Name: customer_patient_external_patient_id_707052b1460b3743_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_external_patient_id_707052b1460b3743_like ON public.customer_patient USING btree (external_patient_id varchar_pattern_ops);


--
-- TOC entry 4208 (class 1259 OID 238310)
-- Name: customer_patient_external_patient_id_707052b1460b3743_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_external_patient_id_707052b1460b3743_uniq ON public.customer_patient USING btree (external_patient_id);


--
-- TOC entry 4209 (class 1259 OID 238313)
-- Name: customer_patient_first_name_229e06471e9bac21_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_first_name_229e06471e9bac21_like ON public.customer_patient USING btree (first_name varchar_pattern_ops);


--
-- TOC entry 4210 (class 1259 OID 238312)
-- Name: customer_patient_first_name_229e06471e9bac21_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_first_name_229e06471e9bac21_uniq ON public.customer_patient USING btree (first_name);


--
-- TOC entry 4211 (class 1259 OID 238315)
-- Name: customer_patient_last_name_23da5d8cac5d5ea4_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_last_name_23da5d8cac5d5ea4_like ON public.customer_patient USING btree (last_name varchar_pattern_ops);


--
-- TOC entry 4212 (class 1259 OID 238314)
-- Name: customer_patient_last_name_23da5d8cac5d5ea4_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_last_name_23da5d8cac5d5ea4_uniq ON public.customer_patient USING btree (last_name);


--
-- TOC entry 4215 (class 1259 OID 803034)
-- Name: customer_patient_uuid_20200312; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patient_uuid_20200312 ON public.customer_patient USING btree (uuid);


--
-- TOC entry 3883 (class 1259 OID 17034)
-- Name: customer_patientoptin_customer_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientoptin_customer_id ON public.customer_patientoptin USING btree (customer_id);


--
-- TOC entry 3884 (class 1259 OID 17035)
-- Name: customer_patientoptin_logged_in_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientoptin_logged_in_user_id ON public.customer_patientoptin USING btree (logged_in_user_id);


--
-- TOC entry 3887 (class 1259 OID 268389)
-- Name: customer_patientoptou_phone_number_string_7f8a70a7936ada3b_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientoptou_phone_number_string_7f8a70a7936ada3b_like ON public.customer_patientoptout USING btree (phone_number_string varchar_pattern_ops);


--
-- TOC entry 3888 (class 1259 OID 268388)
-- Name: customer_patientoptou_phone_number_string_7f8a70a7936ada3b_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientoptou_phone_number_string_7f8a70a7936ada3b_uniq ON public.customer_patientoptout USING btree (phone_number_string);


--
-- TOC entry 3889 (class 1259 OID 17036)
-- Name: customer_patientoptout_created_by_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientoptout_created_by_id ON public.customer_patientoptout USING btree (created_by_id);


--
-- TOC entry 3892 (class 1259 OID 19841)
-- Name: customer_patientvisithistory_date_seen; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_date_seen ON public.customer_patientvisithistory USING btree (date_seen);


--
-- TOC entry 3893 (class 1259 OID 238303)
-- Name: customer_patientvisithistory_f77cd8db; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_f77cd8db ON public.customer_patientvisithistory USING btree (related_patient_id);


--
-- TOC entry 3894 (class 1259 OID 944708)
-- Name: customer_patientvisithistory_is_enrolled_20220310; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_is_enrolled_20220310 ON public.customer_patientvisithistory USING btree (is_enrolled);


--
-- TOC entry 3895 (class 1259 OID 17037)
-- Name: customer_patientvisithistory_patient_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_patient_id ON public.customer_patientvisithistory USING btree (phone_number_id);


--
-- TOC entry 3898 (class 1259 OID 17041)
-- Name: customer_patientvisithistory_provider_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_provider_id ON public.customer_patientvisithistory USING btree (provider_id);


--
-- TOC entry 3899 (class 1259 OID 17044)
-- Name: customer_patientvisithistory_site_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_patientvisithistory_site_id ON public.customer_patientvisithistory USING btree (site_id);


--
-- TOC entry 3900 (class 1259 OID 17045)
-- Name: customer_phonenumbermismatch_phone_number_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_phonenumbermismatch_phone_number_id ON public.customer_phonenumbermismatch USING btree (phone_number_id);


--
-- TOC entry 3903 (class 1259 OID 17046)
-- Name: customer_provider_employed_by_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_provider_employed_by_id ON public.customer_provider USING btree (employed_by_id);


--
-- TOC entry 3906 (class 1259 OID 813878)
-- Name: customer_provider_phone_number_d3cb4cff; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_provider_phone_number_d3cb4cff ON public.customer_provider USING btree (phone_number);


--
-- TOC entry 3907 (class 1259 OID 813879)
-- Name: customer_provider_phone_number_d3cb4cff_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_provider_phone_number_d3cb4cff_like ON public.customer_provider USING btree (phone_number varchar_pattern_ops);


--
-- TOC entry 3910 (class 1259 OID 17047)
-- Name: customer_scheduledappointment_patient_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_scheduledappointment_patient_id ON public.customer_scheduledappointment USING btree (patient_id);


--
-- TOC entry 3913 (class 1259 OID 17048)
-- Name: customer_scheduledappointment_site_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_scheduledappointment_site_id ON public.customer_scheduledappointment USING btree (site_id);


--
-- TOC entry 3914 (class 1259 OID 17050)
-- Name: customer_site_owned_by_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_site_owned_by_id ON public.customer_site USING btree (owned_by_id);


--
-- TOC entry 3917 (class 1259 OID 17051)
-- Name: customer_usertocustomer_customer_ref_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_usertocustomer_customer_ref_id ON public.customer_usertocustomer USING btree (customer_ref_id);


--
-- TOC entry 3920 (class 1259 OID 17052)
-- Name: customer_usertocustomer_user_ref_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX customer_usertocustomer_user_ref_id ON public.customer_usertocustomer USING btree (user_ref_id);


--
-- TOC entry 3923 (class 1259 OID 17053)
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_admin_log_content_type_id ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3926 (class 1259 OID 17054)
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_admin_log_user_id ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3931 (class 1259 OID 17055)
-- Name: django_cron_cronjoblog_code; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_code ON public.django_cron_cronjoblog USING btree (code);


--
-- TOC entry 3932 (class 1259 OID 17056)
-- Name: django_cron_cronjoblog_code_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_code_like ON public.django_cron_cronjoblog USING btree (code varchar_pattern_ops);


--
-- TOC entry 3933 (class 1259 OID 17061)
-- Name: django_cron_cronjoblog_end_time; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_end_time ON public.django_cron_cronjoblog USING btree (end_time);


--
-- TOC entry 3936 (class 1259 OID 17064)
-- Name: django_cron_cronjoblog_ran_at_time; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_ran_at_time ON public.django_cron_cronjoblog USING btree (ran_at_time);


--
-- TOC entry 3937 (class 1259 OID 17065)
-- Name: django_cron_cronjoblog_ran_at_time_4837b3d19ce7f428; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_ran_at_time_4837b3d19ce7f428 ON public.django_cron_cronjoblog USING btree (ran_at_time, is_success, code);


--
-- TOC entry 3938 (class 1259 OID 17068)
-- Name: django_cron_cronjoblog_ran_at_time_56d8a829e896710; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_ran_at_time_56d8a829e896710 ON public.django_cron_cronjoblog USING btree (ran_at_time, start_time, code);


--
-- TOC entry 3939 (class 1259 OID 17069)
-- Name: django_cron_cronjoblog_start_time; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_start_time ON public.django_cron_cronjoblog USING btree (start_time);


--
-- TOC entry 3940 (class 1259 OID 17070)
-- Name: django_cron_cronjoblog_start_time_237e8ae3c61af4bf; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_cron_cronjoblog_start_time_237e8ae3c61af4bf ON public.django_cron_cronjoblog USING btree (start_time, code);


--
-- TOC entry 3941 (class 1259 OID 17071)
-- Name: django_session_expire_date; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_session_expire_date ON public.django_session USING btree (expire_date);


--
-- TOC entry 3944 (class 1259 OID 17073)
-- Name: django_session_session_key_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_session_session_key_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 3945 (class 1259 OID 723306)
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- TOC entry 4333 (class 1259 OID 806094)
-- Name: domain_adminasset_created_at_e17468c7; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_adminasset_created_at_e17468c7 ON public.domain_adminasset USING btree (created_at);


--
-- TOC entry 4096 (class 1259 OID 19300)
-- Name: domain_integration_file_tracking_customer_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_integration_file_tracking_customer_id ON public.domain_integration_file_tracking USING btree (customer_id);


--
-- TOC entry 3954 (class 1259 OID 17074)
-- Name: domain_onetimelink_unique_slug_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_onetimelink_unique_slug_like ON public.domain_onetimelink USING btree (unique_slug varchar_pattern_ops);


--
-- TOC entry 4131 (class 1259 OID 33711)
-- Name: domain_thirdpartyapiuser_name_73486b5aa3e83c95_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_thirdpartyapiuser_name_73486b5aa3e83c95_like ON public.domain_thirdpartyapiuser USING btree (name varchar_pattern_ops);


--
-- TOC entry 4092 (class 1259 OID 17812)
-- Name: domain_usersessionhistory_associated_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_usersessionhistory_associated_user_id ON public.domain_usersessionhistory USING btree (associated_user_id);


--
-- TOC entry 4095 (class 1259 OID 17813)
-- Name: domain_usersessionhistory_session_key; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX domain_usersessionhistory_session_key ON public.domain_usersessionhistory USING btree (session_key);


--
-- TOC entry 4495 (class 1259 OID 882951)
-- Name: immediate_heldvisit_at_4c3b0141; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_at_4c3b0141 ON public.immediate_heldvisit USING btree (at);


--
-- TOC entry 4496 (class 1259 OID 882947)
-- Name: immediate_heldvisit_created_at_d6ba0dfe; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_created_at_d6ba0dfe ON public.immediate_heldvisit USING btree (created_at);


--
-- TOC entry 4497 (class 1259 OID 882949)
-- Name: immediate_heldvisit_enrolled_at_3dbc6d87; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_enrolled_at_3dbc6d87 ON public.immediate_heldvisit USING btree (enrolled_at);


--
-- TOC entry 4498 (class 1259 OID 882948)
-- Name: immediate_heldvisit_hold_until_6a3c8d7b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_hold_until_6a3c8d7b ON public.immediate_heldvisit USING btree (hold_until);


--
-- TOC entry 4499 (class 1259 OID 882950)
-- Name: immediate_heldvisit_on_429afcb6; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_on_429afcb6 ON public.immediate_heldvisit USING btree ("on");


--
-- TOC entry 4500 (class 1259 OID 882952)
-- Name: immediate_heldvisit_phone_f370bde9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_phone_f370bde9 ON public.immediate_heldvisit USING btree (phone);


--
-- TOC entry 4501 (class 1259 OID 882953)
-- Name: immediate_heldvisit_phone_f370bde9_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_phone_f370bde9_like ON public.immediate_heldvisit USING btree (phone varchar_pattern_ops);


--
-- TOC entry 4504 (class 1259 OID 882954)
-- Name: immediate_heldvisit_schedule_id_241632bb; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_heldvisit_schedule_id_241632bb ON public.immediate_heldvisit USING btree (schedule_id);


--
-- TOC entry 4490 (class 1259 OID 882941)
-- Name: immediate_immediateschedule_created_at_b5ea84fa; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_immediateschedule_created_at_b5ea84fa ON public.immediate_immediateschedule USING btree (created_at);


--
-- TOC entry 4513 (class 1259 OID 965273)
-- Name: immediate_mappingkey_created_at_45719991; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_mappingkey_created_at_45719991 ON public.immediate_mappingkey USING btree (created_at);


--
-- TOC entry 4514 (class 1259 OID 965274)
-- Name: immediate_mappingkey_key_9acd176f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_mappingkey_key_9acd176f ON public.immediate_mappingkey USING btree (key);


--
-- TOC entry 4515 (class 1259 OID 965275)
-- Name: immediate_mappingkey_key_9acd176f_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_mappingkey_key_9acd176f_like ON public.immediate_mappingkey USING btree (key varchar_pattern_ops);


--
-- TOC entry 4518 (class 1259 OID 965276)
-- Name: immediate_mappingkey_schedule_id_3fe90175; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_mappingkey_schedule_id_3fe90175 ON public.immediate_mappingkey USING btree (schedule_id);


--
-- TOC entry 4521 (class 1259 OID 965311)
-- Name: immediate_whitelistedsite_created_at_38d62e33; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_whitelistedsite_created_at_38d62e33 ON public.immediate_whitelistedsite USING btree (created_at);


--
-- TOC entry 4524 (class 1259 OID 965312)
-- Name: immediate_whitelistedsite_schedule_id_5e255605; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX immediate_whitelistedsite_schedule_id_5e255605 ON public.immediate_whitelistedsite USING btree (schedule_id);


--
-- TOC entry 4236 (class 1259 OID 538794)
-- Name: mercury_conversation_9fcb9ff3; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_9fcb9ff3 ON public.mercury_conversation USING btree (interaction_id);


--
-- TOC entry 4237 (class 1259 OID 538806)
-- Name: mercury_conversation_d193b3fd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_d193b3fd ON public.mercury_conversation USING btree (phone_number_id);


--
-- TOC entry 4238 (class 1259 OID 538800)
-- Name: mercury_conversation_de96de99; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_de96de99 ON public.mercury_conversation USING btree (interaction_group_id);


--
-- TOC entry 4241 (class 1259 OID 813880)
-- Name: mercury_conversation_sent_from_20200506; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_sent_from_20200506 ON public.mercury_conversation USING btree (sent_from);


--
-- TOC entry 4242 (class 1259 OID 813881)
-- Name: mercury_conversation_sent_to_20200506; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_sent_to_20200506 ON public.mercury_conversation USING btree (sent_to);


--
-- TOC entry 4243 (class 1259 OID 813882)
-- Name: mercury_conversation_status_20200506; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_conversation_status_20200506 ON public.mercury_conversation USING btree (status);


--
-- TOC entry 4244 (class 1259 OID 538788)
-- Name: mercury_inboundmessage_d193b3fd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_inboundmessage_d193b3fd ON public.mercury_inboundmessage USING btree (phone_number_id);


--
-- TOC entry 4245 (class 1259 OID 538763)
-- Name: mercury_inboundmessage_d52ac232; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_inboundmessage_d52ac232 ON public.mercury_inboundmessage USING btree (conversation_id);


--
-- TOC entry 4248 (class 1259 OID 538782)
-- Name: mercury_interaction_de96de99; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_interaction_de96de99 ON public.mercury_interaction USING btree (interaction_group_id);


--
-- TOC entry 4251 (class 1259 OID 928510)
-- Name: mercury_interactiongroup_group_7aaf4a25_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_interactiongroup_group_7aaf4a25_like ON public.mercury_interactiongroup USING btree ("group" varchar_pattern_ops);


--
-- TOC entry 4256 (class 1259 OID 538776)
-- Name: mercury_outboundmessage_d193b3fd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_outboundmessage_d193b3fd ON public.mercury_outboundmessage USING btree (phone_number_id);


--
-- TOC entry 4257 (class 1259 OID 538769)
-- Name: mercury_outboundmessage_d52ac232; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_outboundmessage_d52ac232 ON public.mercury_outboundmessage USING btree (conversation_id);


--
-- TOC entry 4260 (class 1259 OID 813883)
-- Name: mercury_phonenumber_number_20200506; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_phonenumber_number_20200506 ON public.mercury_phonenumber USING btree (number);


--
-- TOC entry 4263 (class 1259 OID 538775)
-- Name: mercury_template_9fcb9ff3; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX mercury_template_9fcb9ff3 ON public.mercury_template USING btree (interaction_id);


--
-- TOC entry 4303 (class 1259 OID 804596)
-- Name: notices_autoresponse_created_at_c6a1c0cd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_autoresponse_created_at_c6a1c0cd ON public.notices_autoresponse USING btree (created_at);


--
-- TOC entry 4304 (class 1259 OID 804647)
-- Name: notices_autoresponse_envelope_id_314935ec; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_autoresponse_envelope_id_314935ec ON public.notices_autoresponse USING btree (envelope_id);


--
-- TOC entry 4309 (class 1259 OID 862736)
-- Name: notices_batch_completed_at_0af6881b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_completed_at_0af6881b ON public.notices_batch USING btree (completed_at);


--
-- TOC entry 4310 (class 1259 OID 804597)
-- Name: notices_batch_created_at_72b23525; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_created_at_72b23525 ON public.notices_batch USING btree (created_at);


--
-- TOC entry 4311 (class 1259 OID 804641)
-- Name: notices_batch_notice_id_3dac1471; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_notice_id_3dac1471 ON public.notices_batch USING btree (notice_id);


--
-- TOC entry 4314 (class 1259 OID 862737)
-- Name: notices_batch_prepared_at_6557692d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_prepared_at_6557692d ON public.notices_batch USING btree (prepared_at);


--
-- TOC entry 4315 (class 1259 OID 862739)
-- Name: notices_batch_send_at_2459b46d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_send_at_2459b46d ON public.notices_batch USING btree (send_at);


--
-- TOC entry 4316 (class 1259 OID 862738)
-- Name: notices_batch_sending_at_5de821d4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_batch_sending_at_5de821d4 ON public.notices_batch USING btree (sending_at);


--
-- TOC entry 4317 (class 1259 OID 804609)
-- Name: notices_envelope_batch_id_df3d8cb9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_batch_id_df3d8cb9 ON public.notices_envelope USING btree (batch_id);


--
-- TOC entry 4318 (class 1259 OID 804608)
-- Name: notices_envelope_created_at_538538b9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_created_at_538538b9 ON public.notices_envelope USING btree (created_at);


--
-- TOC entry 4321 (class 1259 OID 804617)
-- Name: notices_envelope_notice_id_2956b3a9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_notice_id_2956b3a9 ON public.notices_envelope USING btree (notice_id);


--
-- TOC entry 4324 (class 1259 OID 804623)
-- Name: notices_envelope_patient_id_d162b6e0; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_patient_id_d162b6e0 ON public.notices_envelope USING btree (patient_id);


--
-- TOC entry 4325 (class 1259 OID 804629)
-- Name: notices_envelope_phone_id_807040b4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_phone_id_807040b4 ON public.notices_envelope USING btree (phone_id);


--
-- TOC entry 4328 (class 1259 OID 804635)
-- Name: notices_envelope_visit_id_3d0801d9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_envelope_visit_id_3d0801d9 ON public.notices_envelope USING btree (visit_id);


--
-- TOC entry 4329 (class 1259 OID 804615)
-- Name: notices_notice_created_at_9cc766f9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_notice_created_at_9cc766f9 ON public.notices_notice USING btree (created_at);


--
-- TOC entry 4330 (class 1259 OID 804616)
-- Name: notices_notice_customer_id_4c72af35; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX notices_notice_customer_id_4c72af35 ON public.notices_notice USING btree (customer_id);


--
-- TOC entry 4216 (class 1259 OID 356592)
-- Name: nps_socialmediainterstitial_5eb92e7b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX nps_socialmediainterstitial_5eb92e7b ON public.nps_socialmediainterstitial USING btree (site_social_media_interstitial_page_id);


--
-- TOC entry 4217 (class 1259 OID 316002)
-- Name: nps_socialmediainterstitial_d193b3fd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX nps_socialmediainterstitial_d193b3fd ON public.nps_socialmediainterstitial USING btree (phone_number_id);


--
-- TOC entry 4218 (class 1259 OID 316001)
-- Name: nps_socialmediainterstitial_ef7c876f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX nps_socialmediainterstitial_ef7c876f ON public.nps_socialmediainterstitial USING btree (uuid);


--
-- TOC entry 4221 (class 1259 OID 316008)
-- Name: nps_visit_d53d32dc; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX nps_visit_d53d32dc ON public.nps_visit USING btree (social_media_interstitial_id);


--
-- TOC entry 3957 (class 1259 OID 17075)
-- Name: phone_number_belongs_to_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_belongs_to_id ON public.phone_number USING btree (belongs_to_id);


--
-- TOC entry 3958 (class 1259 OID 786196)
-- Name: phone_number_do_not_contact_af7b7c94; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_do_not_contact_af7b7c94 ON public.phone_number USING btree (do_not_contact);


--
-- TOC entry 3959 (class 1259 OID 23874)
-- Name: phone_number_last_four_1040f73e754e17c1_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_last_four_1040f73e754e17c1_like ON public.phone_number USING btree (last_four varchar_pattern_ops);


--
-- TOC entry 3960 (class 1259 OID 23873)
-- Name: phone_number_last_four_1040f73e754e17c1_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_last_four_1040f73e754e17c1_uniq ON public.phone_number USING btree (last_four);


--
-- TOC entry 3961 (class 1259 OID 17076)
-- Name: phone_number_last_treated_at_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_last_treated_at_id ON public.phone_number USING btree (last_treated_at_id);


--
-- TOC entry 3962 (class 1259 OID 17077)
-- Name: phone_number_last_treated_by_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_last_treated_by_id ON public.phone_number USING btree (last_treated_by_id);


--
-- TOC entry 3963 (class 1259 OID 596592)
-- Name: phone_number_phone_number_64c87b73adf78943_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_phone_number_64c87b73adf78943_like ON public.phone_number USING btree (phone_number varchar_pattern_ops);


--
-- TOC entry 3964 (class 1259 OID 596591)
-- Name: phone_number_phone_number_64c87b73adf78943_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_phone_number_64c87b73adf78943_uniq ON public.phone_number USING btree (phone_number);


--
-- TOC entry 3967 (class 1259 OID 786195)
-- Name: phone_number_wrong_number_36388676; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX phone_number_wrong_number_36388676 ON public.phone_number USING btree (wrong_number);


--
-- TOC entry 3968 (class 1259 OID 17078)
-- Name: reminders_reminder_is_set_for_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reminders_reminder_is_set_for_id ON public.reminders_reminder USING btree (is_set_for_id);


--
-- TOC entry 4485 (class 1259 OID 875425)
-- Name: reputation_actionthreshold_account_id_940b4daa; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_actionthreshold_account_id_940b4daa ON public.reputation_actionthreshold USING btree (account_id);


--
-- TOC entry 4486 (class 1259 OID 875426)
-- Name: reputation_actionthreshold_actor_id_dbf8c1c4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_actionthreshold_actor_id_dbf8c1c4 ON public.reputation_actionthreshold USING btree (actor_id);


--
-- TOC entry 4487 (class 1259 OID 875424)
-- Name: reputation_actionthreshold_created_at_7a03f6fe; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_actionthreshold_created_at_7a03f6fe ON public.reputation_actionthreshold USING btree (created_at);


--
-- TOC entry 4505 (class 1259 OID 923179)
-- Name: reputation_competitor_created_at_d0ba47f4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_competitor_created_at_d0ba47f4 ON public.reputation_competitor USING btree (created_at);


--
-- TOC entry 4506 (class 1259 OID 923180)
-- Name: reputation_competitor_location_id_81830260; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_competitor_location_id_81830260 ON public.reputation_competitor USING btree (location_id);


--
-- TOC entry 4511 (class 1259 OID 923193)
-- Name: reputation_competitor_place_id_e3b46c3d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_competitor_place_id_e3b46c3d ON public.reputation_competitor USING btree (place_id);


--
-- TOC entry 4512 (class 1259 OID 923194)
-- Name: reputation_competitor_place_id_e3b46c3d_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_competitor_place_id_e3b46c3d_like ON public.reputation_competitor USING btree (place_id varchar_pattern_ops);


--
-- TOC entry 4433 (class 1259 OID 851754)
-- Name: reputation_gmbaccount_created_at_11fad6ef; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbaccount_created_at_11fad6ef ON public.reputation_gmbaccount USING btree (created_at);


--
-- TOC entry 4434 (class 1259 OID 851755)
-- Name: reputation_gmbaccount_customer_id_affd292d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbaccount_customer_id_affd292d ON public.reputation_gmbaccount USING btree (customer_id);


--
-- TOC entry 4439 (class 1259 OID 851767)
-- Name: reputation_gmblocation_account_id_e9b5d7a5; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_account_id_e9b5d7a5 ON public.reputation_gmblocation USING btree (account_id);


--
-- TOC entry 4444 (class 1259 OID 851766)
-- Name: reputation_gmblocation_created_at_e568f77c; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_created_at_e568f77c ON public.reputation_gmblocation USING btree (created_at);


--
-- TOC entry 4445 (class 1259 OID 923197)
-- Name: reputation_gmblocation_keyword_b47649d0; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_keyword_b47649d0 ON public.reputation_gmblocation USING btree (keyword);


--
-- TOC entry 4446 (class 1259 OID 923198)
-- Name: reputation_gmblocation_keyword_b47649d0_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_keyword_b47649d0_like ON public.reputation_gmblocation USING btree (keyword varchar_pattern_ops);


--
-- TOC entry 4449 (class 1259 OID 923195)
-- Name: reputation_gmblocation_place_id_de65e0c6; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_place_id_de65e0c6 ON public.reputation_gmblocation USING btree (place_id);


--
-- TOC entry 4450 (class 1259 OID 923196)
-- Name: reputation_gmblocation_place_id_de65e0c6_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmblocation_place_id_de65e0c6_like ON public.reputation_gmblocation USING btree (place_id varchar_pattern_ops);


--
-- TOC entry 4466 (class 1259 OID 851797)
-- Name: reputation_gmbnotification_created_at_25978abf; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbnotification_created_at_25978abf ON public.reputation_gmbnotification USING btree (created_at);


--
-- TOC entry 4471 (class 1259 OID 851806)
-- Name: reputation_gmbnotifyee_created_at_98fa4c68; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbnotifyee_created_at_98fa4c68 ON public.reputation_gmbnotifyee USING btree (created_at);


--
-- TOC entry 4472 (class 1259 OID 851807)
-- Name: reputation_gmbnotifyee_customer_id_e0456300; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbnotifyee_customer_id_e0456300 ON public.reputation_gmbnotifyee USING btree (customer_id);


--
-- TOC entry 4461 (class 1259 OID 851789)
-- Name: reputation_gmbreplyaction_created_at_503749aa; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreplyaction_created_at_503749aa ON public.reputation_gmbreplyaction USING btree (created_at);


--
-- TOC entry 4464 (class 1259 OID 851790)
-- Name: reputation_gmbreplyaction_review_id_f5809238; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreplyaction_review_id_f5809238 ON public.reputation_gmbreplyaction USING btree (review_id);


--
-- TOC entry 4465 (class 1259 OID 851791)
-- Name: reputation_gmbreplyaction_user_id_6647aab6; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreplyaction_user_id_6647aab6 ON public.reputation_gmbreplyaction USING btree (user_id);


--
-- TOC entry 4453 (class 1259 OID 851775)
-- Name: reputation_gmbreview_created_at_7f353d5a; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreview_created_at_7f353d5a ON public.reputation_gmbreview USING btree (created_at);


--
-- TOC entry 4454 (class 1259 OID 851778)
-- Name: reputation_gmbreview_location_id_d4947fd8; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreview_location_id_d4947fd8 ON public.reputation_gmbreview USING btree (location_id);


--
-- TOC entry 4457 (class 1259 OID 851776)
-- Name: reputation_gmbreview_name_158d2baa; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreview_name_158d2baa ON public.reputation_gmbreview USING btree (name);


--
-- TOC entry 4458 (class 1259 OID 851777)
-- Name: reputation_gmbreview_name_158d2baa_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_gmbreview_name_158d2baa_like ON public.reputation_gmbreview USING btree (name varchar_pattern_ops);


--
-- TOC entry 4477 (class 1259 OID 875403)
-- Name: reputation_reviewticket_created_at_ae466933; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_reviewticket_created_at_ae466933 ON public.reputation_reviewticket USING btree (created_at);


--
-- TOC entry 4478 (class 1259 OID 875404)
-- Name: reputation_reviewticket_creator_id_2aa08418; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reputation_reviewticket_creator_id_2aa08418 ON public.reputation_reviewticket USING btree (creator_id);


--
-- TOC entry 4178 (class 1259 OID 814592)
-- Name: reviews_feed_uuid_c0bed21e; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reviews_feed_uuid_c0bed21e ON public.reviews_feed USING btree (uuid);


--
-- TOC entry 4179 (class 1259 OID 120272)
-- Name: reviews_review_c95a8e93; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX reviews_review_c95a8e93 ON public.reviews_review USING btree (feed_id);


--
-- TOC entry 3971 (class 1259 OID 17079)
-- Name: sms_callfilehistory_callfile_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_callfilehistory_callfile_id ON public.sms_callfilehistory USING btree (callfile_id);


--
-- TOC entry 3972 (class 1259 OID 17080)
-- Name: sms_callfilehistory_phone_number_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_callfilehistory_phone_number_id ON public.sms_callfilehistory USING btree (phone_number_id);


--
-- TOC entry 3975 (class 1259 OID 813885)
-- Name: sms_message_destination_20200428; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_destination_20200428 ON public.sms_message USING btree (destination);


--
-- TOC entry 3984 (class 1259 OID 17081)
-- Name: sms_message_incoming_from_number_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_incoming_from_number_id ON public.sms_message_incoming USING btree (from_number_id);


--
-- TOC entry 3987 (class 1259 OID 564535)
-- Name: sms_message_incoming_plivo_message_uuid_556282c01597769_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_incoming_plivo_message_uuid_556282c01597769_like ON public.sms_message_incoming USING btree (plivo_message_uuid varchar_pattern_ops);


--
-- TOC entry 3988 (class 1259 OID 564534)
-- Name: sms_message_incoming_plivo_message_uuid_556282c01597769_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_incoming_plivo_message_uuid_556282c01597769_uniq ON public.sms_message_incoming USING btree (plivo_message_uuid);


--
-- TOC entry 3989 (class 1259 OID 813972)
-- Name: sms_message_incoming_plivo_message_uuid_unique_20200430; Type: INDEX; Schema: public; Owner: aptible
--

CREATE UNIQUE INDEX sms_message_incoming_plivo_message_uuid_unique_20200430 ON public.sms_message_incoming USING btree (plivo_message_uuid);


--
-- TOC entry 3976 (class 1259 OID 17082)
-- Name: sms_message_intended_recipient_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_intended_recipient_id ON public.sms_message USING btree (intended_recipient_id);


--
-- TOC entry 3977 (class 1259 OID 564537)
-- Name: sms_message_likely_from_number_cad7a78ca661852_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_likely_from_number_cad7a78ca661852_like ON public.sms_message USING btree (likely_from_number varchar_pattern_ops);


--
-- TOC entry 3978 (class 1259 OID 564536)
-- Name: sms_message_likely_from_number_cad7a78ca661852_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_likely_from_number_cad7a78ca661852_uniq ON public.sms_message USING btree (likely_from_number);


--
-- TOC entry 3981 (class 1259 OID 538847)
-- Name: sms_message_plivo_message_uuid_71f05ef3d6c5263_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_plivo_message_uuid_71f05ef3d6c5263_like ON public.sms_message USING btree (plivo_message_uuid varchar_pattern_ops);


--
-- TOC entry 3982 (class 1259 OID 538844)
-- Name: sms_message_plivo_message_uuid_71f05ef3d6c5263_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_plivo_message_uuid_71f05ef3d6c5263_uniq ON public.sms_message USING btree (plivo_message_uuid);


--
-- TOC entry 3983 (class 1259 OID 813884)
-- Name: sms_message_status_20200428; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sms_message_status_20200428 ON public.sms_message USING btree (status);


--
-- TOC entry 3996 (class 1259 OID 17083)
-- Name: socialaccount_socialaccount_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX socialaccount_socialaccount_user_id ON public.socialaccount_socialaccount USING btree (user_id);


--
-- TOC entry 4003 (class 1259 OID 17084)
-- Name: socialaccount_socialapp_sites_site_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX socialaccount_socialapp_sites_site_id ON public.socialaccount_socialapp_sites USING btree (site_id);


--
-- TOC entry 4004 (class 1259 OID 17085)
-- Name: socialaccount_socialapp_sites_socialapp_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX socialaccount_socialapp_sites_socialapp_id ON public.socialaccount_socialapp_sites USING btree (socialapp_id);


--
-- TOC entry 4005 (class 1259 OID 17086)
-- Name: socialaccount_socialtoken_account_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX socialaccount_socialtoken_account_id ON public.socialaccount_socialtoken USING btree (account_id);


--
-- TOC entry 4006 (class 1259 OID 17087)
-- Name: socialaccount_socialtoken_app_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX socialaccount_socialtoken_app_id ON public.socialaccount_socialtoken USING btree (app_id);


--
-- TOC entry 4426 (class 1259 OID 846534)
-- Name: sources_customercode_created_at_8c4b9708; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_customercode_created_at_8c4b9708 ON public.sources_customercode USING btree (created_at);


--
-- TOC entry 4427 (class 1259 OID 846535)
-- Name: sources_customercode_customer_id_e8b1abe9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_customercode_customer_id_e8b1abe9 ON public.sources_customercode USING btree (customer_id);


--
-- TOC entry 4430 (class 1259 OID 846536)
-- Name: sources_customercode_source_id_04661968; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_customercode_source_id_04661968 ON public.sources_customercode USING btree (source_id);


--
-- TOC entry 4418 (class 1259 OID 846518)
-- Name: sources_internalasset_created_at_e2b00328; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalasset_created_at_e2b00328 ON public.sources_internalasset USING btree (created_at);


--
-- TOC entry 4419 (class 1259 OID 846519)
-- Name: sources_internalasset_name_97261be8; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalasset_name_97261be8 ON public.sources_internalasset USING btree (name);


--
-- TOC entry 4420 (class 1259 OID 846520)
-- Name: sources_internalasset_name_97261be8_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalasset_name_97261be8_like ON public.sources_internalasset USING btree (name varchar_pattern_ops);


--
-- TOC entry 4423 (class 1259 OID 846521)
-- Name: sources_internalasset_source_id_82df3e4d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalasset_source_id_82df3e4d ON public.sources_internalasset USING btree (source_id);


--
-- TOC entry 4409 (class 1259 OID 846502)
-- Name: sources_internalsource_created_at_e4487035; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalsource_created_at_e4487035 ON public.sources_internalsource USING btree (created_at);


--
-- TOC entry 4410 (class 1259 OID 850544)
-- Name: sources_internalsource_customer_id_e9d1be5a; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalsource_customer_id_e9d1be5a ON public.sources_internalsource USING btree (customer_id);


--
-- TOC entry 4411 (class 1259 OID 846503)
-- Name: sources_internalsource_organization_id_7fc9c900; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalsource_organization_id_7fc9c900 ON public.sources_internalsource USING btree (organization_id);


--
-- TOC entry 4414 (class 1259 OID 846509)
-- Name: sources_internalsourcecheck_created_at_e1283149; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalsourcecheck_created_at_e1283149 ON public.sources_internalsourcecheck USING btree (created_at);


--
-- TOC entry 4417 (class 1259 OID 846510)
-- Name: sources_internalsourcecheck_source_id_ba2f6908; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sources_internalsourcecheck_source_id_ba2f6908 ON public.sources_internalsourcecheck USING btree (source_id);


--
-- TOC entry 4281 (class 1259 OID 780086)
-- Name: sso_samlprovider_created_at_882cb56e; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sso_samlprovider_created_at_882cb56e ON public.sso_samlprovider USING btree (created_at);


--
-- TOC entry 4282 (class 1259 OID 780087)
-- Name: sso_samlprovider_organization_id_394c287f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX sso_samlprovider_organization_id_394c287f ON public.sso_samlprovider USING btree (organization_id);


--
-- TOC entry 4019 (class 1259 OID 17088)
-- Name: surveys_npsscorechange_initiating_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscorechange_initiating_user_id ON public.surveys_npsscorechange USING btree (initiating_user_id);


--
-- TOC entry 4022 (class 1259 OID 17089)
-- Name: surveys_npsscorechange_related_nps_survey_response_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscorechange_related_nps_survey_response_id ON public.surveys_npsscorechange USING btree (related_nps_survey_response_id);


--
-- TOC entry 4199 (class 1259 OID 207488)
-- Name: surveys_npsscoreremoval_32ca2ddc; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscoreremoval_32ca2ddc ON public.surveys_npsscoreremoval USING btree (provider_id);


--
-- TOC entry 4200 (class 1259 OID 207487)
-- Name: surveys_npsscoreremoval_a29f38b3; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscoreremoval_a29f38b3 ON public.surveys_npsscoreremoval USING btree (nps_survey_response_id);


--
-- TOC entry 4201 (class 1259 OID 207486)
-- Name: surveys_npsscoreremoval_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscoreremoval_cb24373b ON public.surveys_npsscoreremoval USING btree (customer_id);


--
-- TOC entry 4202 (class 1259 OID 207489)
-- Name: surveys_npsscoreremoval_e8701ad4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npsscoreremoval_e8701ad4 ON public.surveys_npsscoreremoval USING btree (user_id);


--
-- TOC entry 4023 (class 1259 OID 372479)
-- Name: surveys_npssurveyresponse_cb24373b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_npssurveyresponse_cb24373b ON public.surveys_npssurveyresponse USING btree (customer_id);


--
-- TOC entry 4028 (class 1259 OID 17090)
-- Name: surveys_survey_request_associated_patient_visit_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_associated_patient_visit_id ON public.surveys_survey_request USING btree (associated_patient_visit_id);


--
-- TOC entry 4029 (class 1259 OID 17091)
-- Name: surveys_survey_request_is_instance_of_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_is_instance_of_id ON public.surveys_survey_request USING btree (is_instance_of_id);


--
-- TOC entry 4030 (class 1259 OID 938551)
-- Name: surveys_survey_request_is_nps_request_20220120; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_is_nps_request_20220120 ON public.surveys_survey_request USING btree (is_nps_request);


--
-- TOC entry 4033 (class 1259 OID 17092)
-- Name: surveys_survey_request_sent_to_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_sent_to_id ON public.surveys_survey_request USING btree (sent_to_id);


--
-- TOC entry 4034 (class 1259 OID 17093)
-- Name: surveys_survey_request_unique_short_slug; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_unique_short_slug ON public.surveys_survey_request USING btree (unique_short_slug);


--
-- TOC entry 4037 (class 1259 OID 17094)
-- Name: surveys_survey_request_unique_short_slug_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_survey_request_unique_short_slug_like ON public.surveys_survey_request USING btree (unique_short_slug varchar_pattern_ops);


--
-- TOC entry 4040 (class 1259 OID 17095)
-- Name: surveys_surveyresponse_response_to_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX surveys_surveyresponse_response_to_id ON public.surveys_surveyresponse USING btree (response_to_id);


--
-- TOC entry 4402 (class 1259 OID 809924)
-- Name: teams_dm_created_at_8588d40c; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_dm_created_at_8588d40c ON public.teams_dm USING btree (created_at);


--
-- TOC entry 4403 (class 1259 OID 809925)
-- Name: teams_dm_member_id_cea0bfac; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_dm_member_id_cea0bfac ON public.teams_dm USING btree (member_id);


--
-- TOC entry 4408 (class 1259 OID 809926)
-- Name: teams_dm_sender_id_f7e8626f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_dm_sender_id_f7e8626f ON public.teams_dm USING btree (sender_id);


--
-- TOC entry 4336 (class 1259 OID 809509)
-- Name: teams_envelope_created_at_074ae604; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_envelope_created_at_074ae604 ON public.teams_envelope USING btree (created_at);


--
-- TOC entry 4337 (class 1259 OID 809614)
-- Name: teams_envelope_member_id_149dccac; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_envelope_member_id_149dccac ON public.teams_envelope USING btree (member_id);


--
-- TOC entry 4340 (class 1259 OID 809626)
-- Name: teams_envelope_notice_id_5da4821a; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_envelope_notice_id_5da4821a ON public.teams_envelope USING btree (notice_id);


--
-- TOC entry 4345 (class 1259 OID 809510)
-- Name: teams_member_created_at_902675ce; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_member_created_at_902675ce ON public.teams_member USING btree (created_at);


--
-- TOC entry 4350 (class 1259 OID 809608)
-- Name: teams_member_team_id_1860c414; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_member_team_id_1860c414 ON public.teams_member USING btree (team_id);


--
-- TOC entry 4353 (class 1259 OID 809511)
-- Name: teams_messagein_created_at_a5845f1a; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_created_at_a5845f1a ON public.teams_messagein USING btree (created_at);


--
-- TOC entry 4354 (class 1259 OID 809579)
-- Name: teams_messagein_cue_id_9f318c27; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_cue_id_9f318c27 ON public.teams_messagein USING btree (cue_id);


--
-- TOC entry 4355 (class 1259 OID 809514)
-- Name: teams_messagein_destination_ba8ffe97; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_destination_ba8ffe97 ON public.teams_messagein USING btree (destination);


--
-- TOC entry 4356 (class 1259 OID 809515)
-- Name: teams_messagein_destination_ba8ffe97_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_destination_ba8ffe97_like ON public.teams_messagein USING btree (destination varchar_pattern_ops);


--
-- TOC entry 4357 (class 1259 OID 809585)
-- Name: teams_messagein_member_id_bc87a75e; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_member_id_bc87a75e ON public.teams_messagein USING btree (member_id);


--
-- TOC entry 4362 (class 1259 OID 809512)
-- Name: teams_messagein_source_516a2410; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_source_516a2410 ON public.teams_messagein USING btree (source);


--
-- TOC entry 4363 (class 1259 OID 809513)
-- Name: teams_messagein_source_516a2410_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_source_516a2410_like ON public.teams_messagein USING btree (source varchar_pattern_ops);


--
-- TOC entry 4364 (class 1259 OID 809591)
-- Name: teams_messagein_source_phone_id_8c898b30; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messagein_source_phone_id_8c898b30 ON public.teams_messagein USING btree (source_phone_id);


--
-- TOC entry 4365 (class 1259 OID 809516)
-- Name: teams_messageout_created_at_b5f0b2db; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_created_at_b5f0b2db ON public.teams_messageout USING btree (created_at);


--
-- TOC entry 4366 (class 1259 OID 809519)
-- Name: teams_messageout_destination_f980645b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_destination_f980645b ON public.teams_messageout USING btree (destination);


--
-- TOC entry 4367 (class 1259 OID 809520)
-- Name: teams_messageout_destination_f980645b_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_destination_f980645b_like ON public.teams_messageout USING btree (destination varchar_pattern_ops);


--
-- TOC entry 4368 (class 1259 OID 809567)
-- Name: teams_messageout_destination_phone_id_a222925b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_destination_phone_id_a222925b ON public.teams_messageout USING btree (destination_phone_id);


--
-- TOC entry 4369 (class 1259 OID 809573)
-- Name: teams_messageout_member_id_3f9a072f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_member_id_3f9a072f ON public.teams_messageout USING btree (member_id);


--
-- TOC entry 4374 (class 1259 OID 809517)
-- Name: teams_messageout_source_1d1bf1d9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_source_1d1bf1d9 ON public.teams_messageout USING btree (source);


--
-- TOC entry 4375 (class 1259 OID 809518)
-- Name: teams_messageout_source_1d1bf1d9_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_messageout_source_1d1bf1d9_like ON public.teams_messageout USING btree (source varchar_pattern_ops);


--
-- TOC entry 4376 (class 1259 OID 809526)
-- Name: teams_notice_created_at_4809c0cd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_notice_created_at_4809c0cd ON public.teams_notice USING btree (created_at);


--
-- TOC entry 4379 (class 1259 OID 809527)
-- Name: teams_notice_sender_id_fe043af1; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_notice_sender_id_fe043af1 ON public.teams_notice USING btree (sender_id);


--
-- TOC entry 4380 (class 1259 OID 809561)
-- Name: teams_notice_team_id_3365ab20; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_notice_team_id_3365ab20 ON public.teams_notice USING btree (team_id);


--
-- TOC entry 4381 (class 1259 OID 809533)
-- Name: teams_phone_created_at_81be422e; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_phone_created_at_81be422e ON public.teams_phone USING btree (created_at);


--
-- TOC entry 4384 (class 1259 OID 809534)
-- Name: teams_phone_number_aefd2ebd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_phone_number_aefd2ebd ON public.teams_phone USING btree (number);


--
-- TOC entry 4385 (class 1259 OID 809535)
-- Name: teams_phone_number_aefd2ebd_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_phone_number_aefd2ebd_like ON public.teams_phone USING btree (number varchar_pattern_ops);


--
-- TOC entry 4388 (class 1259 OID 809555)
-- Name: teams_phone_team_id_95316d2b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_phone_team_id_95316d2b ON public.teams_phone USING btree (team_id);


--
-- TOC entry 4391 (class 1259 OID 809548)
-- Name: teams_receipt_authority_id_4af57010; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_receipt_authority_id_4af57010 ON public.teams_receipt USING btree (authority_id);


--
-- TOC entry 4392 (class 1259 OID 809547)
-- Name: teams_receipt_created_at_5b60d472; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_receipt_created_at_5b60d472 ON public.teams_receipt USING btree (created_at);


--
-- TOC entry 4397 (class 1259 OID 809554)
-- Name: teams_team_created_at_069fc37d; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX teams_team_created_at_069fc37d ON public.teams_team USING btree (created_at);


--
-- TOC entry 4041 (class 1259 OID 17096)
-- Name: ticket_adhoc_employee_created_by_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_adhoc_employee_created_by_id ON public.ticket_adhoc_employee USING btree (created_by_id);


--
-- TOC entry 4044 (class 1259 OID 17097)
-- Name: ticket_adhoc_employee_owned_by_cust_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_adhoc_employee_owned_by_cust_id ON public.ticket_adhoc_employee USING btree (owned_by_cust_id);


--
-- TOC entry 4047 (class 1259 OID 17098)
-- Name: ticket_category_customer_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_category_customer_id ON public.ticket_category USING btree (customer_id);


--
-- TOC entry 4050 (class 1259 OID 17099)
-- Name: ticket_category_slug; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_category_slug ON public.ticket_category USING btree (slug);


--
-- TOC entry 4051 (class 1259 OID 17100)
-- Name: ticket_category_slug_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_category_slug_like ON public.ticket_category USING btree (slug varchar_pattern_ops);


--
-- TOC entry 4110 (class 1259 OID 25221)
-- Name: ticket_customer_priority_293c9da9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_customer_priority_293c9da9 ON public.ticket_customer_cohort USING btree (cohort_ref_id);


--
-- TOC entry 4111 (class 1259 OID 25220)
-- Name: ticket_customer_priority_57733f8f; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_customer_priority_57733f8f ON public.ticket_customer_cohort USING btree (customer_ref_id);


--
-- TOC entry 4125 (class 1259 OID 33197)
-- Name: ticket_draftnote_649b92cd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_draftnote_649b92cd ON public.ticket_draftnote USING btree (ticket_id);


--
-- TOC entry 4126 (class 1259 OID 33198)
-- Name: ticket_draftnote_e8701ad4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_draftnote_e8701ad4 ON public.ticket_draftnote USING btree (user_id);


--
-- TOC entry 4052 (class 1259 OID 17101)
-- Name: ticket_employee_lookup_adhoc_employee_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_employee_lookup_adhoc_employee_id ON public.ticket_employee_lookup USING btree (adhoc_employee_id);


--
-- TOC entry 4053 (class 1259 OID 17102)
-- Name: ticket_employee_lookup_owned_by_ticket_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_employee_lookup_owned_by_ticket_id ON public.ticket_employee_lookup USING btree (owned_by_ticket_id);


--
-- TOC entry 4058 (class 1259 OID 17103)
-- Name: ticket_employee_lookup_system_provider_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_employee_lookup_system_provider_id ON public.ticket_employee_lookup USING btree (system_provider_id);


--
-- TOC entry 4059 (class 1259 OID 17104)
-- Name: ticket_employee_lookup_system_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_employee_lookup_system_user_id ON public.ticket_employee_lookup USING btree (system_user_id);


--
-- TOC entry 4121 (class 1259 OID 32802)
-- Name: ticket_note_649b92cd; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_note_649b92cd ON public.ticket_note USING btree (ticket_id);


--
-- TOC entry 4122 (class 1259 OID 32803)
-- Name: ticket_note_e8701ad4; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_note_e8701ad4 ON public.ticket_note USING btree (user_id);


--
-- TOC entry 4062 (class 1259 OID 17105)
-- Name: ticket_patient_ticket_related_patient_visit_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_patient_ticket_related_patient_visit_id ON public.ticket_patient_ticket USING btree (related_patient_visit_id);


--
-- TOC entry 4063 (class 1259 OID 17871)
-- Name: ticket_patient_ticket_type; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_patient_ticket_type ON public.ticket_patient_ticket USING btree (type);


--
-- TOC entry 4066 (class 1259 OID 17106)
-- Name: ticket_status_history_related_ticket_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_status_history_related_ticket_id ON public.ticket_status_history USING btree (related_ticket_id);


--
-- TOC entry 4067 (class 1259 OID 17107)
-- Name: ticket_status_history_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_status_history_user_id ON public.ticket_status_history USING btree (user_id);


--
-- TOC entry 4068 (class 1259 OID 17108)
-- Name: ticket_tag_category_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_tag_category_id ON public.ticket_tag USING btree (category_id);


--
-- TOC entry 4071 (class 1259 OID 17109)
-- Name: ticket_tag_slug; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_tag_slug ON public.ticket_tag USING btree (slug);


--
-- TOC entry 4072 (class 1259 OID 17110)
-- Name: ticket_tag_slug_like; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_tag_slug_like ON public.ticket_tag USING btree (slug varchar_pattern_ops);


--
-- TOC entry 4073 (class 1259 OID 25227)
-- Name: ticket_ticket_8fb0ef36; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_8fb0ef36 ON public.ticket_ticket USING btree (cohort_id);


--
-- TOC entry 4074 (class 1259 OID 238321)
-- Name: ticket_ticket_9f065c57; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_9f065c57 ON public.ticket_ticket USING btree (patient_id);


--
-- TOC entry 4075 (class 1259 OID 17111)
-- Name: ticket_ticket_content_type_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_content_type_id ON public.ticket_ticket USING btree (content_type_id);


--
-- TOC entry 4076 (class 1259 OID 879047)
-- Name: ticket_ticket_date_of_incident_20210408; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_date_of_incident_20210408 ON public.ticket_ticket USING btree (date_of_incident);


--
-- TOC entry 4077 (class 1259 OID 372485)
-- Name: ticket_ticket_object_id_11f8c4360a6e957_uniq; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_object_id_11f8c4360a6e957_uniq ON public.ticket_ticket USING btree (object_id);


--
-- TOC entry 4078 (class 1259 OID 17112)
-- Name: ticket_ticket_owner_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_owner_id ON public.ticket_ticket USING btree (owner_id);


--
-- TOC entry 4081 (class 1259 OID 17113)
-- Name: ticket_ticket_related_customer_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_related_customer_id ON public.ticket_ticket USING btree (related_customer_id);


--
-- TOC entry 4082 (class 1259 OID 17114)
-- Name: ticket_ticket_related_patient_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_related_patient_id ON public.ticket_ticket USING btree (phone_number_id);


--
-- TOC entry 4083 (class 1259 OID 17115)
-- Name: ticket_ticket_related_provider_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_related_provider_id ON public.ticket_ticket USING btree (related_provider_id);


--
-- TOC entry 4084 (class 1259 OID 17116)
-- Name: ticket_ticket_related_site_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_related_site_id ON public.ticket_ticket USING btree (related_site_id);


--
-- TOC entry 4085 (class 1259 OID 879048)
-- Name: ticket_ticket_status_20210408; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_status_20210408 ON public.ticket_ticket USING btree (status);


--
-- TOC entry 4086 (class 1259 OID 17117)
-- Name: ticket_ticket_tag_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX ticket_ticket_tag_id ON public.ticket_ticket USING btree (tag_id);


--
-- TOC entry 4089 (class 1259 OID 17118)
-- Name: user_meta_user_id; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX user_meta_user_id ON public.user_meta USING btree (user_id);


--
-- TOC entry 4285 (class 1259 OID 792834)
-- Name: whitelists_address_created_at_84a8e65b; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX whitelists_address_created_at_84a8e65b ON public.whitelists_address USING btree (created_at);


--
-- TOC entry 4288 (class 1259 OID 792841)
-- Name: whitelists_address_whitelist_id_dd14d9c9; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX whitelists_address_whitelist_id_dd14d9c9 ON public.whitelists_address USING btree (whitelist_id);


--
-- TOC entry 4291 (class 1259 OID 792840)
-- Name: whitelists_whitelist_created_at_9d61d025; Type: INDEX; Schema: public; Owner: aptible
--

CREATE INDEX whitelists_whitelist_created_at_9d61d025 ON public.whitelists_whitelist USING btree (created_at);


--
-- TOC entry 4656 (class 2606 OID 16670)
-- Name: surveys_commentcategorization D207d34b5ec39c8d96bd54bfbc0fba4a; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategorization
    ADD CONSTRAINT "D207d34b5ec39c8d96bd54bfbc0fba4a" FOREIGN KEY (survey_response_id) REFERENCES public.surveys_npssurveyresponse(surveyresponse_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4654 (class 2606 OID 16675)
-- Name: nps_socialmediainterstitial D20d22192e77be6aed2b6d650c07e708; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_socialmediainterstitial
    ADD CONSTRAINT "D20d22192e77be6aed2b6d650c07e708" FOREIGN KEY (site_social_media_interstitial_page_id) REFERENCES public.nps_sitesocialmediainterstitialpage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4658 (class 2606 OID 532186)
-- Name: surveys_commentcategory D25f207b599aa018fc6d9afdf2e0417e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commentcategory
    ADD CONSTRAINT "D25f207b599aa018fc6d9afdf2e0417e" FOREIGN KEY (survey_response_id) REFERENCES public.surveys_npssurveyresponse(surveyresponse_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4665 (class 2606 OID 538783)
-- Name: mercury_interaction D553256e3712df6d6f62d394f476df23; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_interaction
    ADD CONSTRAINT "D553256e3712df6d6f62d394f476df23" FOREIGN KEY (interaction_group_id) REFERENCES public.mercury_interactiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4659 (class 2606 OID 532191)
-- Name: surveys_commenttopic D6bf3a1f6ba04cfae7ab414c9e0820c6; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_commenttopic
    ADD CONSTRAINT "D6bf3a1f6ba04cfae7ab414c9e0820c6" FOREIGN KEY (survey_response_id) REFERENCES public.surveys_npssurveyresponse(surveyresponse_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4635 (class 2606 OID 16680)
-- Name: conversations_outboundmessage D75f81a3eeb778a3e3630aa1fda6c207; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_outboundmessage
    ADD CONSTRAINT "D75f81a3eeb778a3e3630aa1fda6c207" FOREIGN KEY (conversation_id) REFERENCES public.conversations_conversation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4630 (class 2606 OID 16685)
-- Name: conversations_conversation D8a835037c7b7b41d587aa59a53f9608; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversation
    ADD CONSTRAINT "D8a835037c7b7b41d587aa59a53f9608" FOREIGN KEY (conversation_type_id) REFERENCES public.conversations_conversationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4655 (class 2606 OID 16690)
-- Name: nps_visit D91ff79c1231e25ce72e7e27be65a1cc; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_visit
    ADD CONSTRAINT "D91ff79c1231e25ce72e7e27be65a1cc" FOREIGN KEY (social_media_interstitial_id) REFERENCES public.nps_socialmediainterstitial(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4637 (class 2606 OID 16695)
-- Name: conversations_conversationtype_templates D9a378966cb03bdc951ad344abf12834; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype_templates
    ADD CONSTRAINT "D9a378966cb03bdc951ad344abf12834" FOREIGN KEY (conversationtype_id) REFERENCES public.conversations_conversationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4651 (class 2606 OID 16700)
-- Name: surveys_npsscoreremoval D9d0699b4ad68e78f6c90b661948f654; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval
    ADD CONSTRAINT "D9d0699b4ad68e78f6c90b661948f654" FOREIGN KEY (nps_survey_response_id) REFERENCES public.surveys_npssurveyresponse(surveyresponse_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4661 (class 2606 OID 538801)
-- Name: mercury_conversation D9fa7497cda27ebcdedb1822b875f3ed; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_conversation
    ADD CONSTRAINT "D9fa7497cda27ebcdedb1822b875f3ed" FOREIGN KEY (interaction_group_id) REFERENCES public.mercury_interactiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4633 (class 2606 OID 16705)
-- Name: conversations_inboundmessage a210bd0b103d6052cac97cc9cdfeb0ec; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_inboundmessage
    ADD CONSTRAINT a210bd0b103d6052cac97cc9cdfeb0ec FOREIGN KEY (conversation_id) REFERENCES public.conversations_conversation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4584 (class 2606 OID 16710)
-- Name: socialaccount_socialtoken account_id_refs_id_1337a128; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT account_id_refs_id_1337a128 FOREIGN KEY (account_id) REFERENCES public.socialaccount_socialaccount(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4599 (class 2606 OID 16715)
-- Name: ticket_employee_lookup adhoc_employee_id_refs_id_cfef485f; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT adhoc_employee_id_refs_id_cfef485f FOREIGN KEY (adhoc_employee_id) REFERENCES public.ticket_adhoc_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4647 (class 2606 OID 16720)
-- Name: analytics_socialmediareviewrequest anal_outgoing_sms_message_id_71aaf5ef71f28c13_fk_sms_message_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT anal_outgoing_sms_message_id_71aaf5ef71f28c13_fk_sms_message_id FOREIGN KEY (outgoing_sms_message_id) REFERENCES public.sms_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4646 (class 2606 OID 16725)
-- Name: analytics_socialmediareviewrequest analytics__customer_id_2729eaa59bafb091_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT analytics__customer_id_2729eaa59bafb091_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4645 (class 2606 OID 16730)
-- Name: analytics_socialmediareviewrequest analytics__provider_id_5a277f61452543b6_fk_customer_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT analytics__provider_id_5a277f61452543b6_fk_customer_provider_id FOREIGN KEY (provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4644 (class 2606 OID 16735)
-- Name: analytics_socialmediareviewrequest analytics_s_phone_number_id_6f3089d8220999f9_fk_phone_number_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT analytics_s_phone_number_id_6f3089d8220999f9_fk_phone_number_id FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4669 (class 2606 OID 551885)
-- Name: analytics_siteengagement analytics_siteenga_site_id_22b134259fcb7744_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_siteengagement
    ADD CONSTRAINT analytics_siteenga_site_id_22b134259fcb7744_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4643 (class 2606 OID 16740)
-- Name: analytics_socialmediareviewrequest analytics_socialmed_site_id_bebb2c78abc69f0_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT analytics_socialmed_site_id_bebb2c78abc69f0_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4583 (class 2606 OID 16745)
-- Name: socialaccount_socialtoken app_id_refs_id_edac8a54; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT app_id_refs_id_edac8a54 FOREIGN KEY (app_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4591 (class 2606 OID 16750)
-- Name: surveys_survey_request associated_patient_visit_id_refs_id_788068a5; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request
    ADD CONSTRAINT associated_patient_visit_id_refs_id_788068a5 FOREIGN KEY (associated_patient_visit_id) REFERENCES public.customer_patientvisithistory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4615 (class 2606 OID 16755)
-- Name: domain_usersessionhistory associated_user_id_refs_id_1315eb56; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_usersessionhistory
    ADD CONSTRAINT associated_user_id_refs_id_1315eb56 FOREIGN KEY (associated_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4547 (class 2606 OID 16760)
-- Name: auth_group_permissions auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4550 (class 2606 OID 16765)
-- Name: auth_user_groups auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4552 (class 2606 OID 16770)
-- Name: auth_user_user_permissions auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4642 (class 2606 OID 16775)
-- Name: analytics_socialmediareviewrequest b98aee1cc2b3d009cfa9c336e01e8505; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_socialmediareviewrequest
    ADD CONSTRAINT b98aee1cc2b3d009cfa9c336e01e8505 FOREIGN KEY (patient_visit_id) REFERENCES public.customer_patientvisithistory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4574 (class 2606 OID 16780)
-- Name: phone_number belongs_to_id_refs_id_46b08de1; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT belongs_to_id_refs_id_46b08de1 FOREIGN KEY (belongs_to_id) REFERENCES public.callfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4553 (class 2606 OID 16785)
-- Name: callfile belongs_to_id_refs_id_47a2a4b1; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile
    ADD CONSTRAINT belongs_to_id_refs_id_47a2a4b1 FOREIGN KEY (belongs_to_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4641 (class 2606 OID 16790)
-- Name: reviews_review bf98f90c952423bd91f74f870f8bc5c5; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_review
    ADD CONSTRAINT bf98f90c952423bd91f74f870f8bc5c5 FOREIGN KEY (ticket_id) REFERENCES public.ticket_patient_ticket(ticket_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4555 (class 2606 OID 16795)
-- Name: callfile_customer ca_organization_id_46ff0db33d4f14ff_fk_customer_organization_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_customer
    ADD CONSTRAINT ca_organization_id_46ff0db33d4f14ff_fk_customer_organization_id FOREIGN KEY (organization_id) REFERENCES public.customer_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4554 (class 2606 OID 928512)
-- Name: callfile_customer callfile_customer_default_interaction__7e8bbd90_fk_mercury_i; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.callfile_customer
    ADD CONSTRAINT callfile_customer_default_interaction__7e8bbd90_fk_mercury_i FOREIGN KEY (default_interaction_group_id) REFERENCES public.mercury_interactiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4577 (class 2606 OID 16800)
-- Name: sms_callfilehistory callfile_id_refs_id_a8291967; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_callfilehistory
    ADD CONSTRAINT callfile_id_refs_id_a8291967 FOREIGN KEY (callfile_id) REFERENCES public.callfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4604 (class 2606 OID 16805)
-- Name: ticket_tag category_id_refs_id_c162e30e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_tag
    ADD CONSTRAINT category_id_refs_id_c162e30e FOREIGN KEY (category_id) REFERENCES public.ticket_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4571 (class 2606 OID 16810)
-- Name: django_admin_log content_type_id_refs_id_93d2d1f8; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT content_type_id_refs_id_93d2d1f8 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4548 (class 2606 OID 16815)
-- Name: auth_permission content_type_id_refs_id_d043b34a; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT content_type_id_refs_id_d043b34a FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4636 (class 2606 OID 16825)
-- Name: conversations_conversationtype_templates conver_template_id_4e72a67015aaf42_fk_conversations_template_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype_templates
    ADD CONSTRAINT conver_template_id_4e72a67015aaf42_fk_conversations_template_id FOREIGN KEY (template_id) REFERENCES public.conversations_template(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4632 (class 2606 OID 16830)
-- Name: conversations_inboundmessage convers_contact_id_35a9a9116f45e242_fk_conversations_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_inboundmessage
    ADD CONSTRAINT convers_contact_id_35a9a9116f45e242_fk_conversations_contact_id FOREIGN KEY (contact_id) REFERENCES public.conversations_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4629 (class 2606 OID 16835)
-- Name: conversations_conversation convers_contact_id_5213d57205bfc185_fk_conversations_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversation
    ADD CONSTRAINT convers_contact_id_5213d57205bfc185_fk_conversations_contact_id FOREIGN KEY (contact_id) REFERENCES public.conversations_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4634 (class 2606 OID 16840)
-- Name: conversations_outboundmessage convers_contact_id_56996c54c8621d58_fk_conversations_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_outboundmessage
    ADD CONSTRAINT convers_contact_id_56996c54c8621d58_fk_conversations_contact_id FOREIGN KEY (contact_id) REFERENCES public.conversations_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4628 (class 2606 OID 16845)
-- Name: conversations_conversation conversati_customer_id_30858711202cbbe6_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversation
    ADD CONSTRAINT conversati_customer_id_30858711202cbbe6_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4638 (class 2606 OID 16850)
-- Name: conversations_optin conversati_customer_id_6d21ed226f460c12_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_optin
    ADD CONSTRAINT conversati_customer_id_6d21ed226f460c12_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4627 (class 2606 OID 16855)
-- Name: conversations_contact conversati_customer_id_6ea0a21510eb8f82_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_contact
    ADD CONSTRAINT conversati_customer_id_6ea0a21510eb8f82_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4631 (class 2606 OID 16860)
-- Name: conversations_conversationtype conversati_customer_id_7fb2495f9edd6b0a_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_conversationtype
    ADD CONSTRAINT conversati_customer_id_7fb2495f9edd6b0a_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4626 (class 2606 OID 16865)
-- Name: conversations_contact conversations_cont_site_id_4536030ec78163af_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.conversations_contact
    ADD CONSTRAINT conversations_cont_site_id_4536030ec78163af_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4594 (class 2606 OID 16870)
-- Name: ticket_adhoc_employee created_by_id_refs_id_1fe725c5; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_adhoc_employee
    ADD CONSTRAINT created_by_id_refs_id_1fe725c5 FOREIGN KEY (created_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4558 (class 2606 OID 16875)
-- Name: customer_patientoptout created_by_id_refs_id_79bc547c; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptout
    ADD CONSTRAINT created_by_id_refs_id_79bc547c FOREIGN KEY (created_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4621 (class 2606 OID 16880)
-- Name: customer_mergedentityhistory cu_related_customer_id_10666459677c72ec_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_mergedentityhistory
    ADD CONSTRAINT cu_related_customer_id_10666459677c72ec_fk_callfile_customer_id FOREIGN KEY (related_customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4562 (class 2606 OID 16885)
-- Name: customer_patientvisithistory cust_related_patient_id_6b44501123fcb785_fk_customer_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory
    ADD CONSTRAINT cust_related_patient_id_6b44501123fcb785_fk_customer_patient_id FOREIGN KEY (related_patient_id) REFERENCES public.customer_patient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4617 (class 2606 OID 16890)
-- Name: customer_comment_agg custo_comment_owner_id_198bb98c8ca13d24_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_comment_agg
    ADD CONSTRAINT custo_comment_owner_id_198bb98c8ca13d24_fk_callfile_customer_id FOREIGN KEY (comment_owner_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4557 (class 2606 OID 16895)
-- Name: customer_patientoptin customer_id_refs_id_27a52c9d; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptin
    ADD CONSTRAINT customer_id_refs_id_27a52c9d FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4595 (class 2606 OID 16900)
-- Name: ticket_category customer_id_refs_id_4e0a580b; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_category
    ADD CONSTRAINT customer_id_refs_id_4e0a580b FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4616 (class 2606 OID 16905)
-- Name: domain_integration_file_tracking customer_id_refs_id_a0810c55; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.domain_integration_file_tracking
    ADD CONSTRAINT customer_id_refs_id_a0810c55 FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4673 (class 2606 OID 802600)
-- Name: customer_legacyidentifier customer_legacyident_patient_id_99d33242_fk_customer_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_legacyidentifier
    ADD CONSTRAINT customer_legacyident_patient_id_99d33242_fk_customer_ FOREIGN KEY (patient_id) REFERENCES public.customer_patient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4618 (class 2606 OID 16910)
-- Name: customer_linkclicktracking customer_linkc_for_site_id_64e6ca1ac8d35833_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_linkclicktracking
    ADD CONSTRAINT customer_linkc_for_site_id_64e6ca1ac8d35833_fk_customer_site_id FOREIGN KEY (for_site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4652 (class 2606 OID 16915)
-- Name: customer_patient customer_p_customer_id_23351eeceead8c6c_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patient
    ADD CONSTRAINT customer_p_customer_id_23351eeceead8c6c_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4561 (class 2606 OID 16920)
-- Name: customer_patientvisithistory customer_pa_phone_number_id_63ff2216c398b3ad_fk_phone_number_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory
    ADD CONSTRAINT customer_pa_phone_number_id_63ff2216c398b3ad_fk_phone_number_id FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4564 (class 2606 OID 809403)
-- Name: customer_provider customer_provider_employed_by_id_5513feed_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_provider
    ADD CONSTRAINT customer_provider_employed_by_id_5513feed_fk_callfile_ FOREIGN KEY (employed_by_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4569 (class 2606 OID 16925)
-- Name: customer_usertocustomer customer_ref_id_refs_id_0b95d9b7; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_usertocustomer
    ADD CONSTRAINT customer_ref_id_refs_id_0b95d9b7 FOREIGN KEY (customer_ref_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4542 (class 2606 OID 16930)
-- Name: account_emailconfirmation email_address_id_refs_id_6ea1eea3; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT email_address_id_refs_id_6ea1eea3 FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4579 (class 2606 OID 16940)
-- Name: sms_message_incoming from_number_id_refs_id_2fb7f323; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message_incoming
    ADD CONSTRAINT from_number_id_refs_id_2fb7f323 FOREIGN KEY (from_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4546 (class 2606 OID 16945)
-- Name: auth_group_permissions group_id_refs_id_f4b32aac; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_f4b32aac FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4724 (class 2606 OID 965284)
-- Name: immediate_heldvisit immediate_heldvisit_schedule_id_241632bb_fk_immediate; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_heldvisit
    ADD CONSTRAINT immediate_heldvisit_schedule_id_241632bb_fk_immediate FOREIGN KEY (schedule_id) REFERENCES public.immediate_immediateschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4723 (class 2606 OID 882936)
-- Name: immediate_immediateschedule immediate_immediates_customer_id_9dfa9f77_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_immediateschedule
    ADD CONSTRAINT immediate_immediates_customer_id_9dfa9f77_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4726 (class 2606 OID 965261)
-- Name: immediate_mappingkey immediate_mappingkey_schedule_id_3fe90175_fk_immediate; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_mappingkey
    ADD CONSTRAINT immediate_mappingkey_schedule_id_3fe90175_fk_immediate FOREIGN KEY (schedule_id) REFERENCES public.immediate_immediateschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4727 (class 2606 OID 965304)
-- Name: immediate_whitelistedsite immediate_whiteliste_schedule_id_5e255605_fk_immediate; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.immediate_whitelistedsite
    ADD CONSTRAINT immediate_whiteliste_schedule_id_5e255605_fk_immediate FOREIGN KEY (schedule_id) REFERENCES public.immediate_immediateschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4586 (class 2606 OID 16950)
-- Name: surveys_npsscorechange initiating_user_id_refs_id_b427498f; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscorechange
    ADD CONSTRAINT initiating_user_id_refs_id_b427498f FOREIGN KEY (initiating_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4578 (class 2606 OID 16955)
-- Name: sms_message intended_recipient_id_refs_id_e809e9bb; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_message
    ADD CONSTRAINT intended_recipient_id_refs_id_e809e9bb FOREIGN KEY (intended_recipient_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4590 (class 2606 OID 16960)
-- Name: surveys_survey_request is_instance_of_id_refs_id_879769dd; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request
    ADD CONSTRAINT is_instance_of_id_refs_id_879769dd FOREIGN KEY (is_instance_of_id) REFERENCES public.surveys_survey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4575 (class 2606 OID 16965)
-- Name: reminders_reminder is_set_for_id_refs_id_1fcb8f26; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reminders_reminder
    ADD CONSTRAINT is_set_for_id_refs_id_1fcb8f26 FOREIGN KEY (is_set_for_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4573 (class 2606 OID 16970)
-- Name: phone_number last_treated_at_id_refs_id_11cf2748; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT last_treated_at_id_refs_id_11cf2748 FOREIGN KEY (last_treated_at_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4572 (class 2606 OID 16975)
-- Name: phone_number last_treated_by_id_refs_id_8d77e7a6; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT last_treated_by_id_refs_id_8d77e7a6 FOREIGN KEY (last_treated_by_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4556 (class 2606 OID 16980)
-- Name: customer_patientoptin logged_in_user_id_refs_id_fed58833; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientoptin
    ADD CONSTRAINT logged_in_user_id_refs_id_fed58833 FOREIGN KEY (logged_in_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4664 (class 2606 OID 538758)
-- Name: mercury_inboundmessage mer_conversation_id_141f637f7a634671_fk_mercury_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_inboundmessage
    ADD CONSTRAINT mer_conversation_id_141f637f7a634671_fk_mercury_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.mercury_conversation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4667 (class 2606 OID 538764)
-- Name: mercury_outboundmessage mer_conversation_id_382500e15a6c5269_fk_mercury_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_outboundmessage
    ADD CONSTRAINT mer_conversation_id_382500e15a6c5269_fk_mercury_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.mercury_conversation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4666 (class 2606 OID 538777)
-- Name: mercury_outboundmessage merc_phone_number_id_1d0c4cb287a0514a_fk_mercury_phonenumber_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_outboundmessage
    ADD CONSTRAINT merc_phone_number_id_1d0c4cb287a0514a_fk_mercury_phonenumber_id FOREIGN KEY (phone_number_id) REFERENCES public.mercury_phonenumber(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4663 (class 2606 OID 538789)
-- Name: mercury_inboundmessage merc_phone_number_id_69833f400d07c042_fk_mercury_phonenumber_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_inboundmessage
    ADD CONSTRAINT merc_phone_number_id_69833f400d07c042_fk_mercury_phonenumber_id FOREIGN KEY (phone_number_id) REFERENCES public.mercury_phonenumber(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4668 (class 2606 OID 538770)
-- Name: mercury_template mercu_interaction_id_38197d62684a5337_fk_mercury_interaction_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_template
    ADD CONSTRAINT mercu_interaction_id_38197d62684a5337_fk_mercury_interaction_id FOREIGN KEY (interaction_id) REFERENCES public.mercury_interaction(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4662 (class 2606 OID 538795)
-- Name: mercury_conversation mercu_interaction_id_65d389b877befd0e_fk_mercury_interaction_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_conversation
    ADD CONSTRAINT mercu_interaction_id_65d389b877befd0e_fk_mercury_interaction_id FOREIGN KEY (interaction_id) REFERENCES public.mercury_interaction(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4660 (class 2606 OID 538807)
-- Name: mercury_conversation mercu_phone_number_id_db0c81ee65349e5_fk_mercury_phonenumber_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.mercury_conversation
    ADD CONSTRAINT mercu_phone_number_id_db0c81ee65349e5_fk_mercury_phonenumber_id FOREIGN KEY (phone_number_id) REFERENCES public.mercury_phonenumber(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4675 (class 2606 OID 804648)
-- Name: notices_autoresponse notices_autoresponse_envelope_id_314935ec_fk_notices_e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_autoresponse
    ADD CONSTRAINT notices_autoresponse_envelope_id_314935ec_fk_notices_e FOREIGN KEY (envelope_id) REFERENCES public.notices_envelope(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4674 (class 2606 OID 804653)
-- Name: notices_autoresponse notices_autoresponse_message_id_6fa12f00_fk_sms_message_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_autoresponse
    ADD CONSTRAINT notices_autoresponse_message_id_6fa12f00_fk_sms_message_id FOREIGN KEY (message_id) REFERENCES public.sms_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4676 (class 2606 OID 804642)
-- Name: notices_batch notices_batch_notice_id_3dac1471_fk_notices_notice_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_batch
    ADD CONSTRAINT notices_batch_notice_id_3dac1471_fk_notices_notice_id FOREIGN KEY (notice_id) REFERENCES public.notices_notice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4682 (class 2606 OID 804598)
-- Name: notices_envelope notices_envelope_batch_id_df3d8cb9_fk_notices_batch_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_batch_id_df3d8cb9_fk_notices_batch_id FOREIGN KEY (batch_id) REFERENCES public.notices_batch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4681 (class 2606 OID 804603)
-- Name: notices_envelope notices_envelope_message_id_d78210aa_fk_sms_message_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_message_id_d78210aa_fk_sms_message_id FOREIGN KEY (message_id) REFERENCES public.sms_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4680 (class 2606 OID 804618)
-- Name: notices_envelope notices_envelope_notice_id_2956b3a9_fk_notices_notice_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_notice_id_2956b3a9_fk_notices_notice_id FOREIGN KEY (notice_id) REFERENCES public.notices_notice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4679 (class 2606 OID 804624)
-- Name: notices_envelope notices_envelope_patient_id_d162b6e0_fk_customer_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_patient_id_d162b6e0_fk_customer_patient_id FOREIGN KEY (patient_id) REFERENCES public.customer_patient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4678 (class 2606 OID 804630)
-- Name: notices_envelope notices_envelope_phone_id_807040b4_fk_phone_number_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_phone_id_807040b4_fk_phone_number_id FOREIGN KEY (phone_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4677 (class 2606 OID 804636)
-- Name: notices_envelope notices_envelope_visit_id_3d0801d9_fk_customer_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_envelope
    ADD CONSTRAINT notices_envelope_visit_id_3d0801d9_fk_customer_ FOREIGN KEY (visit_id) REFERENCES public.customer_patientvisithistory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4683 (class 2606 OID 804610)
-- Name: notices_notice notices_notice_customer_id_4c72af35_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.notices_notice
    ADD CONSTRAINT notices_notice_customer_id_4c72af35_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4657 (class 2606 OID 16985)
-- Name: nps_sitesocialmediainterstitialpage nps_sitesocialmedi_site_id_54f9551c660bfadd_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_sitesocialmediainterstitialpage
    ADD CONSTRAINT nps_sitesocialmedi_site_id_54f9551c660bfadd_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4653 (class 2606 OID 16990)
-- Name: nps_socialmediainterstitial nps_socialme_phone_number_id_516b52e9bf1be2c_fk_phone_number_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.nps_socialmediainterstitial
    ADD CONSTRAINT nps_socialme_phone_number_id_516b52e9bf1be2c_fk_phone_number_id FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4593 (class 2606 OID 16995)
-- Name: ticket_adhoc_employee owned_by_cust_id_refs_id_3b7ee85c; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_adhoc_employee
    ADD CONSTRAINT owned_by_cust_id_refs_id_3b7ee85c FOREIGN KEY (owned_by_cust_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4567 (class 2606 OID 17000)
-- Name: customer_site owned_by_id_refs_id_402ed8cc; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_site
    ADD CONSTRAINT owned_by_id_refs_id_402ed8cc FOREIGN KEY (owned_by_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4598 (class 2606 OID 17005)
-- Name: ticket_employee_lookup owned_by_ticket_id_refs_id_a3071841; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT owned_by_ticket_id_refs_id_a3071841 FOREIGN KEY (owned_by_ticket_id) REFERENCES public.ticket_ticket(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4613 (class 2606 OID 17010)
-- Name: ticket_ticket owner_id_refs_id_a30488b0; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT owner_id_refs_id_a30488b0 FOREIGN KEY (owner_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4566 (class 2606 OID 17015)
-- Name: customer_scheduledappointment patient_id_refs_id_de051fdc; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_scheduledappointment
    ADD CONSTRAINT patient_id_refs_id_de051fdc FOREIGN KEY (patient_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4576 (class 2606 OID 17020)
-- Name: sms_callfilehistory phone_number_id_refs_id_b9e48e16; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sms_callfilehistory
    ADD CONSTRAINT phone_number_id_refs_id_b9e48e16 FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4563 (class 2606 OID 17025)
-- Name: customer_phonenumbermismatch phone_number_id_refs_id_d30a12be; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_phonenumbermismatch
    ADD CONSTRAINT phone_number_id_refs_id_d30a12be FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4545 (class 2606 OID 17030)
-- Name: analytics_providerengagement provider_id_refs_id_4b03c0ba; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.analytics_providerengagement
    ADD CONSTRAINT provider_id_refs_id_4b03c0ba FOREIGN KEY (provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4560 (class 2606 OID 17035)
-- Name: customer_patientvisithistory provider_id_refs_id_99ccb892; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory
    ADD CONSTRAINT provider_id_refs_id_99ccb892 FOREIGN KEY (provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4612 (class 2606 OID 17040)
-- Name: ticket_ticket related_customer_id_refs_id_5a074712; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT related_customer_id_refs_id_5a074712 FOREIGN KEY (related_customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4585 (class 2606 OID 17045)
-- Name: surveys_npsscorechange related_nps_survey_response_id_refs_surveyresponse_ptr_id_17e92; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscorechange
    ADD CONSTRAINT related_nps_survey_response_id_refs_surveyresponse_ptr_id_17e92 FOREIGN KEY (related_nps_survey_response_id) REFERENCES public.surveys_npssurveyresponse(surveyresponse_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4601 (class 2606 OID 17050)
-- Name: ticket_patient_ticket related_patient_visit_id_refs_id_b31fde85; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_patient_ticket
    ADD CONSTRAINT related_patient_visit_id_refs_id_b31fde85 FOREIGN KEY (related_patient_visit_id) REFERENCES public.customer_patientvisithistory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4611 (class 2606 OID 17055)
-- Name: ticket_ticket related_provider_id_refs_id_dd39f990; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT related_provider_id_refs_id_dd39f990 FOREIGN KEY (related_provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4610 (class 2606 OID 17060)
-- Name: ticket_ticket related_site_id_refs_id_7673b3a5; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT related_site_id_refs_id_7673b3a5 FOREIGN KEY (related_site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4603 (class 2606 OID 17065)
-- Name: ticket_status_history related_ticket_id_refs_id_50b67a65; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_status_history
    ADD CONSTRAINT related_ticket_id_refs_id_50b67a65 FOREIGN KEY (related_ticket_id) REFERENCES public.ticket_ticket(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4722 (class 2606 OID 875414)
-- Name: reputation_actionthreshold reputation_actionthr_account_id_940b4daa_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_actionthreshold
    ADD CONSTRAINT reputation_actionthr_account_id_940b4daa_fk_reputatio FOREIGN KEY (account_id) REFERENCES public.reputation_gmbaccount(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4721 (class 2606 OID 875419)
-- Name: reputation_actionthreshold reputation_actionthreshold_actor_id_dbf8c1c4_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_actionthreshold
    ADD CONSTRAINT reputation_actionthreshold_actor_id_dbf8c1c4_fk_auth_user_id FOREIGN KEY (actor_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4725 (class 2606 OID 923174)
-- Name: reputation_competitor reputation_competito_location_id_81830260_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_competitor
    ADD CONSTRAINT reputation_competito_location_id_81830260_fk_reputatio FOREIGN KEY (location_id) REFERENCES public.reputation_gmblocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4710 (class 2606 OID 851747)
-- Name: reputation_gmbaccount reputation_gmbaccoun_customer_id_affd292d_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbaccount
    ADD CONSTRAINT reputation_gmbaccoun_customer_id_affd292d_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4712 (class 2606 OID 851756)
-- Name: reputation_gmblocation reputation_gmblocati_account_id_e9b5d7a5_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocati_account_id_e9b5d7a5_fk_reputatio FOREIGN KEY (account_id) REFERENCES public.reputation_gmbaccount(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4711 (class 2606 OID 851761)
-- Name: reputation_gmblocation reputation_gmblocation_site_id_321487d3_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmblocation
    ADD CONSTRAINT reputation_gmblocation_site_id_321487d3_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4716 (class 2606 OID 851810)
-- Name: reputation_gmbnotification reputation_gmbnotifi_review_id_0e88eccb_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotification
    ADD CONSTRAINT reputation_gmbnotifi_review_id_0e88eccb_fk_reputatio FOREIGN KEY (review_id) REFERENCES public.reputation_gmbreview(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4717 (class 2606 OID 851799)
-- Name: reputation_gmbnotifyee reputation_gmbnotify_customer_id_e0456300_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbnotifyee
    ADD CONSTRAINT reputation_gmbnotify_customer_id_e0456300_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4715 (class 2606 OID 851779)
-- Name: reputation_gmbreplyaction reputation_gmbreplya_review_id_f5809238_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreplyaction
    ADD CONSTRAINT reputation_gmbreplya_review_id_f5809238_fk_reputatio FOREIGN KEY (review_id) REFERENCES public.reputation_gmbreview(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4714 (class 2606 OID 851784)
-- Name: reputation_gmbreplyaction reputation_gmbreplyaction_user_id_6647aab6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreplyaction
    ADD CONSTRAINT reputation_gmbreplyaction_user_id_6647aab6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4713 (class 2606 OID 851768)
-- Name: reputation_gmbreview reputation_gmbreview_location_id_d4947fd8_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_gmbreview
    ADD CONSTRAINT reputation_gmbreview_location_id_d4947fd8_fk_reputatio FOREIGN KEY (location_id) REFERENCES public.reputation_gmblocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4719 (class 2606 OID 875393)
-- Name: reputation_reviewticket reputation_reviewtic_review_id_47195d92_fk_reputatio; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewtic_review_id_47195d92_fk_reputatio FOREIGN KEY (review_id) REFERENCES public.reputation_gmbreview(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4718 (class 2606 OID 875398)
-- Name: reputation_reviewticket reputation_reviewtic_ticket_id_cf5ed169_fk_ticket_pa; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewtic_ticket_id_cf5ed169_fk_ticket_pa FOREIGN KEY (ticket_id) REFERENCES public.ticket_patient_ticket(ticket_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4720 (class 2606 OID 875388)
-- Name: reputation_reviewticket reputation_reviewticket_creator_id_2aa08418_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reputation_reviewticket
    ADD CONSTRAINT reputation_reviewticket_creator_id_2aa08418_fk_auth_user_id FOREIGN KEY (creator_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4592 (class 2606 OID 17070)
-- Name: surveys_surveyresponse response_to_id_refs_id_839cfd8e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_surveyresponse
    ADD CONSTRAINT response_to_id_refs_id_839cfd8e FOREIGN KEY (response_to_id) REFERENCES public.surveys_survey_request(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4639 (class 2606 OID 17075)
-- Name: reviews_feed reviews_feed_site_id_436e167db0caf01_fk_customer_site_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_feed
    ADD CONSTRAINT reviews_feed_site_id_436e167db0caf01_fk_customer_site_id FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4640 (class 2606 OID 17080)
-- Name: reviews_review reviews_review_feed_id_4cdde73760a8101e_fk_reviews_feed_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.reviews_review
    ADD CONSTRAINT reviews_review_feed_id_4cdde73760a8101e_fk_reviews_feed_id FOREIGN KEY (feed_id) REFERENCES public.reviews_feed(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4589 (class 2606 OID 17085)
-- Name: surveys_survey_request sent_to_id_refs_id_7350f4f8; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_survey_request
    ADD CONSTRAINT sent_to_id_refs_id_7350f4f8 FOREIGN KEY (sent_to_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4582 (class 2606 OID 17090)
-- Name: socialaccount_socialapp_sites site_id_refs_id_05d6147e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT site_id_refs_id_05d6147e FOREIGN KEY (site_id) REFERENCES public.django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4565 (class 2606 OID 17095)
-- Name: customer_scheduledappointment site_id_refs_id_5d8fb12b; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_scheduledappointment
    ADD CONSTRAINT site_id_refs_id_5d8fb12b FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4559 (class 2606 OID 17100)
-- Name: customer_patientvisithistory site_id_refs_id_6b065f8f; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_patientvisithistory
    ADD CONSTRAINT site_id_refs_id_6b065f8f FOREIGN KEY (site_id) REFERENCES public.customer_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4581 (class 2606 OID 17105)
-- Name: socialaccount_socialapp_sites socialapp_id_refs_id_e7a43014; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialapp_id_refs_id_e7a43014 FOREIGN KEY (socialapp_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4709 (class 2606 OID 846522)
-- Name: sources_customercode sources_customercode_customer_id_e8b1abe9_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_customercode
    ADD CONSTRAINT sources_customercode_customer_id_e8b1abe9_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4708 (class 2606 OID 846527)
-- Name: sources_customercode sources_customercode_source_id_04661968_fk_sources_i; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_customercode
    ADD CONSTRAINT sources_customercode_source_id_04661968_fk_sources_i FOREIGN KEY (source_id) REFERENCES public.sources_internalsource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4707 (class 2606 OID 846511)
-- Name: sources_internalasset sources_internalasse_source_id_82df3e4d_fk_sources_i; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalasset
    ADD CONSTRAINT sources_internalasse_source_id_82df3e4d_fk_sources_i FOREIGN KEY (source_id) REFERENCES public.sources_internalsource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4704 (class 2606 OID 850545)
-- Name: sources_internalsource sources_internalsour_customer_id_e9d1be5a_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsource
    ADD CONSTRAINT sources_internalsour_customer_id_e9d1be5a_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4705 (class 2606 OID 850539)
-- Name: sources_internalsource sources_internalsour_organization_id_7fc9c900_fk_customer_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsource
    ADD CONSTRAINT sources_internalsour_organization_id_7fc9c900_fk_customer_ FOREIGN KEY (organization_id) REFERENCES public.customer_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4706 (class 2606 OID 846504)
-- Name: sources_internalsourcecheck sources_internalsour_source_id_ba2f6908_fk_sources_i; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sources_internalsourcecheck
    ADD CONSTRAINT sources_internalsour_source_id_ba2f6908_fk_sources_i FOREIGN KEY (source_id) REFERENCES public.sources_internalsource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4670 (class 2606 OID 780081)
-- Name: sso_samlprovider sso_samlprovider_organization_id_394c287f_fk_customer_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.sso_samlprovider
    ADD CONSTRAINT sso_samlprovider_organization_id_394c287f_fk_customer_ FOREIGN KEY (organization_id) REFERENCES public.customer_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4588 (class 2606 OID 17115)
-- Name: surveys_npssurveyresponse surveyresponse_ptr_id_refs_id_456aee59; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npssurveyresponse
    ADD CONSTRAINT surveyresponse_ptr_id_refs_id_456aee59 FOREIGN KEY (surveyresponse_ptr_id) REFERENCES public.surveys_surveyresponse(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4587 (class 2606 OID 17125)
-- Name: surveys_npssurveyresponse surveys_np_customer_id_17414754fc0efc8b_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npssurveyresponse
    ADD CONSTRAINT surveys_np_customer_id_17414754fc0efc8b_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4650 (class 2606 OID 17130)
-- Name: surveys_npsscoreremoval surveys_np_customer_id_620e27864c0fcd92_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval
    ADD CONSTRAINT surveys_np_customer_id_620e27864c0fcd92_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4649 (class 2606 OID 17135)
-- Name: surveys_npsscoreremoval surveys_np_provider_id_7398e71727eb754d_fk_customer_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval
    ADD CONSTRAINT surveys_np_provider_id_7398e71727eb754d_fk_customer_provider_id FOREIGN KEY (provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4648 (class 2606 OID 17140)
-- Name: surveys_npsscoreremoval surveys_npsscoreremova_user_id_19b52de3aa917767_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.surveys_npsscoreremoval
    ADD CONSTRAINT surveys_npsscoreremova_user_id_19b52de3aa917767_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4597 (class 2606 OID 17145)
-- Name: ticket_employee_lookup system_provider_id_refs_id_218e3351; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT system_provider_id_refs_id_218e3351 FOREIGN KEY (system_provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4596 (class 2606 OID 17150)
-- Name: ticket_employee_lookup system_user_id_refs_id_fe2f1c2d; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_employee_lookup
    ADD CONSTRAINT system_user_id_refs_id_fe2f1c2d FOREIGN KEY (system_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4609 (class 2606 OID 17155)
-- Name: ticket_ticket tag_id_refs_id_708f8b38; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT tag_id_refs_id_708f8b38 FOREIGN KEY (tag_id) REFERENCES public.ticket_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4703 (class 2606 OID 809909)
-- Name: teams_dm teams_dm_member_id_cea0bfac_fk_teams_member_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm
    ADD CONSTRAINT teams_dm_member_id_cea0bfac_fk_teams_member_id FOREIGN KEY (member_id) REFERENCES public.teams_member(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4702 (class 2606 OID 809914)
-- Name: teams_dm teams_dm_message_id_107cc404_fk_teams_messageout_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm
    ADD CONSTRAINT teams_dm_message_id_107cc404_fk_teams_messageout_id FOREIGN KEY (message_id) REFERENCES public.teams_messageout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4701 (class 2606 OID 809919)
-- Name: teams_dm teams_dm_sender_id_f7e8626f_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_dm
    ADD CONSTRAINT teams_dm_sender_id_f7e8626f_fk_auth_user_id FOREIGN KEY (sender_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4686 (class 2606 OID 809615)
-- Name: teams_envelope teams_envelope_member_id_149dccac_fk_teams_member_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_member_id_149dccac_fk_teams_member_id FOREIGN KEY (member_id) REFERENCES public.teams_member(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4684 (class 2606 OID 809929)
-- Name: teams_envelope teams_envelope_message_id_76f74eca_fk_teams_messageout_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_message_id_76f74eca_fk_teams_messageout_id FOREIGN KEY (message_id) REFERENCES public.teams_messageout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4685 (class 2606 OID 809627)
-- Name: teams_envelope teams_envelope_notice_id_5da4821a_fk_teams_notice_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_envelope
    ADD CONSTRAINT teams_envelope_notice_id_5da4821a_fk_teams_notice_id FOREIGN KEY (notice_id) REFERENCES public.teams_notice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4688 (class 2606 OID 809603)
-- Name: teams_member teams_member_provider_id_f33e5473_fk_customer_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member
    ADD CONSTRAINT teams_member_provider_id_f33e5473_fk_customer_provider_id FOREIGN KEY (provider_id) REFERENCES public.customer_provider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4687 (class 2606 OID 809609)
-- Name: teams_member teams_member_team_id_1860c414_fk_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_member
    ADD CONSTRAINT teams_member_team_id_1860c414_fk_teams_team_id FOREIGN KEY (team_id) REFERENCES public.teams_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4691 (class 2606 OID 809580)
-- Name: teams_messagein teams_messagein_cue_id_9f318c27_fk_teams_messageout_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein
    ADD CONSTRAINT teams_messagein_cue_id_9f318c27_fk_teams_messageout_id FOREIGN KEY (cue_id) REFERENCES public.teams_messageout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4690 (class 2606 OID 809586)
-- Name: teams_messagein teams_messagein_member_id_bc87a75e_fk_teams_member_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein
    ADD CONSTRAINT teams_messagein_member_id_bc87a75e_fk_teams_member_id FOREIGN KEY (member_id) REFERENCES public.teams_member(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4689 (class 2606 OID 809592)
-- Name: teams_messagein teams_messagein_source_phone_id_8c898b30_fk_teams_phone_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messagein
    ADD CONSTRAINT teams_messagein_source_phone_id_8c898b30_fk_teams_phone_id FOREIGN KEY (source_phone_id) REFERENCES public.teams_phone(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4693 (class 2606 OID 809568)
-- Name: teams_messageout teams_messageout_destination_phone_id_a222925b_fk_teams_pho; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messageout
    ADD CONSTRAINT teams_messageout_destination_phone_id_a222925b_fk_teams_pho FOREIGN KEY (destination_phone_id) REFERENCES public.teams_phone(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4692 (class 2606 OID 809574)
-- Name: teams_messageout teams_messageout_member_id_3f9a072f_fk_teams_member_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_messageout
    ADD CONSTRAINT teams_messageout_member_id_3f9a072f_fk_teams_member_id FOREIGN KEY (member_id) REFERENCES public.teams_member(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4695 (class 2606 OID 809521)
-- Name: teams_notice teams_notice_sender_id_fe043af1_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_notice
    ADD CONSTRAINT teams_notice_sender_id_fe043af1_fk_auth_user_id FOREIGN KEY (sender_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4694 (class 2606 OID 809562)
-- Name: teams_notice teams_notice_team_id_3365ab20_fk_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_notice
    ADD CONSTRAINT teams_notice_team_id_3365ab20_fk_teams_team_id FOREIGN KEY (team_id) REFERENCES public.teams_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4696 (class 2606 OID 809634)
-- Name: teams_phone teams_phone_member_id_6fff9efe_fk_teams_member_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone
    ADD CONSTRAINT teams_phone_member_id_6fff9efe_fk_teams_member_id FOREIGN KEY (member_id) REFERENCES public.teams_member(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4697 (class 2606 OID 809556)
-- Name: teams_phone teams_phone_team_id_95316d2b_fk_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_phone
    ADD CONSTRAINT teams_phone_team_id_95316d2b_fk_teams_team_id FOREIGN KEY (team_id) REFERENCES public.teams_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4699 (class 2606 OID 809537)
-- Name: teams_receipt teams_receipt_authority_id_4af57010_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_receipt
    ADD CONSTRAINT teams_receipt_authority_id_4af57010_fk_auth_user_id FOREIGN KEY (authority_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4698 (class 2606 OID 809542)
-- Name: teams_receipt teams_receipt_message_id_d6c836de_fk_teams_messagein_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_receipt
    ADD CONSTRAINT teams_receipt_message_id_d6c836de_fk_teams_messagein_id FOREIGN KEY (message_id) REFERENCES public.teams_messagein(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4700 (class 2606 OID 809549)
-- Name: teams_team teams_team_customer_id_17a7b838_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.teams_team
    ADD CONSTRAINT teams_team_customer_id_17a7b838_fk_callfile_customer_id FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4620 (class 2606 OID 17160)
-- Name: ticket_customer_cohort ticket_cust_cohort_ref_id_fac1cb9432cf47d_fk_ticket_priority_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_customer_cohort
    ADD CONSTRAINT ticket_cust_cohort_ref_id_fac1cb9432cf47d_fk_ticket_priority_id FOREIGN KEY (cohort_ref_id) REFERENCES public.ticket_cohort(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4619 (class 2606 OID 17165)
-- Name: ticket_customer_cohort ticket_customer_ref_id_189828e8cbee8df6_fk_callfile_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_customer_cohort
    ADD CONSTRAINT ticket_customer_ref_id_189828e8cbee8df6_fk_callfile_customer_id FOREIGN KEY (customer_ref_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4625 (class 2606 OID 17170)
-- Name: ticket_draftnote ticket_draftnote_ticket_id_44aa799ef9221e70_fk_ticket_ticket_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_draftnote
    ADD CONSTRAINT ticket_draftnote_ticket_id_44aa799ef9221e70_fk_ticket_ticket_id FOREIGN KEY (ticket_id) REFERENCES public.ticket_ticket(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4624 (class 2606 OID 17175)
-- Name: ticket_draftnote ticket_draftnote_user_id_30439ce48eaa9edd_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_draftnote
    ADD CONSTRAINT ticket_draftnote_user_id_30439ce48eaa9edd_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4623 (class 2606 OID 17180)
-- Name: ticket_note ticket_note_ticket_id_6017e5193b85dd7c_fk_ticket_ticket_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_note
    ADD CONSTRAINT ticket_note_ticket_id_6017e5193b85dd7c_fk_ticket_ticket_id FOREIGN KEY (ticket_id) REFERENCES public.ticket_ticket(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4622 (class 2606 OID 17185)
-- Name: ticket_note ticket_note_user_id_70a3244c06c1fef1_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_note
    ADD CONSTRAINT ticket_note_user_id_70a3244c06c1fef1_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4600 (class 2606 OID 17190)
-- Name: ticket_patient_ticket ticket_ptr_id_refs_id_f7ae933c; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_patient_ticket
    ADD CONSTRAINT ticket_ptr_id_refs_id_f7ae933c FOREIGN KEY (ticket_ptr_id) REFERENCES public.ticket_ticket(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4608 (class 2606 OID 17195)
-- Name: ticket_ticket ticket_tick_phone_number_id_2eceda3a43e9e9e8_fk_phone_number_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT ticket_tick_phone_number_id_2eceda3a43e9e9e8_fk_phone_number_id FOREIGN KEY (phone_number_id) REFERENCES public.phone_number(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4607 (class 2606 OID 17200)
-- Name: ticket_ticket ticket_ticke_patient_id_495d407cdf2039cc_fk_customer_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT ticket_ticke_patient_id_495d407cdf2039cc_fk_customer_patient_id FOREIGN KEY (patient_id) REFERENCES public.customer_patient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4606 (class 2606 OID 17205)
-- Name: ticket_ticket ticket_ticket_cohort_id_4d430c05bfef53e3_fk_ticket_priority_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT ticket_ticket_cohort_id_4d430c05bfef53e3_fk_ticket_priority_id FOREIGN KEY (cohort_id) REFERENCES public.ticket_cohort(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4605 (class 2606 OID 837855)
-- Name: ticket_ticket ticket_ticket_content_type_id_fb41d71c_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_ticket
    ADD CONSTRAINT ticket_ticket_content_type_id_fb41d71c_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4544 (class 2606 OID 17210)
-- Name: admin_tools_menu_bookmark user_id_refs_id_1dc7bd98; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_menu_bookmark
    ADD CONSTRAINT user_id_refs_id_1dc7bd98 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4543 (class 2606 OID 17215)
-- Name: admin_tools_dashboard_preferences user_id_refs_id_23127ba7; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.admin_tools_dashboard_preferences
    ADD CONSTRAINT user_id_refs_id_23127ba7 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4549 (class 2606 OID 17220)
-- Name: auth_user_groups user_id_refs_id_40c41112; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT user_id_refs_id_40c41112 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4541 (class 2606 OID 17225)
-- Name: account_emailaddress user_id_refs_id_4aacde5e; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT user_id_refs_id_4aacde5e FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4551 (class 2606 OID 17230)
-- Name: auth_user_user_permissions user_id_refs_id_4dc23c39; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_4dc23c39 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4602 (class 2606 OID 17240)
-- Name: ticket_status_history user_id_refs_id_82ae546f; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.ticket_status_history
    ADD CONSTRAINT user_id_refs_id_82ae546f FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4580 (class 2606 OID 17245)
-- Name: socialaccount_socialaccount user_id_refs_id_b4f0248b; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT user_id_refs_id_b4f0248b FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4570 (class 2606 OID 17250)
-- Name: django_admin_log user_id_refs_id_c0d12874; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT user_id_refs_id_c0d12874 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4614 (class 2606 OID 723299)
-- Name: user_meta user_meta_user_id_58c29229_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.user_meta
    ADD CONSTRAINT user_meta_user_id_58c29229_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4568 (class 2606 OID 17255)
-- Name: customer_usertocustomer user_ref_id_refs_id_bb761b74; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.customer_usertocustomer
    ADD CONSTRAINT user_ref_id_refs_id_bb761b74 FOREIGN KEY (user_ref_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4671 (class 2606 OID 792842)
-- Name: whitelists_address whitelists_address_whitelist_id_dd14d9c9_fk_whitelist; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_address
    ADD CONSTRAINT whitelists_address_whitelist_id_dd14d9c9_fk_whitelist FOREIGN KEY (whitelist_id) REFERENCES public.whitelists_whitelist(uuid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4672 (class 2606 OID 792835)
-- Name: whitelists_whitelist whitelists_whitelist_customer_id_b41a76ce_fk_callfile_; Type: FK CONSTRAINT; Schema: public; Owner: aptible
--

ALTER TABLE ONLY public.whitelists_whitelist
    ADD CONSTRAINT whitelists_whitelist_customer_id_b41a76ce_fk_callfile_ FOREIGN KEY (customer_id) REFERENCES public.callfile_customer(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2023-01-26 14:33:51

--
-- PostgreSQL database dump complete
--

