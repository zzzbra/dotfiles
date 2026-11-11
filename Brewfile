# Native arm64 Homebrew (/opt/homebrew). Curated from Brewfile.intel-snapshot on 2026-11-09.
# Install:  arch -arm64 /opt/homebrew/bin/brew bundle --file=~/dotfiles/Brewfile
# Dependencies are not listed; brew pulls them in. Drop something by deleting its line.

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
brew "speedtest-cli"
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

# --- Languages / version managers ---
# pyenv, rbenv and pipx stay only until the mise and uv tasks replace them.
brew "pyenv"
brew "rbenv"
brew "pipx"
brew "pnpm"
brew "openjdk"
brew "btwld/fvm/fvm"
brew "heroku/brew/heroku"
# node is deliberately absent: nvm (later mise) owns Node.

# --- Data & services ---
brew "postgresql@17"     # fresh cluster in /opt/homebrew/var/postgresql@17; old Intel data left in /usr/local/var
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
brew "tailscale"
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

# Dropped from the snapshot (2026-11-09):
#   obsolete:  youtube-dl, exa, node, postgresql@9.6, postgresql@13, postgresql@14 (disabled 2026-11-12), reattach-to-user-namespace,
#              taps homebrew/cask-fonts, homebrew/cask-versions, homebrew/services, thoughtbot/formulae
#   unused:    openvino, php, brew-php-switcher, elixir, zork, irssi, exercism, minikube (formula+cask),
#              mysql, wxwidgets@3.2, innoextract, vim (nvim covers it), sphinx-doc, docutils, wireshark (old cask name)
#   libraries / deps that come in on their own: adns, librist, libxml2, nghttp2, pygobject3, qt, srt,
#              figlet, fortune, bats-core, libvo-aacenc, ossp-uuid
