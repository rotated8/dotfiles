Dotfiles
========

This repository is the one thing I have worked on for my entire career.

My current environment of choice is bash from Ubuntu on Windows, using WSL 2, with Vagrant and Virtualbox for the
(preferably Debian-like) development environments. I like Neovim, or regular Vim, for editing, Tmux, and git.
I've tried screen and SVN, but never used them enough to develop configuration for them.

Notes
-----

The `.vimrc` uses vundle. Installation instructions are in the .vimrc file. `head -n 20 ./.vimrc` is an easy way to read them.

If Neovim is installed, link `~/.vimrc` to `~/.config/nvim/init.vim`. (Check [the Neovim wiki](https://github.com/neovim/neovim/wiki/FAQ#where-should-i-put-my-config-vimrc) to make sure this is correct)

My preferred font is [Iosevka](https://be5invis.github.io/Iosevka/)- version 3.0.1 Regular Fixed is included.
Iosevka works well with vim-airline, and is used by default in the `.vimrc`. I prefer the "Fixed" version
of Iosevka, mostly because I don't want ligatures in my math symbols.

Links
-----

I've broken this section into two categories. First are links for things that I need to download and
install when setting up a new system.

- [Vagrant](https://www.vagrantup.com/) - A commandline tool for creating and managing virtual environments.
- [Virtualbox](https://www.virtualbox.org/) - Used by Vagrant, Virtualbox does the heavy lifting for my virtual
  environments,

Neovim and ripgrep are now included in Ubuntu packages, and can be installed with apt (Ubuntu 18.10+)!

- [Neovim](https://neovim.io/) - A performant, modern version of Vim.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Grep, but written in Rust, with a slightly different
  feature set. Benchmarks suggest it is faster.

The other group is links for documentation.

- [Neovim](https://neovim.io/doc/user/) - This is specifically for Neovim. Classic vim docs are
  [here](http://vimdoc.sourceforge.net/htmldoc/).
- [Tmux](https://github.com/tmux/tmux) - While this isn't documentation per se, I llike having this link
  around.
- [Git](https://git-scm.com/doc) - In. Value. Able. Can be searched from DuckDuckGo with `!git-scm`
- [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) - The interoperability and user account sections
  have been quite helpful.
- [Bash](http://tldp.org/LDP/abs/html/) - I wouldn't have a career without this guide. It routinely answers
  questions I have forgotten.

Deprecated
----------

Some items here I no longer use regularly. Many of them are from a time when I was working on Macs.

When using iTerm2, vim-airline needs transparency turned off, text contrast at minimum, and both the ASCII and
non-ASCII fonts to support the powerline symbols (and probably the same font, in the end).

With the new Windows Terminal, I no longer need the `.minttyrc`. Similarly, `.bash_profile` has been unneeded
for a little while.

A patched version of [Inconsolata](http://levien.com/type/myfonts/inconsolata.html) (version unknown) used to
be my preferred terminal font.
