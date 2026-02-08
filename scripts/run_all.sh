#!/usr/bin/env bash

# =====================================================
# 🚀 DWH FULL REBUILD SCRIPT (WITH FDW & ERROR HANDLING)
# =====================================================

set -eE
trap 'on_error $LINENO' ERR

# =========================
# ⚙️ CONFIG
# =========================
PG_CONTAINER="dwh-postgres"
PG_DB="dwh"
PG_USER="dwh"

ROOT_DIR="/opt/dwh/sql_scripts"
LOG_FILE="/opt/dwh/logs/run_all.log"

DB_CMD="docker exec -i ${PG_CONTAINER} psql \
  -U ${PG_USER} \
  -d ${PG_DB} \
  -v ON_ERROR_STOP=1 \
  -v client_min_messages=WARNING"

START_TS=$(date +%s)
STEP=1
CURRENT_FILE=""

# clean log
: > "$LOG_FILE"

# =========================
# 🪵 LOGGING
# =========================
log() {
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] $1"
}

# =========================
# ❌ ERROR HANDLER
# =========================
on_error() {
  local line=$1
  echo
  echo "=============================="
  echo "❌ DWH BUILD FAILED"
  echo "📍 Script line : $line"
  echo "📄 SQL file   : ${CURRENT_FILE:-unknown}"
  echo "=============================="
  echo
  echo "🪵 Last 50 log lines:"
  echo "------------------------------"
  tail -n 50 "$LOG_FILE"
  echo "=============================="
  exit 1
}

# =========================
# 📊 PROGRESS BAR
# =========================
progress_bar() {
  local step=$1
  local total=$2
  local label=$3

  local width=30
  local percent=$(( step * 100 / total ))
  (( percent > 100 )) && percent=100

  local filled=$(( percent * width / 100 ))
  local empty=$(( width - filled ))

  printf "\r["
  printf "%0.s█" $(seq 1 $filled)
  printf "%0.s░" $(seq 1 $empty)
  printf "] %3d%% %s" "$percent" "$label"
}

# =========================
# ▶️ RUN SINGLE SQL FILE
# =========================
run_sql() {
  local label=$1
  local file=$2

  CURRENT_FILE="$file"

  progress_bar "$STEP" "$TOTAL_FILES" "$label"
  local t0=$(date +%s)

  $DB_CMD < "$file" >>"$LOG_FILE" 2>&1

  local t1=$(date +%s)
  printf "  ⏱ %ds\n" $((t1 - t0))

  STEP=$((STEP + 1))
}

# =========================
# 📂 RUN DIRECTORY
# =========================
run_dir() {
  local title=$1
  local dir=$2

  log "📂 $title"

  for file in $(ls "$dir"/*.sql 2>/dev/null | sort); do
    run_sql "$(basename "$file")" "$file"
  done
}

# =========================
# ⏳ WAIT FOR POSTGRES
# =========================
log "⏳ Waiting for Postgres..."

until docker exec "$PG_CONTAINER" pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; do
  sleep 2
done

log "✅ Postgres is ready"

# =========================
# 🔌 FDW PLATFORM INIT
# =========================
log "🔌 Initializing FDW (platform layer)"

CURRENT_FILE="00_platform/fdw_init.sql"
$DB_CMD < "$ROOT_DIR/00_platform/fdw_init.sql" >>"$LOG_FILE" 2>&1

# =========================
# 🔥 HARD RESET BUSINESS SCHEMAS
# =========================
log "🔥 Dropping & recreating Bronze / Silver / Gold"

CURRENT_FILE="SCHEMA RESET"

$DB_CMD <<'SQL' >>"$LOG_FILE" 2>&1
DROP SCHEMA IF EXISTS gold CASCADE;
DROP SCHEMA IF EXISTS silver CASCADE;
DROP SCHEMA IF EXISTS bronze CASCADE;

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
SQL

# =========================
# 📦 COUNT TOTAL SQL FILES
# =========================
TOTAL_FILES=$(find "$ROOT_DIR" -type f -name "*.sql" \
  ! -path "$ROOT_DIR/00_platform/*" | wc -l)

echo
echo "=============================="
echo "🔄 FULL DWH REBUILD STARTED"
echo "📊 Progress:"
echo "=============================="

# =========================
# 00 — COMMON
# =========================
run_dir "00_common" "$ROOT_DIR/00_common"

# =========================
# 10 — BRONZE
# =========================
run_dir "10_bronze / DDL"  "$ROOT_DIR/10_bronze/01_ddl"
run_dir "10_bronze / LOAD" "$ROOT_DIR/10_bronze/03_load"

# =========================
# 20 — SILVER
# =========================
run_dir "20_silver / DDL"  "$ROOT_DIR/20_silver/01_ddl"
run_dir "20_silver / LOAD" "$ROOT_DIR/20_silver/03_load"

# =========================
# 30 — GOLD
# =========================
run_dir "30_gold / DDL"    "$ROOT_DIR/30_gold/01_ddl"
run_dir "30_gold / LOAD"   "$ROOT_DIR/30_gold/03_load"

END_TS=$(date +%s)

echo
echo "=============================="
echo "✅ FULL DWH REBUILD FINISHED"
echo "⏱ Total time: $((END_TS - START_TS))s"
echo "=============================="

# =========================
# ⚠️ WARNINGS / ERRORS SUMMARY
# =========================
echo
echo "=============================="
echo "⚠️ WARNINGS / ERRORS SUMMARY"
echo "=============================="

if grep -E "WARNING|ERROR" "$LOG_FILE" >/dev/null; then
  grep -E "WARNING|ERROR" "$LOG_FILE"
else
  echo "✅ No warnings or errors"
fi
