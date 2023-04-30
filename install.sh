#!/usr/bin/env bash
# Exit at first failure, return failures from pipes, and don't allow unset vars
set -o errexit -o pipefail -o nounset

# Set path to dot files
if [[ $# -eq 1 && -n "$1" && -d "$1" ]]; then
    dot_file_dir="$1"
elif [[ -d "${HOME}/dotfiles" ]]; then
    dot_file_dir="${HOME}/dotfiles"
else
    echo "Could not find a directory to copy the dotfiles from. Try passing a path to this script."
    exit 1
fi
echo "Using dotfiles from $dot_file_dir"

# Copy files
for dotfile in ".vimrc" ".bashrc" ".inputrc" ".gitconfig" ".tmux.conf" "git-completion.bash"; do
    if [[ -f "${HOME}/${dotfile}" ]]; then
        echo "${HOME}/${dotfile} already exists, backing it up to ${HOME}."
        cp "${HOME}/${dotfile}" "${HOME}/${dotfile}.backup"
    fi

    if [[ -f "${dot_file_dir}/${dotfile}" ]]; then
        echo "Installing ${dotfile}..."
        cp "${dot_file_dir}/${dotfile}" "${HOME}/${dotfile}"
    else
        echo "File ${dotfile} not found in ${dot_file_dir}. Skipping..."
    fi
done

# Neovim Setup
if [[ -n "`command -v nvim`" ]]; then
    echo "Attempting to configure Neovim..."

    nvim_config_dir="${XDG_CONFIG_HOME:-$HOME}/.config/nvim"
    mkdir -p "${nvim_config_dir}/"

    # Back up init files
    for init in "init.lua" "init.vim" ; do
        if [[ -f "${nvim_config_dir}/${init}" ]]; then
            echo "${nvim_config_dir}/${init} already exists, backing it up to ${HOME}."
            cp "${nvim_config_dir}/${init}" "${HOME}/${init}.backup"
        fi
    done

    # Install init.lua, if it exists
    if [[ -f "${dot_file_dir}/init.lua" ]]; then
        echo "Installing init.lua..."
        cp "${dot_file_dir}/init.lua" "${nvim_config_dir}/init.lua"

        # Avoid attempting to use init.lua and init.vim.
        if [[ -f "${nvim_config_dir}/init.vim" ]]; then
            echo "Removing ${nvim_config_dir}/init.vim, since init.lua has been installed."
            rm "${nvim_config_dir}/init.vim"
            echo "Plugins installed by init.vim must be cleaned up manually."
        fi

        # Install plugins
        nvim --headless "+Lazy! sync" +qall 1> /dev/null 2>dev/null
    elif [[ -e "${HOME}/.vimrc" ]]; then
        # Install init.vim if init.lua is missing
        echo "Linking .vimrc as init.vim..."
        ln "${HOME}/.vimrc" "${nvim_config_dir}/init.vim"

        # Install plugins
        if [[ ! -d "${HOME}/.config/nvim/bundle/Vundle.vim" ]]; then
            git clone --quiet https://github.com/VundleVim/Vundle.vim.git "${HOME}/.config/nvim/bundle/Vundle.vim"
        fi
        nvim --headless +PluginInstall +qall 1> /dev/null 2> /dev/null
    else
        echo "Neovim is installed, but no configuration file was found, moving on..."
    fi
else
    echo "Neovim is missing, moving on..."

    # Neovim is missing. Only set up Vim if it is present with a .vimrc
    if [[ -n "`command -v vim`" && -e "${HOME}/.vimrc" ]]
        # Install Vundle if it is missing.
        echo "Installing Vim plugins..."
        if [[ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]]; then
            git clone --quiet https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
        fi

        # Install plugins
        # -E = Start in Ex mode. -s = Silent. -S = Source this file (since -E won't do it)
        vim -EsS "${HOME}/.vimrc" +PluginInstall +qall 1> /dev/null 2> /dev/null
    else
        echo "Vim or a .vimrc are missing, moving on..."
    fi
fi

echo "Successfully finished installation!"
