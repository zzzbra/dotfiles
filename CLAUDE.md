# CLAUDE.md — ~/dotfiles

Guidance for Claude Code sessions working in this repo.

## Machine facts (do not re-derive; do not assume otherwise)

- **Apple Silicon M1 Max** — but running a legacy **Intel Homebrew under
  Rosetta** at `/usr/local` (no `/opt/homebrew` yet). Shells may report
  `uname -m` = x86_64; that's Rosetta, not the hardware.
- Consequence: do **not** compile new x86_64 artifacts or build interpreters
  against this brew (arm64-vs-x86_64 linker failures). Native arm64 migration
  is planned work, see below.
- Existing pyenv interpreters (3.10.10, 3.11.1 global) are x86_64 — leave them
  until the migration replaces them.

## Active project: Modernize dotfiles (July 2026)

Live state, task specs, and session handoffs live in the Notion project
**"Modernize dotfiles"** (page id `3988f358-d22b-816c-8cd6-ce4eb02ffae2`) —
read its final "Session handoff" section before starting work. Task order:

1. Migrate Homebrew → native arm64 `/opt/homebrew` (spec + verification
   protocol on its task page)
2. Migrate version management → mise (replaces pyenv/nvm/rbenv)
3. Migrate Python tooling → uv (replaces venv/pip/pipx/poetry)

Verification approach (agreed with the user): no environment teardown.
Side-by-side installs, fresh-terminal checks, Brewfile snapshot before
changes, doctor script after each step, `grep -r /usr/local` sweep before
retiring anything old.

## Parallel effort: Neovim + tmux audit

A piece-by-piece audit of the inherited nvim/tmux config (contrasted against
Takuya's web-dev setup). Live status + handoffs: Notion task **"Neovim + tmux
dotfiles audit & walkthrough"**. Durable outcomes land as code + the nvim
conventions below.

## Repo conventions

- Symlinks are declared in `symlinks.conf` and applied by `makesymlinks.sh`
  (`zshrc`/`zprofile` in `zsh/` are symlinked to `~/.zshrc`/`~/.zprofile`;
  scripts in `bin/` symlink into `~/.local/bin`).
- `install.sh` is the from-zero machine bootstrap; keep it idempotent. Any
  new tool/policy must land here, not just in live shell state.
- Python policy (settled 2026-07-09): `docs/python-policy.md` — pyenv owns
  interpreters, venvs own project packages, brew pythons stay **unlinked**
  (dependency plumbing only), system python untouched. Verify with
  `python-doctor` (in `bin/`) — run it in a **fresh** terminal; long-lived
  shells can false-positive on duplicate shims from inherited PATH.
- **Neovim** (`config/nvim` → `~/.config/nvim`): hand-rolled **lazy.nvim**
  config (NOT LazyVim), modules under `lua/aslan/`. Plugin keymaps belong in
  that plugin's spec (`keys = {}`), never duplicated in `init.lua` — defining
  in both shadows the spec and breaks lazy-loading. `init.lua` holds only
  editor-global, plugin-independent maps. Leader = Space. On Nvim 0.11 (native
  `vim.lsp.config`/`enable`); some `vim.lsp.buf.*` legacy fns are gone.
- **Formatting** (`.../plugins/formatting.lua`): conform.nvim, **project-
  config-gated and manual only** (`<leader>f`; deliberately no format-on-save).
  A project opts in by committing a formatter config; configless buffers fall
  back to LSP formatting or no-op. Full philosophy is that file's header
  comment. Formatter binaries are declared via **mason-tool-installer**, not
  assumed on PATH.

## Working style (user preferences)

- Ask before installing new tools.
- Prototype/verify before committing; commit only when asked.
- Explain jargon plainly; naming things is his call.
