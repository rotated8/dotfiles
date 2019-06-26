#!/usr/bin/env bash
# Exit at first failure, return failures from pipes, don't allow unset vars, and echo executed lines in output.
set -o errexit -o pipefail -o nounset -o xtrace

# For use with Ubuntu 19.04 or later.

# Install updates and basic packages
export DEBIAN_FRONTEND=noninteractive # Because it's true, and it prevents some dpkg-*configure errors.
sudo apt-get update
sudo apt-get install -y git vim make gcc g++ software-properties-common neovim ripgrep

# Install Neovim on Ubuntu pre-18.04
#sudo add-apt-repository -y ppa:neovim-ppa/stable
#sudo apt-get update
#sudo apt-get install -y neovim

# Install ripgrep on Ubuntu pre-18.10
#curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
#sudo dpkg -i ./ripgrep_11.0.1_amd64.deb

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
    set +o xtrace # Please don't trace this.
    . "${HOME}/.bashrc"
    set -o xtrace
fi

# Install Ruby 2.5.3
rbenv install 2.5.3
rbenv global 2.5.3

# Update system gems, and force bundler to get installed.
gem update --system --no-document --no-post-install-message
gem install --force --no-document bundler

# Install package dependencies
sudo apt-get install -y redis-server chromium-browser chromium-chromedriver openjdk-8-jre libmysqlclient-dev libsqlite3-dev #libpq-dev postgresql

# Install Node 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

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
    bundle install --jobs 4 --retry 3
fi
