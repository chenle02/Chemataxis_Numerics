---
title: Chemataxis Numerics
---

This site hosts numerical results (figures and videos) accompanying our chemotaxis papers.

## Results

- Browse: `docs/results/`
- Gallery page: `docs/results/index.md` (auto-generated)

## Upload workflow

1. Copy new media into `docs/results/` (use subfolders per experiment if you like).
2. Regenerate the gallery page:
   ```bash
   python scripts/generate_gallery.py
   ```
3. Commit and push to GitHub.
4. GitHub Pages serves everything under `docs/`.

## Notes on large files

GitHub has a hard limit of 100MB per file in normal Git. For videos, use Git LFS:

```bash
git lfs install
git lfs track "*.mp4" "*.mov" "*.npz"
git add .gitattributes
```
