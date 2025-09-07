# dotfiles

## Prerequisites

### macOS Setup
Before using these dotfiles, install the following:

1. **Homebrew** (package manager):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Oh My Zsh** (Zsh framework):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Additional Zsh plugins** (referenced in zshrc):
   ```bash
   # Install zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   
   # Install zsh-syntax-highlighting
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

4. **Neovim** (if using nvim config):
   ```bash
   brew install neovim
   ```

5. **pyenv** (Python version management):
   ```bash
   brew install pyenv
   ```

6. **nvm** (Node version management):
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

## Installation

Once prerequisites are installed and the repository has been cloned to your home directory, run:

```bash
cd ~/dotfiles && chmod +x makesymlinks.sh && ./makesymlinks.sh
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
- [x] replace vim with neovim config
- [x] replace bash with zsh config
- [x] add VS Code configuration support
