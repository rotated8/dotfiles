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
        echo "${HOME}/${dotfile} already exists, backing it up."
        cp "${HOME}/${dotfile}" "${HOME}/${dotfile}.backup"
    fi

    if [[ -f "${dot_file_dir}/${dotfile}" ]]; then
        echo "Installing ${dotfile}..."
        cp "${dot_file_dir}/${dotfile}" "${HOME}/${dotfile}"
    else
        echo "File ${dotfile} not found in ${dot_file_dir}. Skipping..."
    fi
done

# Set up Vim
if [[ -e "${HOME}/.vimrc" ]]; then
    # Install Vundle if it is missing.
    echo "Installing Vim plugins..."
    if [[ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]]; then
        git clone --quiet https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
    fi

    # Install plugins
    # -E = Start in Ex mode. -s = Silent. -S = Source this file (since -E won't do it)
    vim -EsS "${HOME}/.vimrc" +PluginInstall +qall 1> /dev/null 2> /dev/null

    # Set up nvim if installed.
    if which nvim 1> /dev/null 2> /dev/null; then
        echo "Installing Neovim plugins..."
        # Link the vimrc, if it is missing
        if [[ ! -e "${HOME}/.config/nvim/init.vim" ]]; then
            mkdir -p "${HOME}/.config/nvim/"
            ln "${HOME}/.vimrc" "${HOME}/.config/nvim/init.vim"
        fi

        # Keep Vundle installs separate, in case something conflicts
        if [[ ! -d "${HOME}/.config/nvim/bundle/Vundle.vim" ]]; then
            git clone --quiet https://github.com/VundleVim/Vundle.vim.git "${HOME}/.config/nvim/bundle/Vundle.vim"
        fi

        # Plugins still need to be installed
        nvim --headless +PluginInstall +qall 1> /dev/null 2> /dev/null
    fi

else
    echo "No .vimrc, skipping Vim/Neovim setup."
fi
