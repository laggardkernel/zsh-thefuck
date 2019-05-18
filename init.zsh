#!/usr/bin/env zsh
# vim:fdm=marker:foldlevel=0:sw=2:ts=2:sts=2
#
# Copyright 2019, laggardkernel and the zsh-thefuck contributors
# SPDX-License-Identifier: MIT

# Generate initialize thefuck with cache mechanism, which saves your time
# dramatically
#
# Authors:
#   laggardkernel <laggardkernel@gmail.com>
#

# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

# path=("${0:h}/bin" "${path[@]}")
# fpath=("${0:h}/functions" "${fpath[@]}")

if [[ -z $commands[thefuck] ]]; then
  echo 'thefuck is not installed, you should "pip install thefuck" or "brew install thefuck" first.'
  echo 'See https://github.com/nvbn/thefuck#installation'
  return 1
fi

# Set alias for thefuck
  zstyle -s ':prezto:module:thefuck' alias \
    'THEFUCK_ALIAS' || THEFUCK_ALIAS='fuck'

# Register alias
init_args=(--alias "$THEFUCK_ALIAS")

cache_file="${TMPDIR:-/tmp}/thefuck-cache.$UID.zsh"
if [[ "${commands[thefuck]}" -nt "$cache_file" \
  || "${SDOTDIR:-$HOME/.zpreztorc}" -nt "$cache_file" \
  || ! -s "$cache_file"  ]]; then

  # Cache init code.
  thefuck "${init_args[@]}" >| "$cache_file" 2>/dev/null
fi

source "$cache_file"
unset cache_file init_args THEFUCK_ALIAS

fuck-command-line() {
  local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
  [[ -z $FUCK ]] && echo -n -e "\a" && return
  BUFFER=$FUCK
zle end-of-line
}
zle -N fuck-command-line

if zstyle -T ':prezto:module:thefuck' bindkey; then
  # Defined shortcut keys: [Esc] [Esc]
  bindkey "\e\e" fuck-command-line
fi
