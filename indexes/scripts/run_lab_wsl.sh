#!/usr/bin/env bash
# Recreate the MySQL container and volume, then load sql/01_setup.sql.
set -euo pipefail

cd "$(dirname "$0")/.."
DOCKER="${DOCKER:-docker}"

"$DOCKER" stop my-mysql >/dev/null 2>&1 || true
"$DOCKER" rm my-mysql >/dev/null 2>&1 || true
"$DOCKER" volume rm mysql_data >/dev/null 2>&1 || true

"$DOCKER" run --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=123 \
  -e LANG=C.UTF-8 \
  -e MYSQL_INITDB_SKIP_TZINFO=1 \
  -v mysql_data:/var/lib/mysql \
  -v "$(pwd)/my.cnf:/etc/mysql/conf.d/my.cnf" \
  -d mysql:8.0

for _ in $(seq 1 60); do
  if "$DOCKER" exec my-mysql mysqladmin ping -uroot -p123 --silent >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

"$DOCKER" exec -u mysql my-mysql sh -c ': > /var/lib/mysql/general.log'

"$DOCKER" exec -e MYSQL_PWD=123 my-mysql \
  mysql -uroot --default-character-set=utf8mb4 < sql/01_setup.sql
