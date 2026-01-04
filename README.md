# Chemataxis Numerics

Numerical results (figures and videos) accompanying our chemotaxis papers.

**GitHub Pages**
- This repo is prepared to publish via GitHub Pages from the `docs/` folder.
- In GitHub: Settings → Pages → Build and deployment → Deploy from a branch → `master` / `docs`.

**Where to put outputs**
- Put publishable media under `docs/results/` so it is served by Pages.
- Update the gallery page with `python scripts/generate_gallery.py`.
- For large binaries (especially `*.mp4`), use Git LFS (see below).

**Git LFS (recommended for videos)**
```bash
git lfs install
git lfs track "*.mp4" "*.npz"
git add .gitattributes
```
