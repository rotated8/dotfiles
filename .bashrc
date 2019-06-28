# .bashrc

# Source global definitions.
test -f /etc/bash.bashrc && . /etc/bash.bashrc

# User specific aliases and functions.
################################################################################

# Append to history file instead of overwriting it.
shopt -s histappend
# Check the window size after every command.
shopt -s checkwinsize

# Parse out the branch we're on, or return an empty string. Errors are ignored.
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}
# Prompt is 'user@host [branch](in red) directory_name$ '.
PS1="\[\033[1;33m\]\u@\H\[\033[0;31m\]\$(parse_git_branch)\[\033[0m\] \W\$ "

# Grep should use perl regexps, be recursive, ignore case, and print line numbers. In that order.
alias g='grep -Prin'
# Use ripgrep, if installed. https://github.com/BurntSushi/ripgrep
if which rg 1> /dev/null 2> /dev/null; then
    alias grep='rg'
    # ripgrep uses Perl(-like) regexps, and is recursive by default.
    alias g='rg -in'
fi

# ls Should list everything except '.' and '..' in long form, and have color.
export LSCOLORS='dxfxcxdxbxegedabagacad' # Directories are NOT dark blue.
alias ls='ls -Alh'
# tree should act like ls.
alias tree='tree -Ca'

# getmod gets the mode of a file, without having to look up stat.
alias getmod='stat -f "%p %N"'

# tmux should assume utf8 and 256 colors.
alias tmux='tmux -u2'

# Try to coerce vim usage when an editor is needed.
export EDITOR=vim
export VISUAL=gvim
export GIT_EDITOR=vim

# Prefer nvim if installed. https://neovim.io/
if which nvim 1> /dev/null 2> /dev/null; then
    alias vim='nvim'
    export EDITOR=nvim
    export GIT_EDITOR=nvim
fi

# Prefer Python3 in virtualenvs, if installed.
if which python3 1> /dev/null 2> /dev/null; then
    export VIRTUALENV_PYTHON=python3
fi

# Use git bash completion if it exists.
test -f ~/git-completion.bash && . ~/git-completion.bash

# Use rbenv if it is installed.
# 2017/06/28: rbenv can be installed with `git clone https://github.com/rbenv/rbenv ~/.rbenv`
# ruby-build is necessary to build and install ruby versions. It can be installed with
# `git clone https://github.com/rbenv/ruby-build ~/.rbenv/plugins/ruby-build`
if [[ -d ~/.rbenv/ ]]; then
    export PATH="$PATH:$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
fi

# 2019/01/24: Automatically start ssh-agent, via
# https://help.github.com/articles/working-with-ssh-key-passphrases/#auto-launching-ssh-agent-on-git-for-windows
env=~/.ssh/agent.env

agent_load_env () {
    test ! -d "$HOME/.ssh" && mkdir -parents -mode=600 "$HOME/.ssh"
    test -f "$env" && . "$env" >| /dev/null ; }

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

# Detect WSL.
if grep -q "Microsoft" /proc/version; then
    # Configure Vagrant. More info: https://www.vagrantup.com/docs/other/wsl.html
    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

    # Make it easy to change to my Windows home if I'm not already there.
    if [[ $PWD != "/mnt/*" ]]; then
        # In future, try https://docs.microsoft.com/en-us/windows/wsl/interop#share-environment-variables-between-windows-and-wsl
        win_home=$(cmd.exe /C echo %UserProfile%)
        wsl_home=$(echo "$win_home" | sed -re 's/:?\\/\//g' -e 's/^C/\/mnt\/c/' -e 's/\r?\n?$/\/workspace\//g')
        alias home='cd "$wsl_home"'
    fi
fi
