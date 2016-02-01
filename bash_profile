#  _               _                        __ _ _
# | |__   __ _ ___| |__    _ __  _ __ ___  / _(_) | ___
# | '_ \ / _` / __| '_ \  | '_ \| '__/ _ \| |_| | |/ _ \
# | |_) | (_| \__ \ | | | | |_) | | | (_) |  _| | |  __/
# |_.__/ \__,_|___/_| |_| | .__/|_|  \___/|_| |_|_|\___|
#                         |_|
# When Bash starts, it executes the commands in this script
# http://en.wikipedia.org/wiki/Bash_(Unix_shell)
#
# Written by Philip Lamplugh, Instructor General Assembly (2013)
#   Updated by PJ Hughes, Instructor General Assembly (2013)

# =====================
# Resources
# =====================
# http://cli.learncodethehardway.org/bash_cheat_sheet.pdf
# http://ss64.com/bash/syntax-prompt.html
# https://dougbarton.us/Bash/Bash-prompts.html
# http://sage.ucsc.edu/xtal/iterm_tab_customization.html

# ====================
# TOC
# ====================
# --------------------
# System Settings
# --------------------
#  1. Path List
#  2. File Navigation
#  3. History
#  4. Bash Prompt
#  5. Other System Settings
# --------------------
# Application Settings
# --------------------
#  6. Application Aliases
#  7. Sublime
#  8. Git
#  9. Rails
# 10. rbenv
# --------------------
# Other Settings
# --------------------
# 11. Shortcuts
# 12. Source Files
# 13. Reserved


# SYSTEM SETTINGS
##########################################################################

# ==================
# Path
# This is a list of all directories in which to look for commands, scripts and programs
# ==================

# Load RVM into a shell session *as a function*
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # PJ: using rbenv now...
# Add RVM to PATH for scripting
# PATH=$PATH:$HOME/.rvm/bin # PJ: using rbenv now...
# Home brew directories
# PATH="/usr/local/bin:$PATH"
# Node Package Manager
# PATH="/usr/local/share/npm/bin:$PATH"
# Make sure we're pointing to the Postgres App's psql
# PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH" # PJ: off
# Heroku Toolbelt
# PATH="/usr/local/heroku/bin:$PATH"

# =================
# rbenv
# =================
# start rbenv (our Ruby environment and version manager) on open
# eval "$(rbenv init -)"


#  _   _  ___ _____ _____
# | \ | |/ _ \_   _| ____|  _
# |  \| | | | || | |  _|   (_)
# | |\  | |_| || | | |___   _
# |_| \_|\___/ |_| |_____| (_)
# previously above formula (excepy RVM scripts) were used to dynamically update the PATH but that
# caused a curious issue where the PATH itself would come to have the same directories needlessly
# appended to it on every session reload. This made reading the PATH cumberson so I cam now statically
# assigning it its variables here

PATH="/Users/zzzbra/.rbenv/shims:/usr/local/heroku/bin:/usr/local/share/npm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"


# ====================
# File Navigation
# ====================
# LS lists information about files. -F includes a slash for directories.
alias ls='ls -F'
# long list format including hidden files
alias ll='ls -la'
# Adds colors to LS
export CLICOLOR=1
# http://geoff.greer.fm/lscolors/
# Describes what color to use for which attribute (files, folders etc.)
export LSCOLORS=faexcxdxbxegedabagacad # PJ: turned off
# go back one directory
alias b='cd ..'
# If we make a change to our bash profile we need to reload it
alias reload="clear; source ~/.bash_profile"
## Tab improvements
## Might not need?
bind 'set completion-ignore-case on'
# make completions appear immediately after pressing TAB once
bind 'set show-all-if-ambiguous on'
bind 'TAB: menu-complete'
# Prefer US English
export LC_ALL="en_US.UTF-8"
# use UTF-8
export LANG="en_US"
# get ip address
alias ip?="ifconfig en0 | grep 'inet'"


# =================
# API_Keys
# =================

# GA Era
# =================
# export FEDEX_LOGIN="118621971"
# export FEDEX_PW="9QZkz3z7ichcHoSHBEBsWDw1i"
# export FEDEX_KEY="m587dwdlIYGY9nte"
# export FEDEX_ACCOUNT_NUMBER="510087488"

# For jSequencr Amazon Web Services
# export AWS_ACCESS_KEY_ID="AKIAI735S2XFLYSLIWPA"
# export AWS_SECRET_ACCESS_KEY="F/m5F3Q0d7GXWOEDdgzWbEO7vpgmu0P0L+TbytQk"

# Post-GA
# =================

