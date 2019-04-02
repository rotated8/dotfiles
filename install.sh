#!/usr/bin/env bash
# Exit at first failure, return failures from pipes, don't allow unset vars, and expand and echo commands
set -o errexit -o pipefail -o nounset -o xtrace

# Set path to dot files
if [[ -n "$1" && -d "$1" ]]; then
    dot_file_dir = $1
elif [[ -d "${HOME}/dotfiles" ]]; then
    dot_file_dir = "${HOME}/dotfiles"
else
    echo "Could not find a directory to copy the dotfiles from. Try passing a path to this script."
    exit 1
fi

# Copy files
for dotfile in ".vimrc" ".bashrc" ".inputrc" ".gitconfig" ".tmux.conf" "git-completion.bash"; do
    if [[ -f "${dot_file_dir}/${dotfile}" ]]; then
        cp "${dot_file_dir}/${dotfile}" "${HOME}/${dotfile}"
    else
        echo "File ${dotfile} not found in ${dot_file_dir}. Skipping..."
    fi
done

# Pull in new .bashrc
if [[ -f "${HOME}/.bashrc" ]]; then
    . "${HOME}/.bashrc"
else
    echo "Missing .bashrc"
fi

# Set up Vim
if [[ -e "${HOME}/.vimrc" ]]; then
    # Install Vundle if it is missing.
    if [[ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]]; then
        git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
    fi

    # Set up nvim if installed. https://neovim.io/
    if which nvim 1> /dev/null 2> /dev/null; then
        # Link the vimrc, if it is missing
        if [[ ! -e "${HOME}/.config/nvim/init.vim" ]]; then
            mkdir -p "${HOME}/.config/nvim/"
            ln "${HOME}/.vimrc" "${HOME}/.config/nvim/init.vim"
        fi

        # Keep Vundle installs separate, in case something conflicts
        if [[ ! -d "${HOME}/.config/nvim/bundle/Vundle.vim" ]]; then
            git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}/.config/nvim/bundle/Vundle.vim"
        fi
    fi

    # Install Vim plugins
    set -i
    vim +PluginInstall +qall
    set +i
else
    echo "Missing .vimrc"
fi
