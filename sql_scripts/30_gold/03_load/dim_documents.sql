INSERT INTO gold.dim_documents (
    source_id,
    document_type,
    original_document_id,
    original_table,
    event_dt,
    user_id,
    business_entity_id,
    record_hash,
    load_dt
)
SELECT
    d.source_id,
    d.document_type,
    d.original_document_id,
    d.original_table,
    d.event_dt,
    d.user_id,
    be.business_entity_id,
    md5(concat_ws('|',
        d.source_id,
        d.original_table,
        d.original_document_id,
        d.document_type,
        d.event_dt,
        d.user_id,
        be.business_entity_id
    )),
    now()
FROM silver.documents d
LEFT JOIN gold.dim_business_entity be
    ON be.source_id = d.source_id
   AND be.business_entity_type = d.business_entity_type
   AND be.original_entity_id = d.original_business_entity_id;
