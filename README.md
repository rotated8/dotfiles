Dotfiles
========

This repository is the one thing I have worked on for my entire career.

My current environment of choice is bash from Ubuntu on Windows, using WSL 2, with Vagrant and Virtualbox for the
(preferably Debian-like) development environments. I like Neovim, or regular Vim, for editing, Tmux, and git.
I've tried screen and SVN, but never used them enough to develop configuration for them.

Notes
-----

`init.lua` is the preferred config for Neovim. It should live in `~/.config/nvim`.
To install plugins, run `nvim --headless "+Lazy! sync" +qall`, or use `install.sh`.

My preferred font is [Iosevka](https://be5invis.github.io/Iosevka/)- get the latest release of Iosevka Term.
Iosevka works well with vim-airline, and is used by default in configs.

Links
-----

I've broken this section into two categories. First are links for things that I need to download and
install when setting up a new system.

- [Neovim](https://neovim.io/) - A performant, modern version of Vim. Must be 0.9.0 or later. Use the [Linux install
  instructions](https://neovim.io/doc/install/#linux) for prebuilt archives.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Grep, but written in Rust, with a slightly different
  feature set. Benchmarks suggest it is faster.
- [hyperfine](https://github.com/sharkdp/hyperfine) - A commandline tool for benchmarking tasks.

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

The `.vimrc` uses vundle. Installation instructions are in the .vimrc file. `head -n 20 ./.vimrc` is an easy way to read them, but I prefer to use Neovim now.

I used to use Vagrant for development, but I haven't even installed it in years.
