# Native arm64 Homebrew (/opt/homebrew). Curated from Brewfile.intel-snapshot on 2026-11-09.
# Install:  arch -arm64 /opt/homebrew/bin/brew bundle --file=~/dotfiles/Brewfile
# Dependencies are not listed; brew pulls them in. Drop something by deleting its line.
# Brew owns everyday utilities, which should behave the same in every folder;
# mise owns per-project language runtimes (rule in CLAUDE.md).

tap "heroku/brew"        # heroku CLI (zshrc sets it up)
tap "btwld/fvm"          # Flutter version manager (flutter-tools in nvim)

# --- Shell & terminal ---
brew "bash"
brew "tmux"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "autojump"
brew "fzf"
brew "coreutils"
brew "duti"                 # default apps per file type, from duti/defaults.duti
brew "findutils"
brew "watch"
brew "tree"
brew "pstree"
brew "procs"
brew "duf"
brew "gping"
brew "tlrc"              # official tldr client; the "tldr" formula is gone
brew "lf"
brew "bat"
brew "eza"               # replaces exa (unmaintained)
brew "highlight"
brew "jq"
brew "rsync"
brew "wget"
brew "blueutil"

# --- Editor ---
brew "neovim"
brew "tree-sitter-cli"   # nvim-treesitter builds parsers with it (formula "tree-sitter" is only the library)
brew "ripgrep"           # telescope live_grep (install.sh installs it)
brew "fd"                # telescope find_files

# --- Git ---
brew "git"
brew "git-lfs"
brew "git-filter-repo"
brew "gh"
brew "libfido2"          # ssh security-key (sk-*) support

# --- Build toolchain ---
brew "cmake"
brew "ninja"
brew "just"              # command runner (justfiles); Anki's source build uses it (`just run`, `just check`)

# --- Languages / version managers ---
brew "mise"              # python, node and ruby versions (config/mise/config.toml); replaced pyenv, nvm and rbenv 2026-11-15
brew "uv"                # Python venvs, packages, `uv tool` global CLIs and `uv run` scripts; replaced pip/pipx/poetry 2026-11-15
brew "openssl@3"         # for anything compiled against Python 3.11/Ruby: plain "openssl" is OpenSSL 4, which their ssl modules won't build against
brew "lzo"               # C library python-lzo builds against (vocabsieve, a uv tool); no arm64 wheel for Python 3.11
brew "pnpm"
brew "openjdk"
brew "btwld/fvm/fvm"
brew "heroku/brew/heroku"
# node, python and ruby are deliberately absent: mise owns them.

# --- Data & services ---
brew "postgresql@17", link: true  # keg-only; linked so psql is on PATH. Fresh cluster in /opt/homebrew/var/postgresql@17; old Intel data left in /usr/local/var
brew "redis"

# --- Media & documents ---
brew "imagemagick"
brew "gifsicle"
brew "mpv"
brew "yt-dlp"            # replaces youtube-dl (dead)
brew "pandoc"
brew "poppler"

# --- Project-specific ---
brew "xcodegen"          # Sun and Steel
brew "openapi-generator"
brew "bazelisk"
brew "weechat"

# --- Your call: uncomment to keep ---
# brew "sbcl"            # Common Lisp. ~/.sbclrc loads Quicklisp (but ~/quicklisp doesn't exist); ~/dev/tutorials/lisp
# brew "guile"           # Scheme. Nothing in dotfiles or ~/dev references it.
# brew "xvid"            # MPEG-4 codec library. Nothing depends on it; mpv/ffmpeg don't need it.

# --- Casks ---
# The apps in /Applications are shared between the two brews. Moving a cask over means
# `brew install --cask --force <name>` from the arm64 brew (or uninstall from Intel first).
cask "font-hack-nerd-font"
cask "git-credential-manager"
cask "gcloud-cli"
cask "signal"
cask "wireshark-app"
cask "blackhole-16ch"
cask "ghostty"
cask "tailscale-app"     # standalone Tailscale (not the App Store one); bin/tailscale wraps its CLI
cask "keepingyouawake"   # menu-bar keep-awake; replaced Caffeine (Intel-only, 2026-11-12)

# Dropped from the snapshot (2026-11-09):
#   duplicate: tailscale formula (the tailscale-app cask ships its own CLI, wrapped by bin/tailscale; the formula drifted from the daemon and broke OpenClaw, 2026-11-14)
#   obsolete:  speedtest-cli (deprecated 2026-11; macOS has `networkQuality`), youtube-dl, exa, node, postgresql@9.6, postgresql@13, postgresql@14 (disabled 2026-11-12), reattach-to-user-namespace,
#              taps homebrew/cask-fonts, homebrew/cask-versions, homebrew/services, thoughtbot/formulae
#   unused:    openvino, php, brew-php-switcher, elixir, zork, irssi, exercism, minikube (formula+cask),
#              mysql, wxwidgets@3.2, innoextract, vim (nvim covers it), sphinx-doc, docutils, wireshark (old cask name)
#   libraries / deps that come in on their own: adns, librist, libxml2, nghttp2, pygobject3, qt, srt,
#              figlet, fortune, bats-core, libvo-aacenc, ossp-uuid
