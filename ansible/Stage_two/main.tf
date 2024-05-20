provider "vagrant" {
  # Vagrant provider configuration
}

resource "vagrant_vm" "vm1" {
  name  = "vm1"
  box   = "ubuntu/jammy64"
  ip    = "192.168.50.10"
}

resource "vagrant_vm" "vm2" {
  name  = "vm2"
  box   = "ubuntu/jammy64"
  ip    = "192.168.50.11"
}

resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../hosts ../Playbook.yml"
    working_dir = path.module
  }

  depends_on = [vagrant_vm.vm1, vagrant_vm.vm2]
}
