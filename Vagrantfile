Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.network "forwarded_port", guest: 8983, host_ip: "127.0.0.1", host: 8983, auto_correct: true
  config.vm.network "forwarded_port", guest: 8984, host_ip: "127.0.0.1", host: 8984, auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host_ip: "127.0.0.1", host: 3000, auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = 2
    vb.memory = 2048
  end

  config.vm.provision "shell" do |s|
    s.env        = { REPO_ORG: "", REPO_NAME: "" }
    s.path       = "./setup-vagrant.sh"
    s.reset      = true
    s.privileged = false
  end
end
