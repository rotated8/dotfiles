#!/usr/bin/env bash
# Exit at first failure, return failures from pipes, don't allow unset vars, and echo executed lines in output.
set -o errexit -o pipefail -o nounset -o xtrace

# For use with Ubuntu 19.04 or later.

# Install updates and basic packages
export DEBIAN_FRONTEND=noninteractive # Because it's true, and it prevents some dpkg-*configure errors.
# sudo apt-get install software-properties-common # Uncomment if add-apt-repository does not work.
# Add the Git and NeoVim PPAs so we get updates faster.
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y git neovim ripgrep

# Get and install dotfiles
dot_files_dir="${HOME}/dotfiles"
git clone https://github.com/rotated8/dotfiles "${dot_files_dir}"
/usr/bin/env bash "${HOME}/dotfiles/install.sh" -- "${dot_files_dir}"

# Install asdf
git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch v0.10.2

# Source the .bashrc, if it exists, to get asdf working.
if [[ -e "${HOME}/.bashrc" ]]; then
    # My .bashrc can't handle errexit (ssh helper tests), and Ubuntu's can't handle nounset (??).
    set +o errexit +o nounset
    . "${HOME}/.bashrc"
    set -o errexit -o nounset
fi

# Install Ruby 2.7.6
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
# This list of dependencies comes from ruby-build, which asdf uses to install ruby. https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
asdf install ruby 2.7.6
asdf global ruby 2.7.6

# Update system gems, and force bundler to get installed.
gem update --system --no-document --no-post-install-message
gem install --force --no-document bundler

# Install NodeJS
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
# This list of dependencies comes from node-build, which asdf uses to install nodejs. https://github.com/nodejs/node/blob/main/BUILDING.md#building-nodejs-on-supported-platforms
sudo apt-get install python3 g++ make python3-pip
asdf install nodejs lts # Installs the current long-term supported release.
asdf global nodejs lts

# Install package dependencies
sudo apt-get install -y redis-server chromium-browser chromium-chromedriver openjdk-8-jre libmysqlclient-dev libsqlite3-dev #libpq-dev postgresql

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
