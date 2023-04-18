CREATE TABLE sample_table (
    id bigserial primary key,
    unique_slug character varying(50) UNIQUE NOT NULL,
    created_at timestamp with time zone NOT NULL
);

create index sample_table_unique_slug_idx on sample_table(unique_slug);
create index sample_table_created_on_idx on sample_table(created_at);
