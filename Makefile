# =====================================================
# 🚀 DWH PLATFORM MAKEFILE
# =====================================================

.PHONY: help up down build bootstrap \
        platform bronze silver gold rebuild \
        psql logs status fix-perms

# =========================
# HELP
# =========================
help:
	@echo ""
	@echo "DWH PLATFORM COMMANDS"
	@echo "------------------------------"
	@echo "make up         - start platform (docker compose up -d)"
	@echo "make down       - stop platform"
	@echo "make build      - build postgres image"
	@echo "make bootstrap  - initial setup on new server"
	@echo ""
	@echo "DATA LAYERS"
	@echo "------------------------------"
	@echo "make platform   - init platform (FDW, extensions)"
	@echo "make bronze     - rebuild BRONZE layer"
	@echo "make silver     - rebuild SILVER layer"
	@echo "make gold       - rebuild GOLD layer"
	@echo "make rebuild    - FULL rebuild (platform + bronze + silver + gold)"
	@echo ""
	@echo "UTILS"
	@echo "------------------------------"
	@echo "make psql       - open psql shell"
	@echo "make logs       - tail last build logs"
	@echo "make status     - docker containers status"
	@echo "make fix-perms  - fix executable permissions"
	@echo ""

# =========================
# PLATFORM
# =========================
up:
	docker compose up -d --remove-orphans

down:
	docker compose down

build:
	docker compose build postgres

bootstrap:
	./scripts/bootstrap.sh

# =========================
# DATA LAYERS
# =========================
platform:
	./scripts/run_layer.sh platform

bronze:
	./scripts/run_layer.sh bronze

silver:
	./scripts/run_layer.sh silver

gold:
	./scripts/run_layer.sh gold

rebuild:
	./scripts/run_layer.sh all

# =========================
# UTILS
# =========================
psql:
	docker exec -it dwh-postgres psql -U dwh -d dwh

logs:
	@tail -n 50 logs/run_all.log 2>/dev/null || \
	echo "No logs yet"

status:
	docker ps

fix-perms:
	chmod +x scripts/*.sh || true
