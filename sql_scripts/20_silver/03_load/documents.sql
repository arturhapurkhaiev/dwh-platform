INSERT INTO silver.documents (
    source_id,
    document_type,
    original_document_id,
    original_table,
    event_dt,
    user_id,
    business_entity_type,
    original_business_entity_id,
    record_hash,
    load_dt
)
SELECT
    s.source_id,
    CASE
        WHEN s.ispayed THEN 'sale'
        ELSE 'order'
    END                         AS document_type,
    s.sales_code::text          AS original_document_id,
    'sales'                    AS original_table,
    s.dates                    AS event_dt,
    s.users_id                 AS user_id,
    'client'                   AS business_entity_type,
    s.clients_code             AS original_business_entity_id,
    md5(concat_ws('|',
        s.source_id,
        'sales',
        s.sales_code,
        s.dates,
        s.users_id,
        s.clients_code,
        s.ispayed
    )),
    now()
FROM bronze.sales s

UNION ALL

SELECT
    p.source_id,
    CASE
        WHEN p.type = 0      THEN 'purchase'
        WHEN p.type IN (1,3) THEN 'writeoff'
        WHEN p.type = 2      THEN 'return'
    END,
    p.prihod_code::text,
    'prihod',
    p.odate,
    p.prihoduser,
    CASE
        WHEN p.type IN (0,1,3) THEN 'supplier'
        ELSE 'client'
    END,
    CASE
        WHEN p.type IN (0,1,3) THEN p.postav_code
        ELSE s.clients_code
    END,
    md5(concat_ws('|',
        p.source_id,
        'prihod',
        p.prihod_code,
        p.type,
        p.odate,
        p.prihoduser,
        CASE
            WHEN p.type IN (0,1,3) THEN p.postav_code
            ELSE s.clients_code
        END
    )),
    now()
FROM bronze.prihod p
LEFT JOIN bronze.sales s
    ON p.type = 2
   AND s.sales_code = p.prihod_code
WHERE p.odate IS NOT NULL;
