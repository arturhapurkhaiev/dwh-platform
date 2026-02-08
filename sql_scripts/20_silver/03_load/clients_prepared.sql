INSERT INTO silver.clients_prepared (
    source_id,
    client_code,
    client_name,
    record_hash,
    load_dt
)
SELECT
    c.source_id,
    c.clients_code AS client_code,
    c.fio          AS client_name,
    md5(
        concat_ws(
            '|',
            c.source_id,
            c.clients_code,
            c.fio
        )
    )              AS record_hash,
    now()          AS load_dt
FROM bronze.clients c;
