# Starship prompt (config: config/starship.toml -> ~/.config/starship.toml).
# Sourced by zshrc unless PROMPT_ENGINE=p10k (Starship is the default since
# 2026-11-23).

# Starship logs warnings (e.g. a slow directory scan) to stderr, which would
# print into the terminal. Only show real errors.
export STARSHIP_LOG=error

eval "$(starship init zsh)"

# Transient prompt, like p10k's TRANSIENT_PROMPT=always: once a command is
# submitted, its prompt collapses to a bare arrow, so scrollback shows
# commands, not rows of segments. Starship has no zsh support for this, so
# redraw the prompt in zle-line-init (the pattern p10k's author published).
_transient_prompt_line_init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0
  local -i ret
  while true; do
    zle .recursive-edit
    ret=$?
    # Ctrl-D on an empty line: exit like normal unless IGNORE_EOF is set.
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done
  local saved_prompt=$PROMPT saved_rprompt=$RPROMPT
  PROMPT='%F{#8a8984}❯%f '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt
  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init _transient_prompt_line_init
