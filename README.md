# Directory Structure

```plaintext

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
│   ├── Playbook.yml
│   ├── Stage_two/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── .vscode/ (Contains files)
├── backend/ (Contains files)
├── client/ (Contains files)
├── docker-compose.yml
├── Vagrantfile
├── README.MD
├── DockerHubSC.png
├── DOCKER.EXPLANATION.MD
├── beniye-yolo-web-backend.png
└── beniye-yolo-web-client.png

```



# Installation Guide

Before proceeding, ensure you have the following prerequisites installed:

- [Node.js](https://nodejs.org/) 
- npm (Node Package Manager)
- [MongoDB](https://www.mongodb.com/try/download/community) 

## Step 1: Install Node.js and npm

If you haven't already, install Node.js and npm by following the instructions [here](https://nodejs.org/).

## Step 2: Install MongoDB

Follow the instructions to [install MongoDB](https://docs.mongodb.com/manual/administration/install-community/) based on your operating system. Once installed, start the MongoDB service. For example, on Ubuntu, you can start the service with:

```bash
sudo service mongod start
```

## Step 3: Clone the Repository

Clone the project repository from GitHub:

```bash
git clone https://github.com/your-repo-url.git
```

Replace `your-repo-url` with the actual URL of your repository.

## Step 4: Navigate to Client Folder

Navigate to the client directory of the project:

```bash
cd your-project-directory/client
```

## Step 5: Install Frontend Dependencies

Run the following command to install the frontend dependencies:

```bash
npm install
```

## Step 6: Start the Frontend

Start the frontend application:

```bash
npm start
```

## Step 7: Navigate to Backend Folder

Open a new terminal window/tab, then navigate to the backend directory of the project:

```bash
cd your-project-directory/backend
```

## Step 8: Install Backend Dependencies

Install the backend dependencies:

```bash
npm install
```

## Step 9: Start the Backend

Start the backend server:

```bash
npm start
```

## Step 10: Add a Product

Once both the frontend and backend are running, you can navigate to the application in your web browser and add a product. Note that the price field only accepts numeric input.

---