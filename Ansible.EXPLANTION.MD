# CONFIGURATION MANAGEMENT REAMDME

This repository contains a Node.js application with a frontend and backend, as well as a MongoDB database. The application is containerized using Docker and Docker Compose. We use Vagrant and Ansible to automate the setup and deployment process on virtual machines.

## Prerequisites

Before you begin, ensure you have the following software installed:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Directory Structure

```plaintext
my-nodejs-app/
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
├── docker-compose.yml
├── Vagrantfile
└── README.MD

```

### Explanation of Playbook Execution Order

The order of execution in the Ansible playbook follows a logical sequence to ensure smooth deployment of the Node.js application with MongoDB. Here’s a more detailed breakdown of the reasoning behind the order:

#### 1. Loading Variables (`vars_files` Section)

The playbook begins by loading variables from the `group_vars/all.yml` file. These variables are essential for configuring various aspects of the deployment, such as paths, repository URLs, and version numbers. Loading variables at the beginning ensures consistency and allows for easy management of configuration settings.

#### 2. Pre-Task Installation (`pre_tasks` Section)

The pre-tasks section performs initial setup steps before executing the main roles. In this playbook, the primary pre-task is to ensure that Git is installed on all target virtual machines. Since the subsequent tasks involve cloning repositories from GitHub, having Git installed is a prerequisite. By installing Git as a pre-task, we guarantee that it is available before attempting to clone repositories.

#### 3. Role Execution (`roles` Section)

Roles encapsulate sets of tasks related to specific components or functionalities of the deployment. The playbook includes three roles:

##### a. MongoDB Role

This role is responsible for setting up the MongoDB database. It includes tasks for installing Docker and Docker Compose (if not already installed) and deploying the MongoDB container. By executing this role first, we ensure that the database service is up and running before deploying the frontend and backend applications, which depend on MongoDB.

##### b. Frontend Role

The frontend role handles the deployment of the frontend application. It includes tasks for cloning the frontend repository from GitHub and deploying the frontend container using Docker Compose. Since the frontend application may rely on data stored in the MongoDB database, it's essential to deploy it after ensuring that the database service is operational.

##### c. Backend Role

Similar to the frontend role, the backend role deals with the deployment of the backend application. It clones the backend repository and deploys the backend container using Docker Compose. Like the frontend, the backend may interact with the MongoDB database, so it's deployed after ensuring that the database service is running.

#### Conclusion

The order of execution in the Ansible playbook follows a logical sequence to ensure smooth deployment of the Node.js application with MongoDB. By loading variables first, performing pre-installation tasks, and then executing roles in a specific order, we establish a robust foundation for deploying the application components. This approach minimizes errors, ensures dependencies are met, and sets up the environment for successful application deployment.




Sure, here's an explanation of each role's function and positioning in the playbook, including the Ansible modules applied in the tasks within the roles:

```markdown
# Explanation of Each Role's Function and Positioning in the Playbook

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
```

This Markdown document provides a detailed explanation of each role's function, positioning in the playbook, and the Ansible modules used in the tasks within each role.
