INSERT INTO gold.dim_users (
    source_id,
    user_id,
    user_name,
    record_hash,
    load_dt
)
SELECT
    u.source_id,
    u.user_id,
    u.user_name,
    u.record_hash,
    now()
FROM silver.users_prepared u;
