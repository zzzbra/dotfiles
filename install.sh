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

# Install a brew package if not already installed
install_brew_package() {
    local package="$1"
    local name="${2:-$package}"  # Use package name as display name if not provided

    if command_exists "$package"; then
        print_success "$name is already installed"
    else
        print_step "Installing $name..."
        brew install "$package"
        if command_exists "$package"; then
            print_success "$name installed"
        else
            print_warning "Failed to verify $name installation"
        fi
    fi
}

# Install a brew cask if not already installed
install_brew_cask() {
    local cask="$1"
    local name="${2:-$cask}"  # Use cask name as display name if not provided

    if brew list --cask "$cask" &>/dev/null; then
        print_success "$name is already installed"
    else
        print_step "Installing $name..."
        brew install --cask "$cask"
        print_success "$name installed"
    fi
}

# Install a brew tap package if not already installed
install_brew_tap_package() {
    local tap="$1"
    local package="$2"
    local name="${3:-$package}"  # Use package name as display name if not provided

    if command_exists "$package"; then
        print_success "$name is already installed"
    else
        print_step "Installing $name..."
        brew tap "$tap"
        brew install "$package"
        if command_exists "$package"; then
            print_success "$name installed"
        else
            print_warning "Failed to verify $name installation"
        fi
    fi
}

# Clone a git repository if not already present
clone_git_repo() {
    local repo_url="$1"
    local target_dir="$2"
    local name="$3"
    local clone_args="${4:-}"  # Optional additional clone arguments

    if [[ -d "$target_dir" ]]; then
        print_success "$name is already installed"
    else
        print_step "Installing $name..."
        git clone $clone_args "$repo_url" "$target_dir"
        print_success "$name installed"
    fi
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
install_brew_cask "git-credential-manager" "Git Credential Manager"

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
clone_git_repo "https://github.com/romkatv/powerlevel10k.git" "$HOME/powerlevel10k" "Powerlevel10k" "--depth=1"

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_git_repo "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions" "zsh-autosuggestions"

clone_git_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"

# Development tools via Homebrew
print_step "Installing development tools..."

# Neovim and dependencies
install_brew_package "neovim" "Neovim"

# Neovim dependencies
install_brew_package "ripgrep" "ripgrep"

# fzf - fuzzy finder (required for gcrb script)
install_brew_package "fzf" "fzf (fuzzy finder)"

install_brew_package "cmake" "cmake (for telescope-fzf)"

# pyenv
install_brew_package "pyenv" "pyenv"

# rbenv
install_brew_package "rbenv" "rbenv"

# nvm
if [[ -d "$HOME/.nvm" ]]; then
    print_success "nvm is already installed"
else
    print_step "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "nvm installed"
fi

# fvm (Flutter Version Manager)
install_brew_tap_package "leoafarias/fvm" "fvm" "fvm (Flutter Version Manager)"

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
echo "  6. Install Flutter with: fvm install stable && fvm global stable"
echo ""
print_success "Your development environment is ready!"
echo ""