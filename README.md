# dotfiles

Shell, editor, terminal and tooling config for an Apple Silicon Mac
(native arm64). macOS only for now.

## Install

```bash
git clone https://github.com/zzzbra/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

On a brand-new machine, trust the two third-party Homebrew taps once
first, or `brew bundle` skips their formulae:
`brew trust --formula heroku/brew/heroku btwld/fvm/fvm`.

`install.sh` is the whole bootstrap and is safe to re-run. In order, it:

1. Installs Homebrew (`/opt/homebrew`) and everything in the `Brewfile`
   (`brew bundle`), plus the machine's `hosts/<name>/Brewfile` if it has
   one, then Oh My Zsh.
2. Checks out the tmux plugins (git submodules) and links the config into
   place (`makesymlinks.sh`, driven by `symlinks.conf`). Existing files are
   backed up to `backups/<timestamp>/` first.
3. Loads the LaunchAgents and sets default apps per file type (`duti`).
4. Installs the zsh plugins (zsh-autosuggestions,
   zsh-syntax-highlighting). The prompt is Starship, from the Brewfile.
5. Installs the language toolchains: rustup for Rust, and `mise install`
   for Python, Node, Ruby and Go.
6. Sets up Flutter (fvm) and Claude Code's Notion MCP server.

Afterwards, open a new terminal. To check the Python setup, run
`python-doctor`.

Open nvim once from a terminal after a fresh install. lazy.nvim installs the
plugins, and Mason installs the language servers and formatters. Some of
those are built with the language toolchains, which only exist in terminal
shells.

## Who installs what

| Layer | Owner | Where it's declared |
|---|---|---|
| Apps, services (Postgres, Redis), system libraries, everyday CLI tools (git, tmux, rg, jq, fzf...) | Homebrew | `Brewfile` |
| Language runtimes: Python, Node, Ruby, Go | mise | `config/mise/config.toml` |
| Rust | rustup | projects pin with `rust-toolchain.toml` |
| Python packages, venvs, Python CLI tools | uv | `docs/python-policy.md` |
| Editor plugins | lazy.nvim | `config/nvim/lazy-lock.json` |
| Language servers, formatters | Mason | `config/nvim/lua/aslan/plugins/lsp.lua` |

The rule behind the split: mise owns things whose version should change
from project to project. Everyday utilities should behave the same in every
folder, so Homebrew owns them. A project's own `mise.toml`,
`.python-version`, `.nvmrc`, `.ruby-version` or `.go-version` overrides the
global runtime versions inside it.

mise is hooked in with `mise activate` (no shims), so its runtimes are on
PATH in terminal shells only.

## Three tiers

| Tier | Applied | Where |
|---|---|---|
| **Core** | On every machine, by `install.sh` | everything at the repo root |
| **Modules** | By hand, per machine; never by `install.sh` | `modules/<name>/`, each self-contained with its own README |
| **Hosts** | Only on the machine named | `hosts/<name>/` |

`install.sh` picks the host from `~/.config/dotfiles/host`, a one-line file
outside git (e.g. `tv-scorpion`), and applies `hosts/<name>/Brewfile` when
there is one. It also links and starts any LaunchAgents in
`hosts/<name>/launchagents/` (on tv-scorpion: the mokuro manga server).
A machine without that file gets only the core.

## Layout

| Path | What |
|---|---|
| `install.sh` | From-zero bootstrap |
| `makesymlinks.sh`, `symlinks.conf` | Links repo files into `~` |
| `Brewfile` | Homebrew packages and casks |
| `hosts/` | Per-machine extras (e.g. `hosts/tv-scorpion/Brewfile`) |
| `modules/` | Opt-in extras, run by hand (e.g. `modules/spotlight-exclude/`) |
| `zsh/`, `bash/` | Shell config (`zshrc` holds PATH, with a reason next to each entry) |
| `config/nvim/` | Neovim: a hand-rolled lazy.nvim config, modules in `lua/aslan/` |
| `config/ghostty/` | Ghostty terminal (themes follow macOS light/dark) |
| `config/mise/`, `config/uv/` | Runtime versions; uv prefers mise's Pythons |
| `tmux/` | `tmux.conf`, plus tmux-resurrect and tmux-continuum as pinned submodules |
| `git/` | Git config, global ignore, commit template |
| `ssh/` | Shared SSH client config for tailnet hosts (no keys) |
| `bin/` | Scripts, linked into `~/.local/bin` |
| `launchagents/` | macOS LaunchAgents (e.g. tmux workspaces at login) |
| `duti/` | Default apps per file type |
| `vscode/` | VS Code settings and keybindings |
| `claude/` | Claude Code global instructions and settings, linked into `~/.claude/` |
| `docs/` | Policies (`python-policy.md`) |

## Conventions

- **Every change lands here.** A new tool or setting goes into the repo
  (and `install.sh` if it needs installing), never only into live shell
  state.
- **Linking:** add a line `source -> ~/destination` to `symlinks.conf`,
  then run `./makesymlinks.sh`.
- **Formatting in nvim is opt-in per project.** `<leader>f` formats only
  with a formatter the project has committed a config for, and falls back
  to the language server. There's no format-on-save. The rationale is the
  header of `config/nvim/lua/aslan/plugins/formatting.lua`.
- **tmux sessions** are saved every 15 minutes and restored at login.
- **SSH:** shared hosts live in `ssh/config`. Machine-specific or private
  hosts go in `~/.ssh/config.local`, which isn't in git. Private keys never
  go in the repo.
- **Secrets** go in `~/.secrets`, which `zshrc` sources and git never sees.

`CLAUDE.md` holds the same facts in more detail, for Claude Code sessions.
