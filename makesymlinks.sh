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
