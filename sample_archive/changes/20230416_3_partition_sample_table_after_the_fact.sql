-- Below we will change the table to utilize partitions in a live way and then will set up pg_partman
-- to manage future paritition creation
-- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL_Partitions.html

-- for a more hands on approach, check out the youtube video I learned this strategy from:
-- https://www.youtube.com/watch?v=edQZauVU-ws

-- make sure to check max/min values for date range to ensure there is no data out of bounds and that there are no null values.

-- if running manually, you will want to do this in a transaction. My deployment tool wraps
-- things in a transaction for me unless transactional boundaries are found in the file it is deploying

-- another helpful link on postgres partitioning
-- https://alexey-soshin.medium.com/dealing-with-partitions-in-postgres-11-fa9cc5ecf466



-- start by adding a unique index on your primary key and range partition field, do this ahead of time.
create unique index concurrently if not exists sample_table_future_pk on sample_table(id, created_at);


begin;
alter table sample_table rename to sample_table_legacy;

alter index sample_table_pkey rename to sample_table_legacy_pkey;
alter index sample_table_created_on_idx rename to sample_table_legacy_created_on_idx;
alter index sample_table_slug_address_idx rename to sample_table_legacy_slug_address_idx;
alter table sample_table_legacy drop constraint sample_table_legacy_pkey;
alter index sample_table_future_pk rename to sample_table_legacy_future_pk;
alter table sample_table_legacy add constraint sample_table_legacy_pkey primary key using index sample_table_legacy_future_pk;

CREATE TABLE sample_table (
  id bigint NOT NULL DEFAULT nextval('sample_table_id_seq'::regclass) ,
  slug_address character varying(50) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  primary key (id, created_at)
)
partition by range(created_at);

create index sample_table_slug_address_idx on sample_table(slug_address);
create index sample_table_created_on_idx on sample_table(created_at);


-- create partition for new data. Use a future day/month for the start/end values that is not in the current data set.
create table sample_table_p20230501
partition of sample_table
for values from ('2023-05-01') to ('2023-06-01');


do $$
declare 
  earliest_date date;
  latest_date date;
  alter_table_query text;
  partition_table_query text;
begin
  select min(created_at) into earliest_date from sample_table_legacy;
  latest_date := '2023-05-01'::date;

  -- this is the hacky part. We are validating that the data is good on our own and ensuring that the database doesn't scan all the data.
  alter_table_query := format ('
    alter table sample_table_legacy
    add constraint sample_table_created_at
      check (created_at >= ''%1$s'' and created_at <'' %2$s'')
      not valid;
  ',earliest_date,latest_date);

  execute alter_table_query;

  update pg_constraint set convalidated = true where conname = 'sample_table_legacy_created_at';

  partition_table_query := format('
  alter table sample_table
    attach partition sample_table_legacy
    for values from (''%1$s'') to (''%2$s'') 
  ',earliest_date,latest_date);

  execute partition_table_query;


end;
$$ language plpgsql;
commit;









