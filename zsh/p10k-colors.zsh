# Powerlevel10k colours that work with any Ghostty theme, light or dark.
#
# ~/.p10k.zsh (the 2021 "rainbow" wizard output, untracked) colours segments
# by palette number: 0-7 follow whatever theme Ghostty has loaded. Claude
# Light (2026-11-16) makes those dark and muted, so dark text landed on dark
# fills. This file runs after ~/.p10k.zsh and swaps each segment's colours
# for fixed hex values: mid-tone fills that read on a cream or charcoal
# background, and on each fill a text colour chosen for contrast. Re-running
# `p10k configure` doesn't touch this file.

() {
  emulate -L zsh
  # Fill for each background the wizard used.
  local -A fill=(
    0   '#3d3d3a'  # charcoal
    1   '#c0583d'  # rust
    2   '#4f8a4a'  # green
    3   '#d9a441'  # amber
    4   '#3f72b5'  # blue
    5   '#9a4f78'  # plum
    6   '#2f8a80'  # teal
    7   '#d6d3c7'  # stone
    8   '#6b6a65'  # slate
    208 '#d9773f'  # orange
    240 '#5a5955'  # dark slate
  )
  # Fills that need dark text; every other fill gets light text.
  local -A light_fill=('#d9a441' 1 '#d6d3c7' 1 '#d9773f' 1)
  # On charcoal/slate fills, keep the segment's own text hue (e.g. green ✓,
  # red ✘) but use a bright version of it.
  local -A dark_fill=('#3d3d3a' 1 '#6b6a65' 1 '#5a5955' 1)
  local -A bright=(
    1 '#f08a72'  2 '#8fd07a'  3 '#f0cf6e'  4 '#8ab8f0'  5 '#e0a0c8'
    6 '#7fd8cb'  7 '#e8e6de'  76 '#8fd07a'  196 '#ff7a6e'
  )
  local ink='#1f1e1d' paper='#fbfaf6'

  local bg_param fg_param bg fg
  for bg_param in ${(k)parameters[(I)POWERLEVEL9K_*_BACKGROUND]}; do
    bg=${(P)bg_param}
    [[ -n $bg && -n ${fill[$bg]} ]] || continue
    fg_param=${bg_param%_BACKGROUND}_FOREGROUND
    fg=${(P)fg_param}
    typeset -g $bg_param=${fill[$bg]}
    if (( ${+dark_fill[${fill[$bg]}]} )); then
      typeset -g $fg_param=${bright[$fg]:-'#e8e6de'}
    elif (( ${+light_fill[${fill[$bg]}]} )); then
      typeset -g $fg_param=$ink
    else
      typeset -g $fg_param=$paper
    fi
  done

  # The git segment writes its own text colours inside my_git_formatter
  # (%0F black, %7F white, %1F red), so give it light fills and point those
  # codes at fixed dark inks.
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED}_BACKGROUND='#9ccf86'
  typeset -g POWERLEVEL9K_VCS_{MODIFIED,CONFLICTED}_BACKGROUND='#e6b85a'
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,CONFLICTED}_FOREGROUND=$ink
  if (( ${+functions[my_git_formatter]} )); then
    local body=${functions[my_git_formatter]}
    body=${body//'%0F'/"%F{$ink}"}
    body=${body//'%7F'/'%F{#4a4944}'}
    body=${body//'%1F'/'%F{#a3301c}'}
    functions[my_git_formatter]=$body
  fi
}
