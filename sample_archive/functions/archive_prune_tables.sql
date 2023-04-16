CREATE OR REPLACE PROCEDURE dba.archive_prune_tables()
LANGUAGE plpgsql
AS $$


DECLARE
  affected_rows        		integer;	-- reports affected rows from query
  archive_query        		varchar(1024);	-- used to generate and hold the query for archive
  archive_through_query 	varchar(1024);	-- query to generate what is held in archive_through_date
  archive_through_date		varchar(19);	-- holds the date that is generated based on archive_interval and archive_interval_type
  batch_start_time		timestamptz;    -- timestamp of when batch started for logging purposes
  batch_end_time		timestamptz;    -- timestamp of when batch completed for logging purposes
  num_rows_to_archive  		integer;	-- total number of rows to be archived at start of run for the table
  num_rows_query       		varchar(1024);  -- total number of rows affected by archive query
  tables_to_archive    		RECORD;		-- used to iterate over tables to be archived

BEGIN
  create schema if not exists archive;
  FOR tables_to_archive IN 
    select table_schema s, table_name n, archive_id, archive_field, archive_batch_size, archive_interval, archive_interval_sleep, archive_type, run_order, name archive_interval_type
      FROM dba.table_archive_data
      LEFT JOIN dba.archive_interval_type on archive_interval_type_id = archive_interval_type.id
      WHERE archive_type = 2
      ORDER BY run_order asc
  LOOP

    RAISE NOTICE 'Creating archive.% from table %.% if it doesn''t exist',tables_to_archive.n,tables_to_archive.s,tables_to_archive.n;
    EXECUTE format('create table if not exists archive.%1$s (like %2$s.%1$s);',tables_to_archive.n,tables_to_archive.s);
    RAISE NOTICE 'Archiving table: %.%', tables_to_archive.s, tables_to_archive.n;

    archive_through_query := format('select to_char(now() - interval ''%s'' %s,''yyyy-mm-01 00:00:00'');',tables_to_archive.archive_interval,tables_to_archive.archive_interval_type);
    EXECUTE archive_through_query INTO archive_through_date;
    RAISE NOTICE 'Archiving records older than %', archive_through_date;

    num_rows_query := format('SELECT count(*) from %s.%s where created_on < ''%s'';',tables_to_archive.s,tables_to_archive.n, archive_through_date);
    EXECUTE num_rows_query INTO num_rows_to_archive;
    RAISE NOTICE 'Number of rows to archive: %', num_rows_to_archive;
      

    WHILE num_rows_to_archive > 0 LOOP

      select clock_timestamp() into batch_start_time;
       
      archive_query := format('with rows as (
        delete from %1$s.%2$s a
          where id in (select %6$s from %1$s.%2$s where %5$s < ''%3$s'' order by %5$s ASC LIMIT %4$s) 
        returning a.*)
        insert into archive.%2$s select * from rows;', tables_to_archive.s, tables_to_archive.n, archive_through_date, tables_to_archive.archive_batch_size, tables_to_archive.archive_field, tables_to_archive.archive_id
      );
    
      --RAISE NOTICE 'Query: %', v_query;
    
      EXECUTE archive_query;
      GET DIAGNOSTICS affected_rows = ROW_COUNT;
      RAISE NOTICE 'Affected Rows: %', affected_rows;

      select clock_timestamp() into batch_end_time;
      EXECUTE format('INSERT INTO  dba.archive_logs (table_name, batch_start_time, batch_end_time, rows_archived) VALUES (''%1$s.%2$s'', ''%3$s'',''%4$s'',%5$s);', tables_to_archive.s, tables_to_archive.n, batch_start_time, batch_end_time, affected_rows); 
      commit;

      num_rows_to_archive := num_rows_to_archive - tables_to_archive.archive_batch_size;

      RAISE NOTICE 'Sleeping for % seconds',tables_to_archive.archive_interval_sleep;
      EXECUTE FORMAT('SELECT pg_sleep(%s);',tables_to_archive.archive_interval_sleep);
    END LOOP; -- end archive records within table

  END LOOP; -- end table archive and go to next record
END;
$$;
