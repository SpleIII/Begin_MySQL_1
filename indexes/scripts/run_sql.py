#!/usr/bin/env python3
"""Run SQL files through the mysql client.

By default the local mysql client is used (Windows/Linux). Set
MYSQL_CONTAINER=my-mysql to run through `docker exec` instead.

Environment variables:
    MYSQL_BIN            path to mysql client (default: mysql)
    MYSQL_DEFAULTS_FILE  defaults file (default: ../my.local.ini)
    MYSQL_CONTAINER      Docker container name (optional)
    MYSQL_PWD            password (default: 123)
"""
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def mysql_command() -> list[str]:
    password = os.environ.get("MYSQL_PWD", "123")
    container = os.environ.get("MYSQL_CONTAINER")
    if container:
        return [
            "docker", "exec", "-i", "-e", f"MYSQL_PWD={password}",
            container, "mysql", "-uroot",
            "--default-character-set=utf8mb4", "--table",
        ]

    mysql = os.environ.get("MYSQL_BIN", "mysql")
    defaults = os.environ.get(
        "MYSQL_DEFAULTS_FILE", str(ROOT.parent / "my.local.ini")
    )
    return [
        mysql, f"--defaults-file={defaults}", "-uroot",
        "--default-character-set=utf8mb4", "--table",
    ]


def main() -> int:
    if len(sys.argv) < 2:
        print(
            "Usage: python scripts/run_sql.py <sql-file> [<sql-file> ...]",
            file=sys.stderr,
        )
        return 2

    env = os.environ.copy()
    env.setdefault("MYSQL_PWD", "123")

    for name in sys.argv[1:]:
        path = Path(name)
        result = subprocess.run(mysql_command(), input=path.read_bytes(), env=env)
        if result.returncode:
            return result.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
