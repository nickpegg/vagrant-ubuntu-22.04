# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provision "shell", inline: <<-SHELL
    apt update && apt upgrade -y
  SHELL

  # Install our ed25519 key, since OpenSSH no longer supports rsa by default
  config.vm.provision "file",
    source: "ssh_key.pub",
    destination: "/home/vagrant/.ssh/authorized_keys"
end
