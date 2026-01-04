#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS_DIR = ROOT / "docs" / "results"
INDEX_MD = RESULTS_DIR / "index.md"

IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".gif"}
VIDEO_EXTS = {".mp4", ".webm", ".mov"}


def _rel_to_docs(path: Path) -> str:
    return path.relative_to(ROOT / "docs").as_posix()


def _iter_media() -> list[Path]:
    paths: list[Path] = []
    if not RESULTS_DIR.exists():
        return paths
    for path in RESULTS_DIR.rglob("*"):
        if not path.is_file():
            continue
        if path.name.startswith("."):
            continue
        if path.name.lower() == "index.md":
            continue
        if path.suffix.lower() in IMAGE_EXTS | VIDEO_EXTS:
            paths.append(path)
    return sorted(paths)


def main() -> None:
    media = _iter_media()
    if not RESULTS_DIR.exists():
        RESULTS_DIR.mkdir(parents=True, exist_ok=True)

    lines: list[str] = []
    lines.append("---")
    lines.append("title: Results")
    lines.append("---")
    lines.append("")
    lines.append("This page is auto-generated from files under `docs/results/`.")
    lines.append("")
    lines.append("Regenerate locally with:")
    lines.append("")
    lines.append("```bash")
    lines.append("python scripts/generate_gallery.py")
    lines.append("```")
    lines.append("")

    if not media:
        lines.append("_No media found yet._")
        lines.append("")
    else:
        # Group by immediate parent folder under docs/results/
        groups: dict[str, list[Path]] = {}
        for path in media:
            rel = path.relative_to(RESULTS_DIR)
            group = rel.parts[0] if len(rel.parts) > 1 else "(root)"
            groups.setdefault(group, []).append(path)

        for group in sorted(groups):
            title = "Root" if group == "(root)" else group
            lines.append(f"## {title}")
            lines.append("")
            for path in groups[group]:
                rel = _rel_to_docs(path)
                name = path.name
                ext = path.suffix.lower()
                lines.append(f"### `{name}`")
                lines.append("")
                lines.append(f"[Download]({rel})")
                lines.append("")
                if ext in IMAGE_EXTS:
                    lines.append(f'<img src="{rel}" alt="{name}" style="max-width: 900px; width: 100%;">')
                elif ext in VIDEO_EXTS:
                    lines.append(
                        f'<video controls preload="metadata" style="max-width: 900px; width: 100%;">'
                        f'<source src="{rel}">'
                        "Your browser does not support the video tag."
                        "</video>"
                    )
                lines.append("")

    INDEX_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote: {INDEX_MD}")
    print(f"media count: {len(media)}")


if __name__ == "__main__":
    main()

