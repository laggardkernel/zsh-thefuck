#!/usr/bin/env zsh
# vim:fdm=marker:foldlevel=0:sw=2:ts=2:sts=2

# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

source "${0:h}/init.zsh"
