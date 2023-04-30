#!/usr/bin/env bash

# Expect hyperfine and neovim to already be installed. Neovim should have plugins already installed as well.
if [[ -z "`command -v nvim`" && -z "`command -v hyperfine`" ]]; then
    echo "Install Hyperfine and Neovim, and any plugins Neovim needs."
    exit 1
fi

hyperfine "nvim -u NORC +qa" --warmup=20
find . -maxdepth 1 -regextype egrep -regex ".*(vim|lua)" | sort | xargs -I{} hyperfine "nvim -u '{}' +qa" --warmup=20
