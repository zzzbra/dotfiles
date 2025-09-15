# dotfiles

## Quick Start

```bash
git clone https://github.com/zzzbra/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

## Manual Installation

### Step 1: Install Core Dependencies

1. **Homebrew** (package manager):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Oh My Zsh** (Zsh framework):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### Step 2: Clone and Run Dotfiles Setup

```bash
git clone https://github.com/zzzbra/dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x makesymlinks.sh && ./makesymlinks.sh
```

After running the script, restart your terminal or run:
```bash
source ~/.zshrc
```

### Step 3: Install Additional Tools

With Homebrew now in your PATH, install the remaining tools:

1. **Zsh theme and plugins**:
   ```bash
   # Install Powerlevel10k theme
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
   
   # Install zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   
   # Install zsh-syntax-highlighting
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

2. **Development tools**:
   ```bash
   brew install --cask git-credential-manager
   brew install neovim
   brew install pyenv
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   
   # Java/OpenJDK - install any version (PATH auto-configured)
   brew install openjdk@17  # or openjdk@11, openjdk@21, openjdk (latest)
   # To switch versions: brew unlink openjdk@17 && brew link openjdk@21
   ```

3. **Final step** - Source your shell to make all tools available:
   ```bash
   source ~/.zshrc
   ```

## Project Structure & Conventions

This dotfiles repository follows these conventions for organizing configuration files:

### File Organization
- **Root-level files**: Individual config files (e.g., `zshrc`, `gitconfig`, `tmux.conf`) are stored in the repository root
- **Directories**: Multi-file configurations are stored in their own directories:
  - `config/nvim/` - Neovim configuration
  - `vscode/` - VS Code settings and keybindings

### Symlink Strategy
The `makesymlinks.sh` script creates symlinks from this repository to their appropriate locations:
- Root-level files → `~/.{filename}` (e.g., `zshrc` → `~/.zshrc`)
- Config directories → `~/.config/{dirname}` (e.g., `config/nvim` → `~/.config/nvim`)
- Platform-specific locations:
  - VS Code (macOS): `vscode/` → `~/Library/Application Support/Code/User/`

### Adding New Configurations
To add a new configuration file or directory:
1. Place the file/directory in the repository following the conventions above
2. For standard dotfiles: Add the filename to the `files` variable in `makesymlinks.sh`
3. For platform-specific configs: Add custom handling logic in `makesymlinks.sh` (see VS Code section as example)

### Backup Strategy
When running `makesymlinks.sh`, existing configurations are automatically backed up to `~/dotfiles/backups/{timestamp}/` before creating new symlinks.

## TODO
- [ ] add session exit script
- [ ] follow .config/ directory convention
- [ ] explore yadm for dotfiles management
- [ ] investigate mise/asdf for runtime version management
- [ ] fix neovim issues
- [ ] make entirety of dotfiles work on Linux machines
- [x] replace vim with neovim config
- [x] replace bash with zsh config
- [x] add VS Code configuration support
