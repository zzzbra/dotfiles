# dotfiles

Once the repository has been cloned to our home directory, simply change to the
dotfiles directory, make the makesymlinks.sh script executable, and run the
script, like so:

`cd ~/dotfiles && chmod +x makesymlinks.sh && ./makesymlinks.sh`

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
