#!/usr/bin/env python3
"""Rank MT5 optimization exports without inventing backtest results.

The script accepts CSV exports whose column labels contain common English MT5
names. It writes candidates that pass the hard filters, ranked by a robust score.
"""
from __future__ import annotations

import csv
import math
import sys
from pathlib import Path


ALIASES = {
    "profit": ("profit", "net profit", "result"),
    "pf": ("profit factor", "pf"),
    "dd": ("equity dd %", "drawdown %", "dd%", "drawdown"),
    "trades": ("trades", "total trades", "deals"),
}


def find_column(fieldnames: list[str], aliases: tuple[str, ...]) -> str:
    normalized = {name.strip().lower(): name for name in fieldnames}
    for alias in aliases:
        if alias in normalized:
            return normalized[alias]
    for normalized_name, original in normalized.items():
        if any(alias in normalized_name for alias in aliases):
            return original
    raise KeyError(f"Column not found. Expected one of: {', '.join(aliases)}")


def number(value: str) -> float:
    cleaned = value.strip().replace("%", "").replace(" ", "")
    if cleaned.count(",") == 1 and cleaned.count(".") == 0:
        cleaned = cleaned.replace(",", ".")
    else:
        cleaned = cleaned.replace(",", "")
    return float(cleaned)


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: score_optimization.py INPUT.csv OUTPUT.csv", file=sys.stderr)
        return 2
    source, target = map(Path, sys.argv[1:])
    with source.open("r", encoding="utf-8-sig", newline="") as handle:
        sample = handle.read(4096)
        handle.seek(0)
        dialect = csv.Sniffer().sniff(sample, delimiters=",;\t")
        reader = csv.DictReader(handle, dialect=dialect)
        if not reader.fieldnames:
            raise ValueError("CSV has no header")
        columns = {key: find_column(reader.fieldnames, aliases) for key, aliases in ALIASES.items()}
        accepted = []
        for row in reader:
            profit = number(row[columns["profit"]])
            pf = number(row[columns["pf"]])
            dd = number(row[columns["dd"]])
            trades = number(row[columns["trades"]])
            if profit <= 0 or pf < 1.20 or dd > 30.0 or trades < 60:
                continue
            score = profit * min(pf, 3.0) * math.sqrt(trades) / (1.0 + dd * dd)
            row["AtlasScore"] = f"{score:.8f}"
            accepted.append(row)
    accepted.sort(key=lambda row: float(row["AtlasScore"]), reverse=True)
    fields = list(reader.fieldnames) + ["AtlasScore"]
    with target.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows(accepted)
    print(f"Wrote {len(accepted)} accepted candidates to {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
