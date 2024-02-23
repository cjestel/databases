/* Set the role name in the function and also in the \set command below */

DO
$do$
DECLARE
  -- -----------
  -- SET ME HERE
  -- -----------
  role_name text := 'sampledb_ro';
BEGIN

  IF NOT EXISTS (
    SELECT  -- SELECT list can stay empty for this
    FROM   pg_catalog.pg_roles
    WHERE  rolname = role_name) THEN
      -- CREATE ROLE role_name;
      execute 'CREATE USER ' || role_name;
   END IF;
END
$do$;

-- -----------
-- SET ME HERE
-- -----------
\set role_name 'sampledb_ro'

GRANT CONNECT ON DATABASE $(DBNAME) TO :"role_name";

GRANT select ON ALL TABLES IN SCHEMA "public" TO :"role_name";
GRANT USAGE ON SCHEMA "public" TO :"role_name";
GRANT execute ON ALL functions IN SCHEMA "public" TO :"role_name";
GRANT USAGE ON ALL sequences IN SCHEMA "public" TO :"role_name";
ALTER DEFAULT PRIVILEGES IN SCHEMA "public" GRANT select ON TABLES TO :"role_name";
ALTER DEFAULT PRIVILEGES IN SCHEMA "public" GRANT execute ON functions to :"role_name";
ALTER DEFAULT PRIVILEGES IN SCHEMA "public" GRANT usage ON sequences to :"role_name";
