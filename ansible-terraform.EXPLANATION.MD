
```markdown
# Explanation of the Infrastructure and Deployment Automation

## Overview

This project demonstrates the integration of Terraform and Ansible to provision and configure a development environment for a Node.js e-commerce application. The application stack includes a MongoDB database, a frontend, and a backend, all containerized using Docker and Docker Compose. Vagrant is used to manage the virtual machines (VMs).

## Infrastructure and Deployment Workflow

### Vagrant Configuration

Vagrant is used to create and manage virtual machines that host our application. The Vagrantfile is configured to set up two Ubuntu VMs with static IP addresses.

**Vagrantfile Configuration:**

- **VM1:** IP address `192.168.50.10`
- **VM2:** IP address `192.168.50.11`
- **Provisioning:** A shell script is used to install Python and Ansible on the VMs.

### Ansible Configuration

Ansible is used for configuring the VMs and deploying the application. The Ansible configuration includes an inventory file, a playbook, and roles for MongoDB, frontend, and backend setup.

**Inventory File:**

The `ansible/hosts` file defines the IP addresses and SSH details for the VMs:

```ini
[all]
vm1 ansible_host=192.168.50.10 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/vm1/virtualbox/private_key
vm2 ansible_host=192.168.50.11 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/vm2/virtualbox/private_key
```

**Playbook:**

The `ansible/Playbook.yml` file orchestrates the execution of roles:

```yaml
---
- name: Provision and configure VMs
  hosts: all
  become: yes
  roles:
    - mongodb
    - frontend
    - backend
```

### Terraform Configuration

Terraform is used for provisioning the Vagrant VMs and orchestrating the Ansible playbook execution. The Terraform configuration files are located in the `ansible/Stage_two/` directory.

**Main Terraform File (`main.tf`):**

This file defines the Vagrant VMs and triggers the Ansible playbook:

```hcl
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
```

**Variables File (`variables.tf`):**

Defines variables used in the Terraform configuration:

```hcl
variable "vm_box" {
  description = "Vagrant box to use"
  type        = string
  default     = "ubuntu/jammy64"
}
```

**Outputs File (`outputs.tf`):**

Specifies outputs for the Terraform configuration:

```hcl
output "vm1_ip" {
  value = "192.168.50.10"
}

output "vm2_ip" {
  value = "192.168.50.11"
}
```

### .gitignore Configuration

A `.gitignore` file is used to exclude sensitive files from being committed to the repository:

```plaintext
*.tfstate
*.tfstate.backup
.terraform/
```

## Execution Steps

1. **Bring Up Vagrant VMs:**

   In the root directory, run:

   ```bash
   vagrant up
   ```

2. **Initialize and Apply Terraform:**

   Navigate to the `ansible/Stage_two` directory and run:

   ```bash
   terraform init
   terraform apply
   ```

This will provision the Vagrant VMs and run the Ansible playbook to configure the VMs and deploy the application.

## Conclusion

This setup leverages the strengths of Terraform and Ansible to automate the entire process of provisioning and configuring the development environment. By using Vagrant, Terraform, and Ansible together, we achieve a seamless and repeatable infrastructure setup, ensuring that the application environment is consistent and reliable.
```