# TODO: Evernote, etc.

# =================
# History
# =================
# History lists your previously entered commands
alias h='history'
# http://jorge.fbarr.net/2011/03/24/making-your-bash-history-more-efficient/
# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
# don't put duplicate lines in the history.
export HISTCONTROL=ignoredups
# ignore same sucessive entries.
export HISTCONTROL=ignoreboth
# Make some commands not show up in history
export HISTIGNORE="h:ls:ls *:ll:ll *:"

# =================
# Bash Prompt
# =================
# --------------------
# Colors for the prompt
# --------------------
# Set the TERM var to xterm-256color
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi
if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    # this is for xterm-256color
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 226)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    ORANGE=$(tput setaf 172)
    # GREEN=$(tput setaf 190)
    PURPLE=$(tput setaf 141)
    BG_BLACK=$(tput setab 0)
    BG_RED=$(tput setab 1)
    BG_GREEN=$(tput setab 2)
    BG_BLUE=$(tput setab 4)
    BG_MAGENTA=$(tput setab 5)
    BG_CYAN=$(tput setab 6)
    BG_YELLOW=$(tput setab 226)
    BG_ORANGE=$(tput setab 172)
    BG_WHITE=$(tput setab 7)
  else
    MAGENTA=$(tput setaf 5)
    ORANGE=$(tput setaf 4)
    GREEN=$(tput setaf 2)
    PURPLE=$(tput setaf 1)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
  UNDERLINE=$(tput sgr 0 1)
else
  BLACK="\[\e[0;30m\]"
  RED="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  YELLOW="\[\e[0;33m\]"
  CYAN="\[\e[0;36m\]"
  BLUE="\[\e[0;34m\]"
  BOLD=""
  RESET="\033[m"
fi
# ---------------------
# Print Stats on terminal load
# ---------------------
# GA General Assembly Webdevelopment Immersive
echo ${BG_WHITE}${BLUE} ROCKIN IN THE FREE WORLD ${RESET}
echo ${BG_RED}${WHITE} zzzbra ${RESET}${WHITE}${BG_BLACK} Wondersauce ${RESET}${BG_YELLOW}${BLACK} Digital Design Agency ${RESET}
echo "------------------------------------------"
echo $(ruby -v)
echo $(rails -v)
echo $(git --version)
echo $(heroku --version)
echo $(psql --version)
echo $(brew -v)
echo "npm " $(npm -v)
echo $(taocl)
echo "------------------------------------------"
# figlet -f $font "lean" Hi world.
# say "Zach you are such a good programmer!"
# ---------------------
# style the prompt
# ---------------------
style_user="\[${RESET}${WHITE}\]"
style_path="\[${RESET}${CYAN}\]"
style_chars="\[${RESET}${WHITE}\]"
style_branch="${RED}"
# ---------------------
# Build the prompt
# ---------------------
# Example with committed changes: username ~/documents/GA/wdi on master[+]
PS1="${style_user}\u"                    # Username
PS1+="${style_path} \w"                  # Working directory
PS1+="\$(prompt_git)"                    # Git details
PS1+="\n"                                # Newline
PS1+="⫸  \[${RESET}\]"                  # $ (and reset color) ######### THIS IS THE OLD CODE: ${style_chars}\$

# =================
# Other System Settings
# =================
# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
# Hide/show hidden files in Finder
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
# Switch between dark mode and light mode
alias darkmode="sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark"
alias lightmode="sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Light"
# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}
# List any open internet sockets on port 3000. Useful if a rogue server is running
# http://www.akadia.com/services/lsof_intro.html
alias rogue='lsof -i TCP:3000'

# APPLICATION SETTINGS
##########################################################################

# ================
# Application Aliases
# ================
alias subl='open -a "Sublime Text"'
alias slack='open /Applications/Slack.app'
alias atom='open -a Atom'
alias mou='open -a /Applications/Mou.app'

# ================
# Sublime
# ================
export EDITOR="vim"
# export EDITOR=/usr/bin/vim

# =================
# Git
# =================
# -----------------
# Aliases
# -----------------
# Alias for hub http://hub.github.com/
# alias git='hub'
# Undo a git push
alias undopush="git push -f origin HEAD^:master"
# undo a commit
alias uncommit="git reset --soft HEAD^"
# -----------------
# For the prompt
# -----------------
# Long git to show + ? !
is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}
is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}
get_git_branch() {
    local branch_name
    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"
    printf $branch_name
}
# Git status information
prompt_git() {
    local git_info git_state uc us ut st
    if ! is_git_repo || is_git_dir; then
        return 1
    fi
    git_info=$(get_git_branch)
    # Check for uncommitted changes in the index
    if ! $(git diff --quiet --ignore-submodules --cached); then
        uc="+"
    fi
    # Check for unstaged changes
    if ! $(git diff-files --quiet --ignore-submodules --); then
        us="!"
    fi
    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        ut="${RED}?"
    fi
    # Check for stashed files
    if $(git rev-parse --verify refs/stash &>/dev/null); then
        st="$"
    fi
    git_state=$uc$us$ut$st
    # Combine the branch name and state information
    if [[ $git_state ]]; then
        git_info="$git_info${RESET}[$git_state${RESET}]"
    fi
    printf "${WHITE} on ${style_branch}${git_info}"
}

