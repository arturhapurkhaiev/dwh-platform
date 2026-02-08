CREATE TABLE IF NOT EXISTS bronze.groups (
    source_id int NOT NULL,
    group_code int NOT NULL,
    gname text NULL,
    parent_group_code int NOT NULL,
    uktzed text NULL,
    load_dt timestamp NOT NULL
);
