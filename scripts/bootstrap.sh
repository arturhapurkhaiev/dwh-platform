#!/usr/bin/env bash

# =====================================================
# 🚀 DWH BOOTSTRAP SCRIPT (IDEMPOTENT)
# One command to reproduce EVERYTHING on a new server
# =====================================================

set -e

PG_CONTAINER="dwh-postgres"
PG_DB="dwh"
PG_USER="dwh"

echo "🚀 DWH BOOTSTRAP STARTED"

# =========================
# 1. START PLATFORM
# =========================
echo "🐳 Starting Docker services..."
docker compose up -d --remove-orphans

# =========================
# 2. WAIT FOR POSTGRES
# =========================
echo "⏳ Waiting for Postgres..."
until docker exec "$PG_CONTAINER" pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; do
  sleep 2
done
echo "✅ Postgres is ready"

# =========================
# 3. FDW IMPORT (SAFE / IDEMPOTENT)
# =========================
echo "🔗 Checking FDW foreign tables..."

FT_COUNT=$(docker exec -i "$PG_CONTAINER" psql -U "$PG_USER" -d "$PG_DB" -tAc \
"SELECT COUNT(*) FROM information_schema.foreign_tables WHERE foreign_table_schema = 'mssql';")

if [ "$FT_COUNT" -eq 0 ]; then
  echo "➡️  No foreign tables found, importing FDW schema..."
  docker exec -i "$PG_CONTAINER" psql -U "$PG_USER" -d "$PG_DB" \
    < sql_scripts/00_platform/fdw_import.sql
  echo "✅ FDW import completed"
else
  echo "⏭️  Foreign tables already exist ($FT_COUNT), skipping FDW import"
fi

# =========================
# 4. BUILD DWH
# =========================
echo "🏗 Running full DWH rebuild"
./run_all.sh

echo "✨ DWH BOOTSTRAP FINISHED"
