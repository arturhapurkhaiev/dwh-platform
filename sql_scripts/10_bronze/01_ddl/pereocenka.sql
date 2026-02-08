CREATE TABLE IF NOT EXISTS bronze.pereocenka (
    source_id int NOT NULL,
    pereocenka_code int NOT NULL,
    pdate timestamp NULL,
    users_code int NOT NULL,
    psumma numeric(24,2) NOT NULL,
    other text NULL,
    optpsumma numeric(24,2) NULL,
    postavsumma numeric(24,2) NULL,
    load_dt timestamp NOT NULL
);
