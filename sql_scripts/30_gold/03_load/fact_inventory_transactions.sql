DROP TABLE IF EXISTS gold.fact_inventory_transactions;
CREATE TABLE gold.fact_inventory_transactions (
    source_id int NOT NULL,
    document_id bigint NOT NULL,
    product_id int NOT NULL,
    quantity numeric(24,4) NOT NULL,
    sale_amount numeric(24,2) NOT NULL,
    cost_amount numeric(24,2) NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now()
);

INSERT INTO gold.fact_inventory_transactions
SELECT
    i.source_id,
    d.document_id,
    i.product_code,
    i.quantity,
    i.sum_sale,
    i.sum_cost,
    md5(concat_ws('|',
        i.source_id,
        d.document_id,
        i.product_code
    )),
    now()
FROM silver.inventory_transactions_purchases i
JOIN gold.dim_documents d
  ON d.original_document_id = i.source_document_id
 AND d.document_type = 'purchase'

UNION ALL
SELECT
    i.source_id,
    d.document_id,
    i.product_code,
    i.quantity,
    i.sum_sale,
    i.sum_cost,
    md5(concat_ws('|',
        i.source_id,
        d.document_id,
        i.product_code
    )),
    now()
FROM silver.inventory_transactions_writeoffs i
JOIN gold.dim_documents d
  ON d.original_document_id = i.source_document_id
 AND d.document_type = 'writeoff'

UNION ALL
SELECT
    i.source_id,
    d.document_id,
    i.product_code,
    i.quantity,
    i.sum_sale,
    i.sum_cost,
    md5(concat_ws('|',
        i.source_id,
        d.document_id,
        i.product_code
    )),
    now()
FROM silver.inventory_transactions_sales i
JOIN gold.dim_documents d
  ON d.original_document_id = i.source_document_id
 AND d.document_type IN ('sale','order')

UNION ALL
SELECT
    i.source_id,
    d.document_id,
    i.product_code,
    i.quantity,
    i.sum_sale,
    i.sum_cost,
    md5(concat_ws('|',
        i.source_id,
        d.document_id,
        i.product_code
    )),
    now()
FROM silver.inventory_transactions_returns i
JOIN gold.dim_documents d
  ON d.original_document_id = i.source_document_id
 AND d.document_type = 'return';