# =================
# Rails
# =================
# Migrate Dev and Test databases and annotate models
alias migrate='rake db:migrate; rake db:migrate RAILS_ENV=test; annotate'

function taocl() {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80
}

# Other Settings
##########################################################################

# =================
# Shortcuts
# =================
# Students can add a shortcut to quickly access their GA folder
# example: alias wdi="cd ~/Documents/GA/WDI4"

alias wdi="cd ~/dev/wdi/WDI_NYC_12/"
cdhwfunc() {
  # takes three args: the week, the day
  # and an optional third for the user
  if [ $1 -lt 10 ]
  then
    cd ~/dev/wdi/WDI_NYC_12/w0$1/d0$2/${3:-Zach_Brady}
  else
    cd ~/dev/wdi/WDI_NYC_12/w$1/d0$2/${3:-Zach_Brady}
  fi
}
alias cdhw=cdhwfunc
alias b="cd .."

# Directories
alias dev="cd ~/dev"
alias work="cd ~/dev/wondersauce"
alias practice="cd ~/dev/tutorial_practice"
alias storage="cd ~/dev/libraries"
alias ecole_ass="open ~/Dropbox\ \(Wondersauce\)/Ecole/"
alias installs="cd /usr/local/bin"
alias cellar="cd /usr/local/Cellar"
alias scratch="cd ~/dev/scratch"
alias sites="cd ~/dev/sites"
alias bewd="cd ~/dev/BEWD-NYC"

# Projects
alias ob="cd ~/dev/wondersauce/outback"
alias bb="cd ~/dev/wondersauce/outback-bloomin-brands"
alias outback="cd ~/dev/wondersauce/outback"
alias cig="cd ~/dev/wondersauce/carrabbas"
alias reskin="cd ~/dev/wondersauce/cig-reskin"
alias lively="cd ~/dev/wondersauce/lively-splash"
alias bfg="cd ~/dev/wondersauce/bonefish-grill"
alias ecole="cd ~/dev/wondersauce/ecole"
alias splash="cd ~/dev/wondersauce/ecole-splash"
alias ws="cd ~/dev/wondersauce/wondersauce-site"
alias moneta="cd ~/dev/wdi/moneta"

# CL shortcuts
alias G="gulp; gulp watch;"
alias GD="gulp; gulp desktop"
alias GM="gulp; gulp mobile"


# MySQL Aliases
alias mysql_kill='killall -9 mysqld'
alias mysql_start='mysql.server start'
alias mysql_stop='mysql.server stop'
alias mysql_restart='mysql.server restart'

# Virtual Host
alias hosts='vim /etc/hosts'
alias vhosts='vim /etc/apache2/extra/httpd-vhosts.conf'
# Make sublime our editor of choice

# Apache Services
alias apache_start='sudo apachectl start'
alias apache_restart='sudo apachectl restart'
alias apache_stop='sudo apachectl stop'
alias httpd_config='vim /etc/apache2/httpd.conf'

# Open this file
alias bp="vim ~/.bash_profile"

# Set Logout Message
alias exit='sh ~/seeyouspacecowboy.sh; sleep 2; exit'

# =================
# Source Files
# =================
# .bash_settings and .bash_prompt should be added to .gitignore_global
# An extra file where you can create other settings, such as your
# application usernames or API keys...
if [ -f ~/.bash_settings ]; then
    source ~/.bash_settings
fi
# An extra file where you can create other settings for your prompt.
if [ -f ~/.bash_prompt ]; then
  source ~/.bash_prompt
fi

# Below here is an area for other commands added by outside programs or
# commands. Attempt to reserve this area for their use!
##########################################################################

# exercism autocompletion utility
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi

# Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.8.3.app"
if [ -d "$GHC_DOT_APP" ]; then
    export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

export NVM_DIR="/Users/zzzbra/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
source /usr/local/opt/nvm/nvm.sh
