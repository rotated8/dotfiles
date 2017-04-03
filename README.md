Dotfiles
========

My configuration files.

This is one of the first things I copy onto a new computer.
I've made an effort to make everything work across Linux, Mac, and Windows, but the shell configs may not work
on your preferred OS without tweaking.

The .zshrc requires [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

The .vimrc uses vundle. Installation instructions are in the .vimrc file. Use `head -n 20 ./.vimrc` to read them.

When using iTerm2, vim-airline needs transparency turned off, text contrast at minimum, and both the ASCII and non-ASCII fonts to support the powerline symbols (and probably the same font, in the end).

If Neovim is installed, link `~/.vimrc` to `~/.config/nvim/init.vim`. (Check [the neovim wiki](https://github.com/neovim/neovim/wiki/FAQ#where-should-i-put-my-config-vimrc) to make sure this is correct)

Two fonts are included: [Iosevka](https://be5invis.github.io/Iosevka/), version 1.12.2, and Vimconsolata, a
patched version of [Inconsolata](http://levien.com/type/myfonts/inconsolata.html) (version unknown). Iosevka
works better with vim-airline, and is used by default in the .vimrc and .minttyrc.
