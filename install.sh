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
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    if command_exists brew; then
        print_success "Homebrew installed successfully"
    else
        print_error "Failed to install Homebrew"
        exit 1
    fi
fi

# Install Git Credential Manager
if brew list --cask git-credential-manager &>/dev/null; then
    print_success "Git Credential Manager is already installed"
else
    print_step "Installing Git Credential Manager..."
    brew install --cask git-credential-manager
    print_success "Git Credential Manager installed"
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

# Development tools via Homebrew
print_step "Installing development tools..."

# Neovim and dependencies
if command_exists nvim; then
    print_success "Neovim is already installed"
else
    print_step "Installing Neovim..."
    brew install neovim
    print_success "Neovim installed"
fi

# Neovim dependencies
if command_exists rg; then
    print_success "ripgrep is already installed"
else
    print_step "Installing ripgrep (for telescope)..."
    brew install ripgrep
    print_success "ripgrep installed"
fi

# fzf - fuzzy finder (required for gcrb script)
if command_exists fzf; then
    print_success "fzf is already installed"
else
    print_step "Installing fzf (fuzzy finder)..."
    brew install fzf
    print_success "fzf installed"
fi

if command_exists cmake; then
    print_success "cmake is already installed"
else
    print_step "Installing cmake (for telescope-fzf)..."
    brew install cmake
    print_success "cmake installed"
fi

# pyenv
if command_exists pyenv; then
    print_success "pyenv is already installed"
else
    print_step "Installing pyenv..."
    brew install pyenv
    print_success "pyenv installed"
fi

# rbenv
if command_exists rbenv; then
    print_success "rbenv is already installed"
else
    print_step "Installing rbenv..."
    brew install rbenv
    print_success "rbenv installed"
fi

# rustup
if command_exists rustup; then
    print_success "rustup is already installed"
else
    print_step "Installing rustup (Rust toolchain)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    print_success "rustup installed"
fi

# nvm
if [[ -d "$HOME/.nvm" ]]; then
    print_success "nvm is already installed"
else
    print_step "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "nvm installed"
fi

# fvm (Flutter Version Manager)
if command_exists fvm; then
    print_success "fvm is already installed"
else
    print_step "Installing fvm (Flutter Version Manager)..."
    brew tap leoafarias/fvm
    brew install fvm
    print_success "fvm installed"
fi

# Set up Flutter via FVM
if [[ -L "$HOME/fvm/default" ]]; then
    print_success "Flutter default version is already configured"
else
    print_step "Setting up Flutter via FVM..."
    # Install stable Flutter version
    fvm install stable
    # Set it as the global default (creates the ~/fvm/default symlink)
    fvm global stable
    print_success "Flutter configured with stable version"
fi

# Final message
print_header "Installation Complete!"

print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k by running: p10k configure"
echo "  3. Install a Node.js version with: nvm install node"
echo "  4. Install a Python version with: pyenv install 3.11"
echo "  5. Install a Ruby version with: rbenv install 3.2.2"
echo "  6. Install Rust stable toolchain with: rustup default stable"
echo "  7. Install Flutter with: fvm install stable && fvm global stable"
echo ""
print_success "Your development environment is ready!"
echo ""