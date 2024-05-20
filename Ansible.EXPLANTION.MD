# My Node.js Application Deployment

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