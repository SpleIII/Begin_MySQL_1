#!/usr/bin/env bash
# Check that the container is running and show the first EXPLAIN.
set -euo pipefail

cd "$(dirname "$0")/.."
source scripts/wsl_aliases.sh

docker ps --filter name=my-mysql --format '{{.Names}} {{.Status}}'
docker exec -e MYSQL_PWD="$MYSQL_PWD" my-mysql mysql -uroot --table -D index_practice \
  -e "EXPLAIN SELECT * FROM orders WHERE amount > 1000;"
