Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.define "vm1" do |vm1|
    vm1.vm.network "private_network", ip: "192.168.50.10"
    vm1.vm.hostname = "vm1"
    vm1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.network "private_network", ip: "192.168.50.11"
    vm2.vm.hostname = "vm2"
    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install ansible
  SHELL
end
