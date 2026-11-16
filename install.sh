#!/bin/bash

############################
# Dotfiles Installation Script
# This script installs all dependencies and configures the development environment
############################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Unicode symbols
CHECK="✓"
ARROW="→"
WARNING="⚠"
INFO="ℹ"

# Get the directory where this script lives
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Helper functions
print_header() {
    echo ""
    echo -e "${BOLD}${BLUE}===========================================${RESET}"
    echo -e "${BOLD}${BLUE}🚀   $1${RESET}"
    echo -e "${BOLD}${BLUE}===========================================${RESET}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BOLD}${CYAN}$1${RESET}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_step() {
    echo -e "${YELLOW}$1${RESET}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${RESET}"
}

print_info() {
    echo -e "${CYAN}${INFO} $1${RESET}"
}

print_error() {
    echo -e "${RED}✗ $1${RESET}"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation flow
print_header "Dotfiles Installation"

# Step 1: Install Homebrew
print_section "Step 1: Core Dependencies"

if command_exists brew; then
    print_success "Homebrew is already installed"
else
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    if command_exists brew; then
        print_success "Homebrew installed successfully"
    else
        print_error "Failed to install Homebrew"
        exit 1
    fi
fi

# Everything Homebrew installs (formulae, casks, taps) is declared in the Brewfile.
# Third-party taps (heroku, btwld/fvm) must be trusted once before bundle can use
# them: brew trust --formula heroku/brew/heroku btwld/fvm/fvm
print_step "Installing Brewfile dependencies (brew bundle)..."
if brew bundle --file "$SCRIPT_DIR/Brewfile"; then
    print_success "Brewfile dependencies installed"
else
    print_warning "brew bundle reported failures (see output above); rerun it after fixing them"
fi

# Step 2: Install Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    print_success "Oh My Zsh is already installed"
else
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
fi

# Step 3: Set up dotfiles symlinks
print_section "Step 2: Dotfiles Configuration"

# tmux plugins are pinned git submodules (tmux-resurrect, tmux-continuum).
# Named explicitly so a checkout only ever touches these two.
print_step "Checking out tmux plugins..."
git -C "$SCRIPT_DIR" submodule update --init -- tmux/plugins/tmux-resurrect tmux/plugins/tmux-continuum \
    && print_success "tmux plugins checked out" \
    || print_error "tmux plugin checkout failed (tmux works, without save/restore)"

print_step "Creating symlinks..."
"$SCRIPT_DIR/makesymlinks.sh" > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    print_success "Symlinks created successfully"
else
    print_error "Failed to create symlinks"
    exit 1
fi

# Configuration is ready (user needs to source it in zsh)
print_success "Dotfiles configured successfully"

# Load LaunchAgents (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_step "Loading LaunchAgents..."
    OLLAMA_ENV_PLIST="$HOME/Library/LaunchAgents/com.user.ollama-env.plist"
    if [[ -f "$OLLAMA_ENV_PLIST" ]]; then
        launchctl unload "$OLLAMA_ENV_PLIST" 2>/dev/null
        launchctl load "$OLLAMA_ENV_PLIST"
        print_success "LaunchAgents loaded"
    fi
fi

# Default apps per file type (macOS only; duti comes from the Brewfile)
if [[ "$OSTYPE" == "darwin"* ]] && command_exists duti; then
    print_step "Setting default apps..."
    if duti "$SCRIPT_DIR/duti/defaults.duti"; then
        print_success "Default apps set from duti/defaults.duti"
    else
        print_warning "Some default apps could not be set (see duti output above)"
    fi
fi

# Step 4: Install additional tools
print_section "Step 3: Development Tools"

# Zsh theme and plugins
print_step "Installing Zsh customizations..."

# Powerlevel10k
if [[ -d "$HOME/powerlevel10k" ]]; then
    print_success "Powerlevel10k is already installed"
else
    print_step "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    print_success "Powerlevel10k installed"
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    print_success "zsh-autosuggestions is already installed"
else
    print_step "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions installed"
fi

if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    print_success "zsh-syntax-highlighting is already installed"
else
    print_step "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting installed"
fi

# neovim, ripgrep, fd, fzf, cmake, git-lfs, gcloud-cli, mise and fvm
# come from the Brewfile (Step 1). Below: per-user setup brew can't do.

# git-lfs hooks for this user
if command_exists git-lfs; then
    git lfs install --skip-repo >/dev/null && print_success "git-lfs hooks configured"
fi

# Python policy (docs/python-policy.md): brew pythons are dependency plumbing
# only — keep them unlinked so they never shadow mise's `python3`.
for formula in $(brew list --formula 2>/dev/null | grep -E '^python@'); do
    if [[ -e "$(brew --prefix)/bin/python3" ]] || ls "$(brew --prefix)"/bin/python3.[0-9]* &>/dev/null; then
        print_step "Unlinking $formula (python policy)..."
        brew unlink "$formula" &>/dev/null || true
    fi
done
print_success "Brew pythons unlinked per python policy"

# rustup (zshrc already puts ~/.cargo/bin on PATH, so don't let it edit shell files)
if command_exists rustup; then
    print_success "rustup is already installed"
else
    print_step "Installing rustup (Rust toolchain)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    print_success "rustup installed"
fi

# Runtimes: mise (from the Brewfile) installs the global python/node/ruby/go pinned
# in config/mise/config.toml (symlinked to ~/.config/mise/config.toml in Step 2).
# Prebuilt native binaries, so this takes seconds. Idempotent.
if command_exists mise; then
    print_step "Installing runtimes with mise (config/mise/config.toml)..."
    if mise install --yes; then
        print_success "mise runtimes installed: $(mise ls --current 2>/dev/null | awk '{print $1"@"$2}' | tr '\n' ' ')"
    else
        print_warning "mise install reported failures; rerun: mise install"
    fi
    # The global Python carries one library: pynvim, Neovim's Python provider.
    # Everything else goes in a project venv, a `uv tool`, or a script's
    # inline dependencies (docs/python-policy.md).
    mise exec -- python3 -m pip install -q pynvim && print_success "pynvim installed in mise's global Python"
fi

# Global Python CLIs: `uv tool`s, each in its own environment. These two are
# editable installs of local checkouts, so they're skipped where the checkout
# doesn't exist. python-lzo (vocabsieve) builds against brew's lzo; mokuro
# still imports pkg_resources, which setuptools 84 no longer ships (79 works).
if command_exists uv; then
    vocabsieve_src="$HOME/dev/projects/anki_projects/vocabsieve"
    boox_src="$HOME/dev/projects/boox-mokuro"
    if [[ -d "$vocabsieve_src" ]]; then
        CPPFLAGS="-I$(brew --prefix)/include" LDFLAGS="-L$(brew --prefix)/lib" \
            mise exec -- uv tool install -q -p 3.11 -e "$vocabsieve_src" \
            && print_success "uv tool: vocabsieve" || print_warning "uv tool install vocabsieve failed"
    fi
    if [[ -d "$boox_src" ]]; then
        mise exec -- uv tool install -q -p 3.11 --with "setuptools<80" --with-executables-from mokuro,manga-ocr -e "$boox_src" \
            && print_success "uv tool: boox-mokuro (+ mokuro, manga_ocr)" || print_warning "uv tool install boox-mokuro failed"
    fi
fi

# Set up Flutter via FVM (fvm itself comes from the Brewfile)
if ! command_exists fvm; then
    print_warning "fvm not installed (Brewfile step failed?) — skipping Flutter setup"
elif [[ -L "$HOME/fvm/default" ]]; then
    print_success "Flutter default version is already configured"
else
    print_step "Setting up Flutter via FVM..."
    # Install stable Flutter version
    fvm install stable
    # Set it as the global default (creates the ~/fvm/default symlink)
    fvm global stable
    print_success "Flutter configured with stable version"
fi

# Claude Code MCP servers
if command_exists claude; then
    if claude mcp get notion &>/dev/null; then
        print_success "Notion MCP server is already configured"
    else
        print_step "Adding Notion MCP server to Claude Code (user scope)..."
        claude mcp add --transport http --scope user notion https://mcp.notion.com/mcp
        print_success "Notion MCP server added"
        print_info "OAuth tokens live in the keychain, not dotfiles — run /mcp inside Claude Code to sign in to Notion"
    fi
else
    print_warning "Claude Code not installed — skipping Notion MCP setup"
fi

# Final message
print_header "Installation Complete!"

print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k by running: p10k configure"
echo "  3. Runtimes: change global versions in config/mise/config.toml, then: mise install (verify python: python-doctor)"
echo "  4. Install Rust stable toolchain with: rustup default stable"
echo "  5. Install Flutter with: fvm install stable && fvm global stable"
echo "  6. Authenticate MCP servers: open Claude Code and run /mcp, then sign in to each server"
echo ""
print_success "Your development environment is ready!"
echo ""