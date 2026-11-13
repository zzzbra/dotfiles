# Python version management policy

Settled 2026-07-09 (Notion: "Settle Python version management" task). One
deterministic answer to "what does `python3` mean on this machine," enforced by
these dotfiles. Interim policy — supersession path is the "Modernize dotfiles"
Notion project (native arm64 Homebrew → mise → uv), but the *layer model* below
survives that migration; only the tools filling the layers change.

## The layer model — one owner per layer

| Layer | Owner | Rule |
|---|---|---|
| Interpreters you deliberately use | **pyenv** | `python3` in a shell always resolves to a pyenv shim. Global default: `pyenv global`. Projects pin with `.python-version`. |
| Project packages | **venv** | Every project gets `.venv` created from its pyenv interpreter (`python -m venv .venv`). Never `pip install` outside a venv. |
| Global CLI tools | **pipx** | `pipx install <tool>`. (Becomes `uv tool` after the uv migration.) |
| Homebrew's pythons | **Homebrew, internally** | Exist only as dependency plumbing for formulas (gcloud, vim, mpv, …). Kept **unlinked** (`brew unlink python@X.Y`) so they never appear in `/usr/local/bin`. Never `pip install` into them. Dependents use `/usr/local/opt/...` paths, so unlinking breaks nothing (verified 2026-07-09). |
| System python | **Apple** | `/usr/bin/python3` — never modify, never pip install. Deliberate fallback for macOS-integrated one-offs (e.g. `plistlib`-heavy scripts); it is the only interpreter guaranteed consistent with OS libraries. |

## Known hazards this policy prevents

- **2026-07-09 incident:** `/usr/local/bin/python3` pointed at brew `python@3.14`
  whose `pyexpat` was broken against the OS `libexpat` (`import plistlib` →
  `ImportError`). Anything not going through pyenv shims hit it. Fix: brew
  pythons stay unlinked.
- `brew upgrade` may **relink** a python formula and recreate
  `/usr/local/bin/python3`. Harmless for interactive shells (shims win), but
  run `python-doctor` after brew upgrades; it warns loudly if this happened.

## Machine context

Native arm64 since 2026-11. pyenv builds interpreters against `/opt/homebrew`.
They need brew `openssl@3` (in the Brewfile), because brew's plain `openssl`
is OpenSSL 4 and Python 3.11's `ssl` module won't compile against it.
gdbm isn't installed, so `dbm.gnu` is absent; nothing uses it.

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
