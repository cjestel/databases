-- create schema if it doesn't exist
create schema if not exists dba;

-- create function for returning timestamp to populate updated_at fields
create or replace function trigger_set_updated_at_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;


-- create lookup table for archive type
create table dba.archive_type (
  id         serial primary key,
  name       character varying (32) unique,
  updated_at timestamptz not null default current_timestamp,
  created_at timestamptz not null default current_timestamp
);

create trigger set_archive_type_updated_at_timestamp
before update on dba.archive_type
for each row
execute procedure trigger_set_updated_at_timestamp();


insert into dba.archive_type (id, name) values
  (1,'partition'), (2,'prune');


create table dba.archive_interval_type (
  id         serial primary key,
  name       character varying (32) unique,
  updated_at timestamptz not null default current_timestamp,
  created_at timestamptz not null default current_timestamp
);

create trigger set_archive_interval_type_updated_at_timestamp
before update on dba.archive_interval_type
for each row
execute procedure trigger_set_updated_at_timestamp();



insert into dba.archive_interval_type (id, name) values
  (1,'year'), (2,'month');

-- create table to hold tables that will be archived
create table dba.table_archive_data (
  id            		serial primary key,
  table_schema  		character varying (255) default 'public',
  table_name    		character varying (255) not null,
  archive_batch_size		integer not null default 5000,
  archive_interval		integer not null, -- number of months or years to retain, days not currently supported
  archive_interval_type_id 	integer not null references dba.archive_interval_type(id),
  archive_interval_sleep	integer not null default 3,
  archive_type_id  		integer not null references dba.archive_type(id),
  count_query                   text not null,
  analyze_threshold		integer not null default 100000,
  run_order     		integer,
  updated_at timestamptz not null default current_timestamp,
  created_at timestamptz not null default current_timestamp,
  unique                        (table_schema, table_name)
);

create trigger set_table_archive_data_updated_at_timestamp
before update on dba.table_archive_data
for each row
execute procedure trigger_set_updated_at_timestamp();


create index table_archive_data_run_order_idx on dba.table_archive_data(run_order);
create index table_archive_data_updated_at_idx on dba.table_archive_data(updated_at);
create index table_archive_data_created_at_idx on dba.table_archive_data(created_at);





-- create table for query ordering
create table dba.prune_tables_query_order (
  id                    serial primary key,
  table_archive_data_id	integer not null references dba.table_archive_data(id),
  archive_query         text,
  query_order           integer not null,
  updated_at            timestamptz not null default current_timestamp,
  created_at            timestamptz not null default current_timestamp,
  unique                (table_archive_data_id, query_order)
);

create trigger set_prune_tables_query_order_updated_at_timestamp
before update on dba.prune_tables_query_order
for each row
execute procedure trigger_set_updated_at_timestamp();


create index prune_tables_archive_id_query_order_idx on dba.prune_tables_query_order(table_archive_data_id, query_order);
create index prune_tables_query_order_updated_at_idx on dba.prune_tables_query_order(updated_at);
create index prune_tables_query_order_created_at_idx on dba.prune_tables_query_order(created_at);



-- create logging table
create table dba.archive_logs (
  id 		        bigserial primary key,
  table_archive_data_id integer not null references dba.table_archive_data(id),
  batch_start_time      timestamptz,
  batch_end_time        timestamptz,
  rows_archived	        integer not null,
  updated_at            timestamptz not null default current_timestamp,
  created_at            timestamptz not null default current_timestamp
);

create trigger set_archive_logs_updated_at_timestamp
before update on dba.archive_logs
for each row
execute procedure trigger_set_updated_at_timestamp();


create index archive_logs_table_archive_data_id_idx on dba.archive_logs(table_archive_data_id);
create index archive_logs_batch_start_time_idx on dba.archive_logs(batch_start_time);
create index archive_logs_batch_end_time_idx on dba.archive_logs(batch_end_time);
create index archive_logs_updated_at_idx on dba.archive_logs(updated_at);
create index archive_logs_created_at_idx on dba.archive_logs(created_at);


--
-- move below here to a new file once done testing as this is real data, it not supporting or meta data
--

-- populate archive data with table name and supporting records
insert into dba.table_archive_data (
  id,
  table_name, 
  archive_batch_size, 
  archive_interval, 
  archive_interval_type_id,
  archive_type_id, 
  archive_interval_sleep,
  count_query,
  analyze_threshold,
  run_order) 
values (
  1,
  'sample_table',
  5000,
  3,
  1,
  2,
  0,
  '
  create temporary table t_sample_table as 
    select a.id, a.created_at from sample_table a
    where a.created_at < ||ARCHIVE_DATE||
  ;
  ',
  100000,
  100
);

-- populate queries to run against the table

insert into dba.prune_tables_query_order (
  table_archive_data_id,
  archive_query,
  query_order)
values (
  1,
  '
  WITH rows AS (
    delete from public.sample_table a
      where a.id in (
        select b.id from sample_table b
        inner join t_sample_table c on b.id = c.id
	limit ||ARCHIVE_LIMIT||
    )
    returning a.*
  ) insert into archive.sample_table select * from rows;
  ',
  10
)
;









