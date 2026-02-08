CREATE TABLE IF NOT EXISTS bronze.pereocenka_product (
    source_id int NOT NULL,
    pereocenka_product_code int NOT NULL,
    pereocenka_code int NOT NULL,
    product_code int NOT NULL,
    old_cena numeric(24,2) NULL,
    new_cena numeric(24,2) NOT NULL,
    perc double precision NULL,
    pname text NULL,
    kolvo numeric(24,4) NULL,
    old_optcena numeric(24,2) NULL,
    new_optcena numeric(24,2) NULL,
    optperc double precision NULL,
    old_postavcena numeric(24,2) NULL,
    new_postavcena numeric(24,2) NULL,
    postavperc double precision NULL,
    load_dt timestamp NOT NULL
);
