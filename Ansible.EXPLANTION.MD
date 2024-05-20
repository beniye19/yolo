# (A) OVERVIEW

This repository contains a Node.js application with a frontend and backend, as well as a MongoDB database. The application is containerized using Docker and Docker Compose. We use Vagrant and Ansible to automate the setup and deployment process on virtual machines.

## Prerequisites

Before you begin, ensure you have the following software installed:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Directory Structure

```plaintext

yolo/
├── Stage_two/ (Contains files)
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


# (B) ROLES AND FUNCTIONS

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

# (C) DATA PERSISTENCE

The data should persist because the Docker Compose configuration includes a volume for MongoDB. Docker volumes ensure that data is stored outside of the container's filesystem, meaning it remains intact even if the container is stopped, removed, or recreated.
When you restart the MongoDB container, it will use the same volume `(yolo_mongodb_data)`, and all the data previously stored in MongoDB will still be available.

.vscode
backend/
client/
Ansible.EXPLANTION.MD
DockerHubSC.png
EXPLANATION.MD
beniye-yolo-web-backend.png
beniye-yolo-web-client.png
