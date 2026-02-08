INSERT INTO bronze.groups (
    source_id,
    group_code,
    gname,
    parent_group_code,
    uktzed,
    load_dt
)
SELECT
    1 AS source_id,
    group_code,
    gname,
    parent_group_code,
    uktzed,
    now() AS load_dt
FROM mssql.groups;
