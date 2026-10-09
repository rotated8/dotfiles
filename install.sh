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

echo "Successfully finished installation!"
