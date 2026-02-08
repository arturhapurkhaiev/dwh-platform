INSERT INTO silver.products_prepared (
    source_id,
    product_id,
    product_name,
    category_id,
    sale_price,
    cost_price,
    quantity,
    is_active,
    record_hash,
    load_dt
)
SELECT
    p.source_id,
    p.product_code                  AS product_id,
    p.pname                         AS product_name,
    p.group_code                    AS category_id,
    p.cena                          AS sale_price,
    p.cenapost                      AS cost_price,
    p.kolvo                         AS quantity,
    NOT p.disable                   AS is_active,
    md5(
        concat_ws(
            '|',
            p.source_id,
            p.product_code,
            p.pname,
            p.group_code,
            p.cena,
            p.cenapost,
            NOT p.disable
        )
    )                               AS record_hash,
    now()                           AS load_dt
FROM bronze.product p;
