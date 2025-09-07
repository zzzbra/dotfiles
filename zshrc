# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=/Users/zzzbra/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="random"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd" # HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  dotenv
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

# User configuration

# Start with system defaults
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Add Homebrew (works for both Intel and Apple Silicon)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Add tools conditionally - only if they exist
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.cabal/bin" ]] && export PATH="$HOME/.cabal/bin:$PATH"
[[ -d "$HOME/.rbenv/shims" ]] && export PATH="$HOME/.rbenv/shims:$PATH"
[[ -d "/opt/X11/bin" ]] && export PATH="/opt/X11/bin:$PATH"

# Pyenv (if installed)
if command -v pyenv >/dev/null 2>&1; then
    export PATH="$(pyenv root)/shims:$PATH"
fi

# NPM/Node handling
# If using nvm, it will add its paths when sourced below
# This is a fallback for system npm if nvm isn't being used
if [[ ! -d "$HOME/.nvm" ]] && [[ -d "/usr/local/share/npm/bin" ]]; then
    export PATH="/usr/local/share/npm/bin:$PATH"
fi

# NVM (Node Version Manager) - adds node/npm to PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Heroku CLI (could be installed standalone or via Homebrew)
[[ -d "/usr/local/heroku/bin" ]] && export PATH="/usr/local/heroku/bin:$PATH"

# Legacy paths (kept for compatibility)
[[ -d "/Applications/ghc-7.8.3.app/Contents/bin" ]] && export PATH="/Applications/ghc-7.8.3.app/Contents/bin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#  export EDITOR='vim'
#else
#  export EDITOR='code'
#fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# shortcuts
alias reload="source ~/.zshrc && clear"
# alias my_ip?="dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"

# places
alias scratch="cd ~/dev/scratch"

# pyenv
eval "$(pyenv init -)"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

