#!/usr/bin/env python3
"""Fail if executable code in this repository is not under version control.

Two incidents motivate this. A load-bearing analysis script sat untracked for
hours while its results were being relied on, and a subagent wrote an unwanted
checker straight into this public repository. Both are invisible to every other
gate here, which validate committed content and therefore cannot see a file
that was never committed.

Scope is deliberately narrow: executable code (*.py, *.sh) outside ignored
directories. Data, figures and build output are covered by other gates.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUFFIXES = {".py", ".sh"}
ALLOWED_UNTRACKED: set[str] = set()


def git(*args: str) -> list[str]:
    out = subprocess.check_output(["git", "-C", str(ROOT), *args], text=True)
    return [line for line in out.splitlines() if line.strip()]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="exit 1 on any finding")
    args = ap.parse_args()

    untracked = [p for p in git("ls-files", "--others", "--exclude-standard")
                 if Path(p).suffix in SUFFIXES and p not in ALLOWED_UNTRACKED]
    ignored = [p for p in git("ls-files", "--others", "--ignored", "--exclude-standard")
               if Path(p).suffix in SUFFIXES]
    tracked = [p for p in git("ls-files") if Path(p).suffix in SUFFIXES]

    print(f"tracked code files   : {len(tracked)}")
    print(f"untracked code files : {len(untracked)}")
    print(f"ignored code files   : {len(ignored)}")

    for path in untracked:
        print(f"  UNTRACKED {path}")
    for path in ignored:
        print(f"  IGNORED   {path}  (a .gitignore rule is hiding executable code)")

    failed = bool(untracked or ignored)
    if failed:
        print("\nExecutable code must be committed or explicitly removed.")
        print("If a file is genuinely scratch, delete it; do not leave it in the tree.")
    else:
        print("\nOK: all executable code is under version control")
    return 1 if (failed and args.check) else 0


if __name__ == "__main__":
    sys.exit(main())
