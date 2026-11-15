# Python version management policy

Settled 2026-07-09 (Notion: "Settle Python version management" task). One
deterministic answer to "what does `python3` mean on this machine," enforced by
these dotfiles. The "Modernize dotfiles" Notion project swapped the tools
(native arm64 Homebrew → mise → uv, finished 2026-11-15); the layer model
itself has stayed the same since July.

## The layer model — one owner per layer

| Layer | Owner | Rule |
|---|---|---|
| Interpreters | **mise** | `python3` in a shell always resolves to mise's active Python. Global default: `config/mise/config.toml` (3.11). Projects pin with `.python-version` (or `mise.toml`). uv uses these interpreters (`config/uv/uv.toml`: `python-preference = "system"`) and downloads its own only when nothing installed fits. |
| Project packages | **uv** | Every project is a uv project: `uv init` / `uv add`, a committed `uv.lock`, and a `.venv` uv manages. mise creates and activates that `.venv` on `cd` (`python.uv_venv_auto`); `uv sync` (or any `uv run`) installs the packages into it. Older requirements.txt projects: `uv venv && uv pip install -r requirements.txt`. Never `pip install` outside a venv. |
| One-off scripts | **uv run** | A script declares its libraries in a PEP 723 header (`uv add --script foo.py lib`) and runs with `uv run foo.py`, or directly via the shebang `#!/usr/bin/env -S uv run --script`. |
| Global CLI tools | **uv tool** | `uv tool install <tool>` (or `-e <checkout>` for your own). Each tool gets its own environment; its commands land in `~/.local/bin`. One-shot use: `uvx <tool>` (e.g. `uvx poetry` for a poetry project you don't own). |
| Global Python's own packages | **just pynvim** | Neovim's Python provider imports it from `python3`. Nothing else goes in the global interpreter. |
| Homebrew's pythons | **Homebrew, internally** | Exist only as dependency plumbing for formulas (gcloud, vim, mpv, …). Kept **unlinked** (`brew unlink python@X.Y`) so they never appear in `/opt/homebrew/bin`. Never `pip install` into them. Dependents use `/opt/homebrew/opt/...` paths, so unlinking breaks nothing. |
| System python | **Apple** | `/usr/bin/python3` — never modify, never pip install. Deliberate fallback for macOS-integrated one-offs (e.g. `plistlib`-heavy scripts); it is the only interpreter guaranteed consistent with OS libraries. |

## Known hazards this policy prevents

- **2026-07-09 incident:** `/usr/local/bin/python3` pointed at brew `python@3.14`
  whose `pyexpat` was broken against the OS `libexpat` (`import plistlib` →
  `ImportError`). Anything not going through the managed python3 hit it. Fix: brew
  pythons stay unlinked.
- `brew upgrade` may **relink** a python formula and recreate
  `/opt/homebrew/bin/python3`. Harmless for interactive shells (mise wins), but
  run `python-doctor` after brew upgrades; it warns loudly if this happened.

## Machine context

Native arm64 since 2026-11. Since 2026-11-15 interpreters come from mise as
prebuilt python-build-standalone binaries (no compiling; they bundle their own
OpenSSL).

The global Python used to carry apps and libraries too. On 2026-11-15 they
moved, at identical versions:
- vocabsieve and boox-mokuro (with mokuro and manga_ocr) became editable
  `uv tool`s of `~/dev/projects/anki_projects/vocabsieve` and
  `~/dev/projects/boox-mokuro`. boox-mokuro's environment carries
  setuptools 79, because mokuro still imports `pkg_resources`.
- anthropic and genanki moved into `build_deck.py`'s inline header (in the
  1100-Korean-phrases project). openpyxl, pyobjc and typer had no remaining
  users; add them to a script's header when one needs them.
- pipx and its dead poetry were removed. yt-to-anki (an upstream clone that
  uses poetry) can run with `uvx poetry`.

Before that, pyenv compiled interpreters against `/opt/homebrew` with brew
`openssl@3` (brew's plain `openssl` is OpenSSL 4).

Until 2026-11-13 the interpreters were x86_64 builds against Intel Homebrew
under Rosetta. The global 3.11.1 was replaced by a native 3.11.18 with the
same top-level packages. Version jumps came only where the old pins were
Intel-only: torch, numpy, PyQt5, lxml, python-lzo.

Removed 2026-07-09: corrupt `~/.pyenv/versions/"3.11.1 "` (trailing space),
stale pyenv 3.9.10 / 3.9.16 / 3.10.2 / pypy2.7-7.3.6, orphaned brew
python@3.9 / python@3.10, python.org 3.8 framework symlinks. Anki needs
nothing from any of this — Anki.app bundles its own Python; addon/source dev
is covered in the uv migration task.

## Verification

Run `python-doctor` (in `bin/`, symlinked to `~/.local/bin`). It reports what
`python3` / `pip3` / venv resolve to and warns on every known failure mode.
