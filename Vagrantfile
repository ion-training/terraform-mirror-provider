# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.provision "shell", path: "./scripts/script.sh"
  config.ssh.extra_args = ["-t", "cd /vagrant/terraform-proj; bash --login"]
end
