Vagrant.configure("2") do |config|
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/bionic64"
    web.vm.network "private_network", ip: "192.168.56.101"
    config.vm.network "forwarded_port", guest: 3000, host: 3000

  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/bionic64"
    db.vm.network "private_network", ip: "192.168.56.102"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/Playbook.yml"
    ansible.inventory_path = "ansible/hosts"
  end
end
