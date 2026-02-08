INSERT INTO gold.dim_categories (
    source_id,
    category_id,
    parent_category_id,
    category_name,
    record_hash,
    load_dt
)
SELECT
    c.source_id,
    c.category_id,
    c.parent_category_id,
    c.category_name,
    c.record_hash,
    now() AS load_dt
FROM silver.categories_prepared c;

