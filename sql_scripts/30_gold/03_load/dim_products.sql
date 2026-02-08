INSERT INTO gold.dim_products (
    source_id,
    product_id,
    product_name,
    category_id,
    record_hash,
    load_dt
)
SELECT
    p.source_id,
    p.product_id,
    p.product_name,
    p.category_id,
    p.record_hash,
    now()
FROM silver.products_prepared p;
