#!/usr/bin/env python3
"""Filter MySQL general log down to user SQL actions.

Usage:
    python scripts/filter_general_log.py <general.log> <my_actions.log>
"""
import re
import sys
from pathlib import Path


RECORD = re.compile(
    r"^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}(?:\.\d+)?"
    r"(?:Z|[+-]\d{2}:\d{2})?\s+\d+\s+([A-Za-z]+)\s+(.*)$"
)
ALLOWED = re.compile(
    r"^(CREATE|INSERT|SELECT|UPDATE|DELETE|ALTER|DROP|RENAME|"
    r"DESCRIBE|DESC|EXPLAIN|SHOW|USE|SET)\b",
    re.IGNORECASE,
)
INTERNAL = re.compile(
    r"^(SET NAMES|SET AUTOCOMMIT|SET SQL_MODE|SET CHARACTER_SET_RESULTS|"
    r"SET GLOBAL|SELECT \* FROM MYSQL\.GENERAL_LOG|"
    r"SELECT @@VERSION_COMMENT|SELECT DATABASE)\b",
    re.IGNORECASE,
)


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "Usage: python scripts/filter_general_log.py <general.log> <my_actions.log>",
            file=sys.stderr,
        )
        return 2

    source = Path(sys.argv[1])
    target = Path(sys.argv[2])
    kept: list[str] = []
    keep_continuation = False

    for line in source.read_text(encoding="utf-8-sig", errors="replace").splitlines():
        match = RECORD.match(line)
        if match:
            command, argument = match.groups()
            argument = argument.strip()
            keep_continuation = (
                command.upper() in {"QUERY", "EXECUTE"}
                and bool(ALLOWED.match(argument))
                and not bool(INTERNAL.match(argument))
                and "INSERT INTO HELP_" not in argument.upper()
                and "INSERT INTO TIME_ZONE" not in argument.upper()
                and "INSERT INTO MYSQL." not in argument.upper()
            )
            if keep_continuation:
                kept.append(line)
        elif keep_continuation and line.strip():
            kept.append(line)

    if not kept:
        print(f"No user SQL actions found in {source}", file=sys.stderr)
        return 1

    target.write_text("\n".join(kept) + "\n", encoding="utf-8", newline="\n")
    print(f"Wrote {len(kept)} lines to {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
