INSERT INTO gold.fact_financial_flow (
    source_id,
    document_id,
    product_id,
    quantity,
    net_amount,
    discount_amount,
    cost_amount,
    profit_amount,
    record_hash,
    load_dt
)

-- =========================
-- SALES / ORDERS
-- =========================
SELECT
    f.source_id,
    d.document_id,
    f.product_id,
    f.quantity,
    f.net_sale,
    f.discount_amount,
    f.cost_amount,
    f.profit_amount,
    md5(concat_ws('|',
        f.source_id,
        d.document_id,
        f.product_id,
        f.sales_id
    )),
    now()
FROM silver.financial_flow_sales f
JOIN gold.dim_documents d
    ON d.source_id = f.source_id
   AND d.original_document_id = f.sales_id::text
   AND d.document_type IN ('sale','order')

UNION ALL

-- =========================
-- RETURNS
-- =========================
SELECT
    r.source_id,
    d.document_id,
    r.product_id,
    -r.quantity,
    -r.net_sale,
    0,
--r.discount_amount,
    -r.cost_amount,
    -r.profit_amount,
    md5(concat_ws('|',
        r.source_id,
        d.document_id,
        r.product_id,
        r.return_id
    )),
    now()
FROM silver.financial_flow_returns r
JOIN gold.dim_documents d
    ON d.source_id = r.source_id
   AND d.original_document_id = r.return_id::text
   AND d.document_type = 'return';
