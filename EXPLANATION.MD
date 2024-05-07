# CHOICE OF BASE IMAGES

## 1. **Choice of the base image for MongoDB container (mongo:latest)**:
MongoDB is a database management system, and the `mongo:latest` image provides a pre-configured environment for running MongoDB. Using the `mongo:latest` image ensures that we have a stable and up-to-date version of MongoDB without the need for manual installation and configuration. Additionally, the `latest` tag ensures that we get the most recent stable release of MongoDB, which includes bug fixes and security patches.

## 2. **Choice of the base image for Node.js container (node:16-alpine3.17)**:
 For the Node.js container, using the `node:16-alpine3.17` image offers several advantages. Alpine Linux is a lightweight Linux distribution, and the `alpine` tag signifies that the image is based on Alpine Linux. This results in a smaller image size compared to images based on other Linux distributions, which reduces the overall size of the Docker image and improves deployment efficiency. Additionally, the `node:16` tag ensures that we have Node.js version 16, which provides access to the latest features and enhancements available in Node.js. Using an Alpine-based image combined with Node.js version 16 offers a balance between a lightweight environment and access to the latest Node.js features, making it a suitable choice for building Node.js applications in Docker containers.


# DOCKER DIRECTIVES TO CREATE AND RUN CONTAINERS

Docker directives are commands used to build Docker images and define the runtime behavior of containers. Here's a brief explanation my choice of Docker directives:

``` 
FROM  node:16-alpine3.17  
WORKDIR /MyApp
LABEL maintainer="beniyemwangi@gmail.com"
COPY package*.json ./
RUN npm ci --production
COPY . .
EXPOSE 3000
CMD ["npm", "start"] 
```
Explanation:

**FROM** It starts with the node:16-alpine3.17 image, which is a lightweight image based on Alpine Linux containing Node.js version 16.

**WORKDIR:** Sets the working directory inside the container to /MyApp.

**Maintainer Label:** Adds a label specifying the email address of the person responsible for maintaining the Dockerfile or image.

**COPY:** Copies package.json and package-lock.json (if present) from the host into the container's working directory.

**RUN:** Runs npm ci --production to install production dependencies from package-lock.json, ensuring reproducible builds.

**COPY:** Copies the rest of the project files from the host into the container's working directory.

**EXPOSE:** Exposes port 3000 from the container to the host, indicating that the client-side application inside the container is expected to be accessible on port 3000.

**CMD:** Defines the default command to run when the container starts, running npm start, presumably to start the client-side application.


# DOCKER COMPOSE NETWORKING

Networks:

**`yolo-mongodb`** Network: A custom bridge network created for communication between the MongoDB service and the backend service.

**`yolo-client`** Network: Another custom bridge network created for communication between the client service and the backend service.

Overall, the Docker Compose file is designed to facilitate communication between the client-side application, backend server, and MongoDB database while ensuring reliable service startup and data persistence through appropriate port allocation, network configuration, volume mounting, and restart policies.

# DOCKER COMPOSE VOLUMES

1. MongoDB Service (yolo-web-mongodb):
A volume named yolo_mongodb_data is defined to persist MongoDB data at /data/db.

2. Client Service (yolo-web-client):
The ./frontend directory from the host is mounted into the container's /usr/src/app directory.
The /usr/src/app/node_modules directory is mounted to allow caching of dependencies between container restarts.

3. Backend Service (yolo-web-backend):
The ./backend directory from the host is mounted into the container's /usr/src/app directory.
The /usr/src/app/node_modules directory is mounted to allow caching of dependencies between container restarts.

These volumes enable persistence of MongoDB data and provide access to application code from the host within the containers, enhancing flexibility and data management capabilities in the Docker environment.

# WHICH GIT WORKFLOW WAS USED?

The ***fork workflow*** is a common practice in collaborative software development using version control systems like Git. It involves creating a personal copy (fork) of a repository owned by another user or organization, making changes to that copy, and then proposing those changes to be merged back into the original repository via pull requests.

Here's a step-by-step explanation of the fork workflow:

1. **Fork the Repository**: On platforms like GitHub, GitLab, or Bitbucket, you can fork a repository by clicking the "Fork" button on the repository's page. This creates a copy of the repository under your account.

2. **Clone Your Fork**: After forking, clone your forked repository to your local machine using Git. This creates a local copy of the repository that you can work with.

3. **Make Changes**: Make changes to the codebase in your local repository. You can add new features, fix bugs, or make any other modifications.

