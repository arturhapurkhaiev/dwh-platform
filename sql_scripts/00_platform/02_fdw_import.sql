-- ==================================
-- FDW IMPORT (SOURCE CONTRACT)
-- RUN ONLY ON FIRST INIT OR MANUALLY
-- ==================================

IMPORT FOREIGN SCHEMA dbo
LIMIT TO (
  clients,
  groups,
  postavschiki,
  prihod,
  prihod_naklad,
  product,
  pereocenka,
  pereocenka_product,
  sales,
  sales_product,
  users
)
FROM SERVER minisoft_mssql
INTO mssql;
-- ==================================
-- FDW IMPORT (SOURCE CONTRACT)
-- RUN ONLY ON FIRST INIT OR MANUALLY
-- ==================================

IMPORT FOREIGN SCHEMA dbo
LIMIT TO (
  clients,
  groups,
  postavschiki,
  prihod,
  prihod_naklad,
  product,
  pereocenka,
  pereocenka_product,
  sales,
  sales_product,
  users
)
FROM SERVER minisoft_mssql
INTO mssql;
