#!/bin/zsh
# Zsh-Droid-RE Plugin

ZSH_DROID_ROOT="${0:A:h}"

# 1. Load the Package Manager function
if [[ -f "$ZSH_DROID_ROOT/functions/pm.sh" ]]; then
    source "$ZSH_DROID_ROOT/functions/pm.sh"
fi

# 2. Add completions folder to fpath (Zsh's completion search path)
if [[ -d "$ZSH_DROID_ROOT/completions" ]]; then
    fpath=("$ZSH_DROID_ROOT/completions" $fpath)
    # Re-initialize completions to pick up the new folder
    compinit -u
fi