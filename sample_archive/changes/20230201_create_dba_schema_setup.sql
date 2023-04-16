-- create schema if it doesn't exist
create schema if not exists dba;

-- create lookup table for archive type
create table dba.archive_type (
  id    serial primary key,
  name  character varying (32) unique
);


insert into dba.archive_type (id, name) values
  (1,'partition'), (2,'prune');


create table dba.archive_interval_type (
  id    serial primary key,
  name  character varying (32) unique
);

insert into dba.archive_interval_type (id, name) values
  (1,'year'), (2,'month');

-- create table to hold tables that will be archived
create table dba.table_archive_data (
  id            		serial primary key,
  table_schema  		character varying (255) default 'public',
  table_name    		character varying (255) not null,
  archive_id    		character varying(255) not null,
  archive_field 		character varying (255) not null,
  archive_batch_size		integer not null default 1000,
  archive_interval		integer not null, -- number of months or years to retain, days not currently supported
  archive_interval_type_id 	integer not null references dba.archive_interval_type(id),
  archive_interval_sleep	integer not null default 3,
  archive_type  		integer not null references dba.archive_type(id),
  run_order     		integer
);

-- remember to add unique constraint on (table_schema,table_name)
comment on column dba.table_archive_data.table_schema is 'Defaults to public, only specify if needed';
comment on column dba.table_archive_data.table_name is 'Name of table to be archived';
comment on column dba.table_archive_data.archive_id is 'This is the name of a unique or primary key field used to select rows in a sort based on the archive_field so archives can be done in batches';
comment on column dba.table_archive_data.archive_field is 'Name of field that will be used to partition or prune on';
comment on column dba.table_archive_data.archive_type is 'Uses lookup table dba.archive_type for values';



insert into dba.table_archive_data (
  table_name, 
  archive_id, 
  archive_field, 
  archive_batch_size, 
  archive_interval, 
  archive_interval_type_id,
  archive_type, 
  run_order) 
values (
  'sample_table',
  'id',
  'created_on',
  500,
  3,
  1,
  2,
  100
);



-- create logging table
create table dba.archive_logs (
  id 		   serial primary key,
  table_name 	   character varying (255) not null,
  batch_start_time timestamptz,
  batch_end_time   timestamptz,
  rows_archived	   integer not null,
  created_at       timestamptz DEFAULT CURRENT_TIMESTAMP
);


