# YOLO E-commerce Application - Configuration Management

## Introduction

This project aims to automate the provisioning and configuration of an Ubuntu server using Vagrant and Ansible. The setup ensures that the e-commerce web application, which includes a MongoDB backend, a Node.js backend, and a React frontend, is fully operational with minimal manual intervention.

## Ansible Instrumentation

### Environment Setup

1. **Vagrant Provisioned Server**

-A VM named "web" is created using the Ubuntu Bionic base image.
It is assigned a private IP address of 192.168.56.101.
Port 3000 on the VM is forwarded to port 3000 on the host machine, allowing you to access the web application via localhost:3000.

A VM named "db" is created using the Ubuntu Bionic base image.
It is assigned a private IP address of 192.168.56.102

2. **Ansible Playbook**

After the VMs are created, Vagrant uses Ansible to provision them according to the tasks defined in ansible/Playbook.yml.

The inventory file ansible/hosts is used to determine which VM performs which role (e.g., web server, database server).

### Ansible Configuration

#### Directory Structure

```
yolo/
├── ansible/
│   ├── roles/
│   │   ├── mongodb/
│   │   │   └── tasks/
│   │   │       └── main.yml
│   │   ├── frontend/
│   │   │   └── tasks/
│   │   │       └── main.yml
│   │   └── backend/
│   │       └── tasks/
│   │           └── main.yml
│   ├── group_vars/
│   │   └── all.yml
│   ├── hosts
│   └── Playbook.yml
├── .vscode/ (Contains files)
├── backend/ (Contains files)
├── client/ (Contains files)
├── docker-compose.yml
├── Vagrantfile
├── README.MD
├── Ansible.EXPLANTION.MD
├── DockerHubSC.png
├── EXPLANATION.MD
├── beniye-yolo-web-backend.png
└── beniye-yolo-web-client.png


```

#### Vagrantfile

The `Vagrantfile` is used to configure and provision the virtual machine:

```ruby
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
```

#### Ansible Playbook

The `Playbook.yml` defines the tasks to configure the server and deploy the application:

```yaml
---
- name: Deploy YOLO Node.js application with MongoDB
  hosts: all
  become: yes

  vars_files:
    - group_vars/all.yml

  pre_tasks:
    - name: Install Git
      apt:
        name: git
        state: present

  roles:
    - { role: mongodb, tags: ['db'] }
    - { role: frontend, tags: ['frontend'] }
    - { role: backend, tags: ['backend'] }

```

#### Roles

Each role is responsible for configuring a specific part of the application:

1. **MongoDB Role**
   - Installs and configures MongoDB.

2. **Backend Role**
   - Sets up the Node.js backend.

3. **Frontend Role**
   - Configures the React frontend.

### group_vars

The `group_vars/all.yml` file defines variables used in the playbook:

```yaml
mongodb_port: 27017
backend_port: 5000
frontend_port: 3000
```

### Task Files

Each role has a `main.yml` file that lists the tasks to be executed. For example, the `backend/main.yml`:

```yaml
---
- name: Clone backend repository
  git:
    repo: "{{ github_repo }}"
    dest: "{{ project_dir }}"
  tags: ['backend']

- name: Deploy backend application
  block:
    - name: Start backend container
      docker_compose:
        project_src: "{{ project_dir }}"
        service: "yolo-web-backend"
        state: present
        restarted: yes
        pull: yes
        remove_orphans: yes
  tags: ['backend']

```

### Running the Setup

   **Provision the VM:**
- Run vagrant up in your project root directory. This command will start the Vagrant virtual machine and automatically run the Ansible playbook to configure the server.


## Testing the Application

Once the setup is complete, the application should be accessible via the browser.
Open your browser and navigate to http://localhost:3000 to access the frontend of the e-commerce application.
This is possible because the Vagrantfile to forwards the VM's port 3000 to the host's port 3000. This allows you to access the frontend application using localhost:3000.


You can test the functionality of the application by adding products through the provided form.

## Conclusion

This project demonstrates the use of Vagrant and Ansible to automate the provisioning and configuration of a development environment for a web application. By leveraging these tools, we ensure a consistent and repeatable setup process, reducing the potential for errors and saving time on manual configurations.



# ROLES AND FUNCTIONS

The Ansible playbook is structured to ensure a smooth and systematic deployment of the Node.js application with MongoDB. Each role is carefully positioned to handle specific components of the deployment process, leveraging various Ansible modules to accomplish their tasks. Here’s a detailed explanation of each role and the modules used:

## 1. MongoDB Role

