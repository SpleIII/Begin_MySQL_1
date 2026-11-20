#!/usr/bin/env bash
# Source this file inside WSL to use Docker Desktop's CLI and the lab password.
#
#   source scripts/wsl_aliases.sh
#   docker ps

export MYSQL_PWD="${MYSQL_PWD:-123}"

if [ -z "${DOCKER:-}" ]; then
  for candidate in \
    "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe" \
    "/mnt/c/Users/$USER/AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe"
  do
    if [ -x "$candidate" ]; then
      DOCKER="$candidate"
      break
    fi
  done
fi

DOCKER="${DOCKER:-docker}"

docker() {
  "$DOCKER" "$@"
}
