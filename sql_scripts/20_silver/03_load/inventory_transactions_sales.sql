DROP TABLE IF EXISTS silver.inventory_transactions_sales;
CREATE TABLE silver.inventory_transactions_sales (
    source_id int NOT NULL,
    source_document_id text NOT NULL,
    event_dt timestamp NOT NULL,
    product_code int NOT NULL,
    quantity numeric(24,4) NOT NULL,
    sum_sale numeric(24,2) NOT NULL,
    sum_cost numeric(24,2) NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now()
);

INSERT INTO silver.inventory_transactions_sales
SELECT
    s.source_id,
    s.sales_code::text,
    s.dates,
    sp.product_code,
    ROUND(-sp.colvo, 4),
    ROUND(-sp.colvo * sp.cena, 2),
    ROUND(
        -ROUND(
            sp.cena::numeric / (1 + sp.nacenka::numeric / 100),
            2
        ) * sp.colvo::numeric,
        2
    ),
    md5(concat_ws('|',
        s.source_id,
        s.sales_code,
        'sale',
        sp.product_code
    )),
    now()
FROM bronze.sales s
JOIN bronze.sales_product sp
  ON sp.sales_code = s.sales_code
WHERE s.deleted = false;
