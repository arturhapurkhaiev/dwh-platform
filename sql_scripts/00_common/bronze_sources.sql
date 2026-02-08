CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.sources (
    source_id        INT PRIMARY KEY,
    source_name      TEXT NOT NULL,
    source_type      TEXT NOT NULL,
    source_host      TEXT NOT NULL,
    source_database  TEXT NOT NULL,
    created_at       TIMESTAMP NOT NULL DEFAULT now()
);

INSERT INTO bronze.sources (
    source_id,
    source_name,
    source_type,
    source_host,
    source_database
)
VALUES (
    1,
    'MiniSoft',
    'ms_sql_server',
    '10.0.1.43',
    'minisoft2'
)
ON CONFLICT (source_id) DO NOTHING;
