#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
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

########## Variables

# dotfiles directory
# TODO: allow for this to live in dev dir
dir=~/dotfiles                              
# old dotfiles backup directory; use timestamp so we don't overwrite second oldest
old_dir=~/dotfiles/backups/$(date +%s)                       

# VS Code config directory (macOS specific)
vscode_dir="$HOME/Library/Application Support/Code/User"

##########

echo ""
echo -e "${BOLD}${BLUE}===========================================🔧${RESET}"
echo -e "${BOLD}${BLUE}     Dotfiles Installation Script${RESET}"
echo -e "${BOLD}${BLUE}===========================================${RESET}"
echo ""

# create dotfiles_old in homedir
echo -e "${CYAN}${INFO} Creating backup directory...${RESET}"
echo -e "   ${ARROW} $old_dir"
mkdir -p $old_dir
echo -e "${GREEN}   ${CHECK} Done${RESET}"
echo ""

# change to the dotfiles directory
echo -e "${CYAN}${INFO} Changing to dotfiles directory...${RESET}"
cd $dir
echo -e "${GREEN}   ${CHECK} Done${RESET}"
echo ""

# Process symlinks from configuration file
echo -e "${BOLD}${CYAN}Setting up symlinks from configuration:${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

# Read symlinks.conf and process each mapping
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    
    # Parse the mapping (source -> destination)
    if [[ "$line" =~ ^(.+)[[:space:]]-\>[[:space:]](.+)$ ]]; then
        source_path="${BASH_REMATCH[1]// /}"  # Trim spaces
        dest_path="${BASH_REMATCH[2]// /}"    # Trim spaces
        
        # Expand tilde in destination path
        dest_path="${dest_path/#\~/$HOME}"
        
        # Get just the filename for display
        dest_name=$(basename "$dest_path")
        
        echo -e "\n${YELLOW}Processing: ${BOLD}$source_path${RESET}"
        
        # Check if destination exists and backup if needed
        if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
            echo -e "   ${WARNING} Found existing $dest_path"
            # Create parent directory in backup location if needed
            backup_parent="$old_dir/$(dirname "${dest_path#$HOME/}")"
            mkdir -p "$backup_parent"
            mv "$dest_path" "$backup_parent/" 2>/dev/null
            echo -e "   ${ARROW} Backed up to $backup_parent/"
        fi
        
        # Create parent directory if it doesn't exist
        mkdir -p "$(dirname "$dest_path")"
        
        # Create symlink
        ln -s "$dir/$source_path" "$dest_path"
        echo -e "   ${GREEN}${CHECK} Created symlink: $dest_path ${ARROW} $dir/$source_path${RESET}"
    fi
done < "$dir/symlinks.conf"

echo ""

# Handle VS Code configuration (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BOLD}${CYAN}Setting up VS Code configuration:${RESET}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Create VS Code User directory if it doesn't exist
    if [ ! -d "$vscode_dir" ]; then
        echo -e "\n${YELLOW}Creating VS Code directory...${RESET}"
        mkdir -p "$vscode_dir"
        echo -e "   ${GREEN}${CHECK} Created: $vscode_dir${RESET}"
    fi
    
    # Backup existing VS Code configs if they exist
    if [ -f "$vscode_dir/settings.json" ] && [ ! -L "$vscode_dir/settings.json" ]; then
        echo -e "\n${YELLOW}Backing up settings.json...${RESET}"
        cp "$vscode_dir/settings.json" "$old_dir/vscode-settings.json"
        echo -e "   ${GREEN}${CHECK} Backed up to $old_dir/${RESET}"
    fi
    
    if [ -f "$vscode_dir/keybindings.json" ] && [ ! -L "$vscode_dir/keybindings.json" ]; then
        echo -e "\n${YELLOW}Backing up keybindings.json...${RESET}"
        cp "$vscode_dir/keybindings.json" "$old_dir/vscode-keybindings.json"
        echo -e "   ${GREEN}${CHECK} Backed up to $old_dir/${RESET}"
    fi
    
    # Create symlinks for VS Code configs
    echo -e "\n${YELLOW}Creating VS Code symlinks...${RESET}"
    ln -sf "$dir/vscode/settings.json" "$vscode_dir/settings.json"
    echo -e "   ${GREEN}${CHECK} settings.json ${ARROW} $dir/vscode/settings.json${RESET}"
    
    ln -sf "$dir/vscode/keybindings.json" "$vscode_dir/keybindings.json"
    echo -e "   ${GREEN}${CHECK} keybindings.json ${ARROW} $dir/vscode/keybindings.json${RESET}"
fi

echo ""
echo -e "${BOLD}${GREEN}===========================================${RESET}"
echo -e "${BOLD}${GREEN}     ${CHECK} Installation Complete!${RESET}"
echo -e "${BOLD}${GREEN}===========================================${RESET}"
echo ""
echo -e "${CYAN}${INFO} Note: Restart your terminal or run 'source ~/.zshrc' to apply changes.${RESET}"
echo ""