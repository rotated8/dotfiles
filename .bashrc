# .bashrc

# Source global definitions.
# TODO: Is this necessary? I think /etc/profile is loaded first, which loads /etc/bash.bashrc, then this?
test -f /etc/bash.bashrc && . /etc/bash.bashrc

# User specific aliases and functions.
################################################################################

# Append to history file instead of overwriting it.
shopt -s histappend
# Check the window size after every command.
shopt -s checkwinsize

# Erase duplicates from bash history
HISTCONTROL=ignoredups:erasedups
HISTFILESIZE=10000
HISTSIZE=10000

# Parse out the branch we're on, or return an empty string. Errors are ignored.
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

# Show exit codes in the command prompt, if the code is not zero.
# Inspired by https://lobste.rs/s/qgqssl/what_are_most_useful_aliases_your_bashrc#c_xa98gj
function show_exit_code {
 exit_code=$? # Catch exit code
 if [[ $exit_code -ne 0 ]]; then
  echo -e "[$exit_code] "
 fi
}

# Prompt is '[exit_code] user@host [branch](in red) directory_name$ '.
PS1="\[\033[0;31m\]\$(show_exit_code)\[\033[1;33m\]\u@\H\[\033[0;31m\]\$(parse_git_branch)\[\033[0m\] \W\$ "

# Grep should use perl regexps, be recursive, ignore case, and print line numbers. In that order.
alias g='grep -Prin --color=auto'
# Use ripgrep, if installed. https://github.com/BurntSushi/ripgrep
if which rg 1> /dev/null 2> /dev/null; then
    alias grep='rg'
    # ripgrep uses Perl(-like) regexps, is recursive, and colorful by default.
    alias g='rg -in'
fi

# Use dircolors to setup colors for ls.
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -f "${HOME}/.dircolors" ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi
# ls Should list everything except '.' and '..' in long form, and have color.
alias ls='ls -Alh --color=auto'
# tree should act like ls.
alias tree='tree -Ca'

# getmod gets the mode of a file, without having to look up stat.
alias getmod='stat --format="%a(%A) %N"'
# getown get the owner and group of a file, without having to look up stat
alias getown='stat --format="%u(%U) %g(%G) %N"'

# tmux should assume utf8 and 256 colors.
alias tmux='tmux -u2'

# Try to coerce vim usage when an editor is needed.
export EDITOR=vim
export VISUAL=gvim
export GIT_EDITOR=vim

# Prefer nvim if installed. https://neovim.io/
# This uses the prebuilt tarballs.
if [[ -d /opt/nvim-linux-x86_64/ && ":$PATH:" != *":/opt/nvim-linux-x86_64/bin:"* ]]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
    alias vim='nvim'
    export EDITOR=nvim
    export GIT_EDITOR=nvim
fi

# Use git bash completion if it exists.
test -f ~/git-completion.bash && . ~/git-completion.bash

# Use asdf if it is installed
if [[ -d "${HOME}/.asdf" ]]; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
    . <(asdf completion bash)
fi

# This is added by UV 0.6.11
. "$HOME/.local/bin/env"

# Prefer Python3 in virtualenvs, if installed.
if which python3 1> /dev/null 2> /dev/null; then
    export VIRTUALENV_PYTHON=python3
fi

# Use rbenv if it is installed.
# 2017/06/28: rbenv can be installed with `git clone https://github.com/rbenv/rbenv ~/.rbenv`
# ruby-build is necessary to build and install ruby versions. It can be installed with
# `git clone https://github.com/rbenv/ruby-build ~/.rbenv/plugins/ruby-build`
if [[ -d ~/.rbenv/ && ":$PATH:" != *":$HOME/.rbenv/bin:"* ]]; then
    export PATH="$PATH:$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
fi

# Source Rust's setup, if present.
if [[ -f "${HOME}/.cargo/env" ]]; then
    . "${HOME}/.cargo/env"
fi

# Add fits.sh to PATH if it is installed
if [[ -f "$HOME/fits/fits.sh" && ":$PATH:" != *":$HOME/fits:"* ]]; then
    export PATH="$PATH:$HOME/fits"
fi

# Ensure the ~/.ssh dir exists, and is only usable by me.
test ! -d "$HOME/.ssh" && mkdir --parents --mode=700 "$HOME/.ssh"
# Tangentially, the correct permissions for SSH keys are 600 for the private key, and 644 for the public (.pub)

# Detect WSL.
if grep -q "[Mm]icrosoft" /proc/version; then
    # Make it easy to change to my Windows home.
    # -u to convert from Windows to WSL, and -a to force an absolute path.
    win_home=$(wslpath -u -a $(wslvar USERPROFILE))
    # That path might have a '/', '\r', and/or '\n' at the end. Remove them and add '/workspace/'
    wsl_home=$(echo "$win_home" | sed -re 's/\/?\r?\n?$/\/workspace\//g')
    # Ensure the workspace dir exists.
    test ! -d "$wsl_home" && mkdir --parents "$wsl_home"
    alias home="cd \"$wsl_home\""
    unset win_home
    unset wsl_home

    # Use Windows' OpenSSH so you can read keys in 1Password.
    # ONLY FOR USE IF ALL KEYS ARE IN 1PASSWORD
    alias ssh='ssh.exe'
    alias ssh-add='ssh-add.exe'
fi

# 2024/06/12 Always set up the agent. With WSL, 1Password cannot import extra keys.
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
env="${HOME}/.ssh/agent.env"

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [[ ! "$SSH_AUTH_SOCK" || $agent_run_state = 2 ]]; then
    agent_start
    ssh-add
elif [[ "$SSH_AUTH_SOCK" && $agent_run_state = 1 ]]; then
    ssh-add
fi

unset env
# End copied script
unset agent_run_state # Script doesn't auto clean up this var.

# AWS environment variables only work when exported. Setting them is not enough.
export AWS_DEFAULT_PROFILE=''
