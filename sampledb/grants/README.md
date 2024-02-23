# Default State
The grants files by default do not have a .sql extension which means they will
not be picked up by dbdeployer. These files will create a reader and writer role
based on the name used in the file. Please note the name does need set in both
the function and the file separately. To enable, rename the files to have a .sql
extension on them.

In my case, we had functions that were set up for various reads or reports, so I
do enable execute for the reader. Please adjust permissions accordingly for your
needs.

# Creating the Role
DBdeployer will automatically pick these files up based on our default
configuration file. The grants folder is specified in the `auto_deply_folders`
list. If you are running into issues with the creation of the specified role,
ensure the folder is in that list in the config file and that you have added the
`.sql` extension to the file(s).

The `auto_deploy_folders` setting make use of the checksum feature to detect
when there are changes to the file that need deployed. The initial creation of
the role is easy. From there you have two options as far as how you maintain the
permissions of the role. You can either do everything in an additive fashion and
add or remove permissions as you go down the file, or you can revoke everything
and then add the permissions for the role back in. Keep in mind the entirety of
the file is executed every time there is a change, so your changes must maintain
backwards compatibility.

# Associate a user to the role
I made use of automations that pulled our users from a secretmanager location.
We use a yaml file to map what user should be associated with what role and
what its password was and we executed the below template on the server to
associate everything. Feel free to use or modify the below template for your own
needs. The below template was written for and executed by puppet, but is pretty
straight forward. You should really only need to change the variable being used
and then execute the file. This did make use of md5 passwords, so for other auth
methods you will need to update accordingly.

```
\c <%= @dbname %>

DO
$do$
DECLARE
  etl_user_wr      text := '<%= @_etl_user_wr -%>';
  etl_user_wr_pw   text := '<%= @_etl_user_wr_pw -%>';
  etl_user_ro      text := '<%= @_etl_user_ro -%>';
  etl_user_ro_pw   text := '<%= @_etl_user_ro_pw -%>';
  user_name_wr     text := '<%= @_username_wr -%>';
  user_password_wr text := '<%= @_password_wr -%>';
  user_name_ro     text := '<%= @_username_ro -%>';
  user_password_ro text := '<%= @_password_ro -%>';
BEGIN

-- ----------------------
-- Application write user
-- ----------------------

  IF NOT EXISTS (
    SELECT  -- SELECT list can stay empty for this
    FROM   pg_catalog.pg_roles
    WHERE  rolname = user_name_wr) THEN
      execute 'CREATE USER ' || user_name_wr || ' <%= @_encryption_string -%> PASSWORD ''' || user_password_wr || ''' IN ROLE <%= @_rolename_wr -%>';
   END IF;

   execute 'GRANT <%= @_rolename_wr -%> TO ' || user_name_wr ;

-- ----------------------
-- Application read user
-- ----------------------

  IF NOT EXISTS (
    SELECT  -- SELECT list can stay empty for this
    FROM   pg_catalog.pg_roles
    WHERE  rolname = user_name_ro) THEN
      execute 'CREATE USER ' || user_name_ro || ' <%= @_encryption_string -%> PASSWORD ''' || user_password_ro || ''' IN ROLE <%= @_rolename_ro -%>';
  END IF;

  execute 'GRANT <%= @_rolename_ro -%> TO ' || user_name_ro ;

```
