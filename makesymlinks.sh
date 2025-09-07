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
# list of files/folders to symlink in homedir
files="zshrc tmux.conf config/nvim"         

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

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo -e "${BOLD}${CYAN}Setting up dotfile symlinks:${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

for file in $files; do
    echo -e "\n${YELLOW}Processing: ${BOLD}$file${RESET}"
    
    if [ -e ~/.$file ] || [ -L ~/.$file ]; then
        echo -e "   ${WARNING} Found existing ~/.$file"
        mv ~/.$file "$old_dir/" 2>/dev/null
        echo -e "   ${ARROW} Backed up to $old_dir/"
    fi
    
    ln -s $dir/$file ~/.$file
    echo -e "   ${GREEN}${CHECK} Created symlink: ~/.$file ${ARROW} $dir/$file${RESET}"
done

echo ""

# Handle Git configuration
echo -e "${BOLD}${CYAN}Setting up Git configuration:${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

for gitfile in config ignore gitmessage; do
    echo -e "\n${YELLOW}Processing: ${BOLD}git/$gitfile${RESET}"
    
    if [ -e ~/.git$gitfile ] || [ -L ~/.git$gitfile ]; then
        echo -e "   ${WARNING} Found existing ~/.git$gitfile"
        mv ~/.git$gitfile "$old_dir/" 2>/dev/null
        echo -e "   ${ARROW} Backed up to $old_dir/"
    fi
    
    ln -s $dir/git/$gitfile ~/.git$gitfile
    echo -e "   ${GREEN}${CHECK} Created symlink: ~/.git$gitfile ${ARROW} $dir/git/$gitfile${RESET}"
done

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