### Function
The MongoDB role is responsible for setting up the MongoDB database container. This includes ensuring Docker and Docker Compose are installed and then deploying the MongoDB container.

### Positioning
The MongoDB role is executed first because the frontend and backend services depend on the database. Ensuring the database is up and running before deploying the application components is crucial for their proper functionality.

### Modules Applied
- **`ansible.builtin.apt`**: Used to install Docker and Docker Compose on the target VMs if they are not already installed.
- **`ansible.builtin.command`**: Used to run Docker commands to start the MongoDB container.
- **`ansible.builtin.copy`**: Copies the `docker-compose.yml` file to the appropriate location on the target VMs.
- **`ansible.builtin.service`**: Ensures the Docker service is running.

#### Tasks in `mongodb/tasks/main.yml`:
```yaml
---
- name: Install Docker
  ansible.builtin.apt:
    name: docker.io
    state: present

- name: Install Docker Compose
  ansible.builtin.apt:
    name: docker-compose
    state: present

- name: Copy docker-compose file
  ansible.builtin.copy:
    src: ../../docker-compose.yml
    dest: /home/vagrant/docker-compose.yml

- name: Start MongoDB container
  ansible.builtin.command:
    cmd: docker-compose up -d yolo-web-mongodb
    chdir: /home/vagrant
```

## 2. Frontend Role

### Function
The frontend role handles the deployment of the frontend application. It involves cloning the frontend code from GitHub and deploying the frontend container using Docker Compose.

### Positioning
This role is executed after the MongoDB role because the frontend may need to communicate with the database. Ensuring the database service is operational before deploying the frontend ensures that any database-related functionality can be tested and used immediately.

### Modules Applied
- **`ansible.builtin.git`**: Clones the frontend repository from GitHub.
- **`ansible.builtin.command`**: Runs Docker commands to build and start the frontend container.
- **`ansible.builtin.copy`**: Copies the `docker-compose.yml` file to the appropriate location on the target VMs.

#### Tasks in `frontend/tasks/main.yml`:
```yaml
---
- name: Clone frontend repository
  ansible.builtin.git:
    repo: 'https://github.com/yourusername/frontend-repo.git'
    dest: /home/vagrant/frontend

- name: Copy docker-compose file
  ansible.builtin.copy:
    src: ../../docker-compose.yml
    dest: /home/vagrant/docker-compose.yml

- name: Start frontend container
  ansible.builtin.command:
    cmd: docker-compose up -d yolo-web-client
    chdir: /home/vagrant
```

## 3. Backend Role

### Function
The backend role is responsible for deploying the backend application. This involves cloning the backend code from GitHub and deploying the backend container using Docker Compose.

### Positioning
This role is executed after the MongoDB and frontend roles. The backend might interact heavily with both the frontend and the database. By positioning the backend role last, we ensure that the database and frontend services are fully operational before the backend starts, allowing for complete end-to-end functionality to be tested and used.

### Modules Applied
- **`ansible.builtin.git`**: Clones the backend repository from GitHub.
- **`ansible.builtin.command`**: Runs Docker commands to build and start the backend container.
- **`ansible.builtin.copy`**: Copies the `docker-compose.yml` file to the appropriate location on the target VMs.

#### Tasks in `backend/tasks/main.yml`:
```yaml
---
- name: Clone backend repository
  ansible.builtin.git:
    repo: 'https://github.com/yourusername/backend-repo.git'
    dest: /home/vagrant/backend

- name: Copy docker-compose file
  ansible.builtin.copy:
    src: ../../docker-compose.yml
    dest: /home/vagrant/docker-compose.yml

- name: Start backend container
  ansible.builtin.command:
    cmd: docker-compose up -d yolo-web-backend
    chdir: /home/vagrant
```

## Conclusion

The playbook’s sequential execution ensures a smooth deployment process by setting up necessary dependencies before the dependent components. The MongoDB role ensures the database is ready, the frontend role sets up the user interface that interacts with the database, and the backend role completes the setup by handling server-side operations that might involve both the frontend and the database. Each role uses specific Ansible modules to manage tasks efficiently, leveraging `apt` for package installation, `git` for code retrieval, `command` for running Docker commands, and `copy` for managing configuration files.

# DATA PERSISTENCE

The data should persist because the Docker Compose configuration includes a volume for MongoDB. Docker volumes ensure that data is stored outside of the container's filesystem, meaning it remains intact even if the container is stopped, removed, or recreated.
When you restart the MongoDB container, it will use the same volume `(yolo_mongodb_data)`, and all the data previously stored in MongoDB will still be available.