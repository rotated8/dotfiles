Vagrant.require_version(">= 1.8") # Require Vagrant 1.8 at a minimum
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-19.04"

  # The host_ip is a workaround for Windows hosts, which otherwise do not like to forward ports.
  config.vm.network "forwarded_port", guest: 8983, host_ip: "127.0.0.1", host: 8983, auto_correct: true
  config.vm.network "forwarded_port", guest: 8984, host_ip: "127.0.0.1", host: 8984, auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host_ip: "127.0.0.1", host: 3000, auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    #vb.name         = "my box"
    vb.cpus         = 2
    vb.memory       = 2048
    vb.linked_clone = true # Linked clones prevents multiple VMs from being created for the same vagrant base box.
  end

  config.vm.provision "shell" do |s|
    s.env        = { REPO_ORG: "", REPO_NAME: "" }
    s.path       = "./setup-vagrant.sh"
    s.reset      = true # Reloads the shell after the provisioner runs
    s.privileged = false
  end
end
