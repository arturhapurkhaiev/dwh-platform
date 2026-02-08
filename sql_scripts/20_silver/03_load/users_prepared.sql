INSERT INTO silver.users_prepared (
    user_id,
    user_name,
    source_id,
    record_hash
)
SELECT
    u.users_code        AS user_id,
    u.name              AS user_name,
    u.source_id,
    md5(
        concat_ws(
            '|',
            u.source_id,
            u.users_code,
            u.name
        )
    )                   AS record_hash
FROM bronze.users u;
