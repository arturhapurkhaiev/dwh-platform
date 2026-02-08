INSERT INTO silver.categories_prepared (
    source_id,
    category_id,
    parent_category_id,
    category_name,
    parent_category_name,
    record_hash,
    load_dt
)
SELECT
    g.source_id,
    g.group_code                           AS category_id,
    NULLIF(g.parent_group_code, 0)         AS parent_category_id,
    g.gname                                AS category_name,
    pg.gname                               AS parent_category_name,
    md5(
        concat_ws(
            '|',
            g.source_id,
            g.group_code,
            NULLIF(g.parent_group_code, 0),
            g.gname,
            pg.gname
        )
    )                                      AS record_hash,
    now()                                  AS load_dt
FROM bronze.groups g
LEFT JOIN bronze.groups pg
    ON pg.group_code = g.parent_group_code
   AND pg.source_id = g.source_id;
