#!/usr/bin/env bash
# Exit at first failure, return failures from pipes, and don't allow unset vars
set -o errexit -o pipefail -o nounset

### For use with Ubuntu 16.04 or later.

# Install updates and basic packages
sudo apt-get update
sudo apt-get install -y git vim make gcc g++ software-properties-common

# Install Neovim
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y neovim

# Install Rbenv, ruby-build
git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv"
cd "${HOME}/.rbenv" && src/configure && make -C src

git clone https://github.com/rbenv/ruby-build.git "$(${HOME}/.rbenv/bin/rbenv root)"/plugins/ruby-build

# Get and install dotfiles
dot_files_dir="${HOME}/dotfiles"
git clone https://github.com/rotated8/dotfiles "${dot_files_dir}"
/usr/bin/env bash "${HOME}/dotfiles/install.sh" -- "${dot_files_dir}"

# Source the .bashrc, if it exists, to get rbenv working.
if [[ -e "${HOME}/.bashrc" ]]; then
    . "${HOME}/.bashrc"
fi

# Install Ruby 2.5.3
rbenv install 2.5.3
rbenv global 2.5.3

# Update system gems, and force bundler to get installed.
gem update --system
gem install --force bundler

# Install package dependencies
sudo apt-get install -y libmysqlclient-dev libsqlite3-dev libpq-dev
sudo apt-get install -y redis-server postgresql chromium-browser openjdk-8-jre

# Install Node 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install nodejs

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn

# If defined, clone a project, and install it's gems.
if [[ -n "${REPO_ORG}" && -n "${REPO_NAME}" ]]; then
    repo_dir="${HOME}/${REPO_NAME}"

    # Clone repo
    git clone "https://github.com/${REPO_ORG}/${REPO_NAME}" "${repo_dir}"

    # Install gems
    cd "${repo_dir}"
    bundle install
fi
