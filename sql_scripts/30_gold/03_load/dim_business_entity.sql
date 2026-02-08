INSERT INTO gold.dim_business_entity (
    source_id,
    business_entity_type,
    original_entity_id,
    business_entity_name,
    record_hash,
    load_dt
)
-- CLIENTS
SELECT
    c.source_id,
    'client'                    AS business_entity_type,
    c.client_code         AS original_entity_id,
    c.client_name               AS business_entity_name,
    c.record_hash,
    now()
FROM silver.clients_prepared c
UNION ALL
-- SUPPLIERS
SELECT
    p.source_id,
    'supplier'                  AS business_entity_type,
    p.postav_code         AS original_entity_id,
    p.postav_name               AS business_entity_name,
    p.record_hash,
    now()
FROM silver.postavschiki_prepared p;
