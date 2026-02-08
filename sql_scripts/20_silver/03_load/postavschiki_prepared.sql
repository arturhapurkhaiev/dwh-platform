INSERT INTO silver.postavschiki_prepared (
    source_id,
    postav_code,
    postav_name,
    record_hash,
    load_dt
)
SELECT
    p.source_id,
    p.postav_code,
    p.postav_name,
    md5(
        concat_ws(
            '|',
            p.source_id,
            p.postav_code,
            p.postav_name
        )
    ) AS record_hash,
    now() AS load_dt
FROM bronze.postavschiki p;
