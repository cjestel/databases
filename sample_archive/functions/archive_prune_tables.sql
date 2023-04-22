CREATE OR REPLACE PROCEDURE dba.archive_prune_tables()
LANGUAGE plpgsql
AS $$


DECLARE
  analyze_counter		integer;        -- if deleted row count gets above limit run analyze on table
  affected_rows        		integer;	-- reports affected rows from query
  archive_queries_to_loop       RECORD;		-- used to hold the queries for archive
  archive_query_count		integer;	-- used to store the number of queries to iterate over
  archive_query_status		integer; 	-- used to store the current iteration of steps over queries
  archive_through_query 	varchar(1024);	-- query to generate what is held in archive_through_date
  archive_through_date		varchar(19);	-- holds the date that is generated based on archive_interval and archive_interval_type
  batch_start_time		timestamptz;    -- timestamp of when batch started for logging purposes
  batch_end_time		timestamptz;    -- timestamp of when batch completed for logging purposes
  count_query_gen               text;           -- query that will give the query used to obtain the count of rows
  num_rows_query       		varchar(1024);  -- total number of rows affected by archive query
  num_rows_to_archive		integer;	-- store the number of rows to archive in total for the table
  reindex_composite_string	text;		-- used to store reindex commands for output at end of run
  tables_to_archive    		RECORD;		-- used to iterate over tables to be archived
  str_replace_archive_query	text;		-- used to hold the modified query after archive_date and limt have been interpolated

BEGIN
  create schema if not exists archive;
  FOR tables_to_archive IN 
    select table_schema s, table_name n, archive_batch_size, archive_interval, archive_interval_sleep, run_order, archive_interval_type_id, name, count_query, table_archive_data.id tad_id, analyze_threshold
      FROM dba.table_archive_data
      LEFT JOIN dba.archive_interval_type on archive_interval_type_id = archive_interval_type.id
      WHERE archive_type_id = 2
      ORDER BY run_order asc
  LOOP

    RAISE NOTICE 'Creating archive.% from table %.% if it doesn''t exist',tables_to_archive.n,tables_to_archive.s,tables_to_archive.n;
    EXECUTE format('create table if not exists archive.%1$s (like %2$s.%1$s);',tables_to_archive.n,tables_to_archive.s);
    RAISE NOTICE 'Archiving table: %.%', tables_to_archive.s, tables_to_archive.n;

    archive_through_query := format('select to_char(now() - interval ''%s'' %s,''yyyy-mm-01 00:00:00'');',tables_to_archive.archive_interval,tables_to_archive.name);
    EXECUTE archive_through_query INTO archive_through_date;
    RAISE NOTICE 'Archiving records older than %', archive_through_date;

    EXECUTE format('select replace( ''%1$s'', ''||ARCHIVE_DATE||'', ''''''%2$s'''''');',tables_to_archive.count_query,archive_through_date) INTO count_query_gen;
    EXECUTE count_query_gen;
    GET DIAGNOSTICS num_rows_to_archive = ROW_COUNT;
    RAISE NOTICE 'Rows to archive: %', num_rows_to_archive;


    for archive_queries_to_loop in 
      select archive_query, query_order
      from dba.prune_tables_query_order 
      where table_archive_data_id = tables_to_archive.tad_id 
      order by query_order asc
      
    LOOP 
      EXECUTE format('select replace( ''%1$s'', ''||ARCHIVE_DATE||'', ''''''%2$s'''''');',archive_queries_to_loop.archive_query,archive_through_date) INTO str_replace_archive_query;
      EXECUTE format('select replace( ''%1$s'', ''||ARCHIVE_LIMIT||'', ''''''%2$s'''''');',str_replace_archive_query,tables_to_archive.archive_batch_size) INTO str_replace_archive_query;
      RAISE NOTICE 'Running Query: %',str_replace_archive_query;
     
      archive_query_status := 0;
      analyze_counter := 0;

      WHILE num_rows_to_archive > archive_query_status LOOP
        
	select clock_timestamp() into batch_start_time;

        EXECUTE str_replace_archive_query;
	GET DIAGNOSTICS archive_query_count = ROW_COUNT;
	RAISE NOTICE 'Table %.%: Archived % of %',tables_to_archive.s, tables_to_archive.n, archive_query_status, num_rows_to_archive;

	archive_query_status := archive_query_status + archive_query_count;
	analyze_counter := analyze_counter + archive_query_count;

	if analyze_counter > tables_to_archive.analyze_threshold then
          RAISE NOTICE 'Exceeded defined analyze threshold for archive, running analyze on %.%',tables_to_archive.s, tables_to_archive.n;
	  EXECUTE format('analyze %s.%s',tables_to_archive.s, tables_to_archive.n);
	  analyze_counter := 0;
	end if;

        select clock_timestamp() into batch_end_time;
        EXECUTE format('INSERT INTO  dba.archive_logs (table_archive_data_id, batch_start_time, batch_end_time, rows_archived) VALUES (%1$s, ''%2$s'',''%3$s'',%4$s);', tables_to_archive.tad_id, batch_start_time, batch_end_time, archive_query_count);

	commit;




	if tables_to_archive.archive_interval_sleep > 0 then 
	  EXECUTE format('select pg_sleep(%s);',tables_to_archive.archive_interval_sleep);
	end if;

      END LOOP; -- ends loop for archive

      RAISE NOTICE 'End of archive for this table, running analyze on %.%',tables_to_archive.s, tables_to_archive.n;
      EXECUTE format('analyze %s.%s',tables_to_archive.s, tables_to_archive.n);


    END LOOP; -- ends loop for iterating over archive queries
    
    -- reindex_composite_string := reindex_composite_string || 'reindex table concurrently sample_table;';

  END LOOP; -- end table archive and go to next record


  -- display tables to reindex (not working yet)
  -- RAISE NOTICE 'Recommended to reindex tables. Run below command(s): %',reindex_composite_string;

END;
$$;
