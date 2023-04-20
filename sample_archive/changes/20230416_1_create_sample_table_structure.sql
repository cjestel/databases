CREATE TABLE sample_table (
    id bigserial primary key,
    slug_address character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL
);

create index sample_table_slug_address_idx on sample_table(slug_address);
create index sample_table_created_on_idx on sample_table(created_at);
