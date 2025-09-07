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
    echo -e "${BOLD}${BLUE}===========================================🚀${RESET}"
    echo -e "${BOLD}${BLUE}     $1${RESET}"
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
"$SCRIPT_DIR/makesymlinks.sh"

# Source the new configuration
print_step "Loading shell configuration..."
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
    print_success "Shell configuration loaded"
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

# Development tools via Homebrew
print_step "Installing development tools..."

# Neovim
if command_exists nvim; then
    print_success "Neovim is already installed"
else
    print_step "Installing Neovim..."
    brew install neovim
    print_success "Neovim installed"
fi

# pyenv
if command_exists pyenv; then
    print_success "pyenv is already installed"
else
    print_step "Installing pyenv..."
    brew install pyenv
    print_success "pyenv installed"
fi

# nvm
if [[ -d "$HOME/.nvm" ]]; then
    print_success "nvm is already installed"
else
    print_step "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "nvm installed"
fi

# Final message
print_header "Installation Complete!"

print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k by running: p10k configure"
echo "  3. Install a Node.js version with: nvm install node"
echo "  4. Install a Python version with: pyenv install 3.11"
echo ""
print_success "Your development environment is ready!"
echo ""