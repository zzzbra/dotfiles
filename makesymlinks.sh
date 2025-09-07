#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

# dotfiles directory
# TODO: allow for this to live in dev dir
dir=~/dotfiles                              
# old dotfiles backup directory; use timestamp so we don't overwrite second oldest
old_dir=~/dotfiles/backups/$(date +%s)                       
# list of files/folders to symlink in homedir
files="zshrc tmux.conf config/nvim gitconfig gitignore"         

# VS Code config directory (macOS specific)
vscode_dir="$HOME/Library/Application Support/Code/User"

##########

# create dotfiles_old in homedir
echo "Creating $old_dir for backup of any existing dotfiles in ~"
mkdir -p $old_dir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from ~ to $old_dir"
for file in $files; do
    if [ -n ~/.$file ]; then
        echo "Found any existing ~/.$file; moving to ~ to $old_dir"
        mv ~/.$file "$old_dir/" 
    fi

    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# Handle VS Code configuration (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up VS Code configuration for macOS..."
    
    # Create VS Code User directory if it doesn't exist
    if [ ! -d "$vscode_dir" ]; then
        echo "Creating VS Code User directory..."
        mkdir -p "$vscode_dir"
    fi
    
    # Backup existing VS Code configs if they exist
    if [ -f "$vscode_dir/settings.json" ] && [ ! -L "$vscode_dir/settings.json" ]; then
        echo "Backing up existing VS Code settings.json..."
        cp "$vscode_dir/settings.json" "$old_dir/vscode-settings.json"
    fi
    
    if [ -f "$vscode_dir/keybindings.json" ] && [ ! -L "$vscode_dir/keybindings.json" ]; then
        echo "Backing up existing VS Code keybindings.json..."
        cp "$vscode_dir/keybindings.json" "$old_dir/vscode-keybindings.json"
    fi
    
    # Create symlinks for VS Code configs
    echo "Creating symlink for VS Code settings.json..."
    ln -sf "$dir/vscode/settings.json" "$vscode_dir/settings.json"
    
    echo "Creating symlink for VS Code keybindings.json..."
    ln -sf "$dir/vscode/keybindings.json" "$vscode_dir/keybindings.json"
    
    echo "VS Code configuration setup complete."
fi