4. **Commit Changes**: Once you've made changes, commit them to your local repository using Git. Commits record the changes you've made along with a descriptive message.

5. **Push Changes to Your Fork**: After committing your changes locally, push them to your forked repository on the hosting platform using Git. This updates your fork with the changes you've made.

6. **Create a Pull Request**: On the hosting platform, navigate to your forked repository and create a pull request (PR) to propose merging your changes into the original repository. In the pull request, you can describe the changes you've made and provide any relevant context.

7. **Collaborate and Review**: Other contributors to the original repository can review your pull request, provide feedback, and suggest changes. The pull request serves as a discussion forum for collaboration.

8. **Merge Changes**: If the maintainers of the original repository approve your pull request, they can merge your changes into the main branch of the original repository. This incorporates your contributions into the project.

The fork workflow enables collaborative development by allowing developers to work on features or fixes independently in their own forks before proposing them for inclusion in the main project. It helps maintain a clean and organized codebase while facilitating contributions from a broader community of developers.

# DEBUGGING MEASURES IN DOCKER
In Docker, I often use the following debugging measures:

1. **Logging**: I leverage Docker's logging features to capture and analyze container output, including standard output and error streams. This helps me understand container behavior and diagnose issues.

2. **Container Inspect**: I use `docker inspect` to retrieve detailed information about containers, including configuration, networking, and volume mounts. This helps me troubleshoot configuration problems and understand container environments.

3. **Exec into Containers**: With `docker exec`, I can access a running container's shell and interactively debug issues. This allows me to inspect the container's filesystem, run commands, and troubleshoot in real-time.

4. **Healthchecks**: I define health checks in Dockerfiles or Docker Compose files to monitor container health. This helps me detect and address issues automatically, ensuring containers are running as expected.

In Docker Compose, I extend these debugging measures with additional capabilities:

1. **Service Logs**: I use `docker-compose logs` to view logs from all services defined in a Compose file. This aggregates logs from multiple containers, providing a comprehensive view of the application's behavior.

2. **Attach to Services**: With `docker-compose exec`, I can attach to a specific service container and debug issues interactively. This allows me to troubleshoot individual services within a multi-container environment.

3. **Scale Down**: I scale down services using `docker-compose scale` to isolate issues and reduce resource consumption during debugging. This helps me focus on specific components and streamline the debugging process.

These debugging measures in Docker and Docker Compose empower me to effectively identify and resolve issues, ensuring smooth operation of containerized applications.

# BEST PRACTICES IN DOCKER
Good practices for Docker image tag naming standards help in ensuring clarity, consistency, and ease of identification of images and containers across development, testing, and production environments. Here are some practices:

1. **Use Semantic Versioning**: Follow semantic versioning (SemVer) for version numbers in tags. Semantic versioning consists of three numbers: `<major>.<minor>.<patch>`. This helps to convey the significance of changes at a glance. For example, `1.0.0`, `2.1.3`, etc.

2. **Avoid Using 'latest'**: Avoid using the `latest` tag for production deployments. It's better to use specific version tags to prevent unexpected updates and ensure reproducibility.

3. **Include Metadata in Tags**: Include relevant metadata in tags to convey additional information about the image, such as the version of dependencies, build number, or environment. For example, `app:v1.2.3-node14-alpine`.

4. **Consistent Tagging Across Environments**: Maintain consistency in tagging across different environments (development, testing, production) to avoid confusion and ensure consistency in deployment processes.

5. **Immutable Tags**: Once an image is tagged and pushed to a repository, avoid changing the tag to ensure immutability. Instead, create a new tag for each change to maintain a history of image versions.

6. **Use Short, Descriptive Tags**: Use short but descriptive tags that convey relevant information about the image. Avoid overly long or cryptic tags that are difficult to understand.

7. **Versioning with Git Commits**: Integrate versioning with Git commits or Git tags to automate versioning of Docker images based on code changes. This ensures that each image corresponds to a specific version of the codebase.

8. **Automate Tagging and Versioning**: Implement automation tools or scripts to automate tagging and versioning of Docker images. This helps to reduce manual errors and ensures consistency across the CI/CD pipeline.

9. **Document Tagging Standards**: Document tagging standards and guidelines within the development team to ensure that all team members follow the same conventions.

By following these practices, you can improve the clarity, consistency, and maintainability of Docker images and containers, making it easier to manage and deploy applications across different environments.
