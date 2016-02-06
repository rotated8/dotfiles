runserver = <<EOF
#!/bin/bash
set -o xtrace -o errexit -o pipefail -o nounset
cd /home/vagrant/
cp /vagrant/.vimrc ./
cp /vagrant/.bashrc ./
cp /vagrant/.inputrc ./
cp /vagrant/.gitconfig ./
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/gmarik/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim
echo "vim +PluginInstall +qall"
EOF

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'test'
    vb.cpus = 2
    vb.memory = 4096
  end
  # Forward Solr port in VM to local machine
  config.vm.network :forwarded_port, host: 8983, guest: 8983
  # Forward Tomcat/Fedora port in VM to port 8888 on local machine
  config.vm.network :forwarded_port, host: 8888, guest: 8080
  # Forward HTTP port in VM to port 8080 on local machine
  config.vm.network :forwarded_port, host: 8080, guest: 80
  # Forward HTTPS port in VM to port 4443 on local machine
  config.vm.network :forwarded_port, host: 4443, guest: 443
  config.vm.provision :shell, privileged: false, inline: runserver
end
