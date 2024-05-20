Vagrant.configure("2") do |config|
    config.vm.define "web" do |web|
      web.vm.box = "ubuntu/bionic64"
      web.vm.network "private_network", type: "dhcp"
    end
  
    config.vm.define "db" do |db|
      db.vm.network "private_network", type: "dhcp"
    end
  
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/site.yml"
      ansible.inventory_path = "ansible/hosts"
    end
  end
  