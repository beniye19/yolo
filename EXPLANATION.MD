# CHOICE OF BASE IMAGES

## 1. **Choice of the base image for MongoDB container (mongo:latest)**:
    - MongoDB is a database management system, and the `mongo:latest` image provides a pre-configured environment for running MongoDB. Using the `mongo:latest` image ensures that we have a stable and up-to-date version of MongoDB without the need for manual installation and configuration. Additionally, the `latest` tag ensures that we get the most recent stable release of MongoDB, which includes bug fixes and security patches.

## 2. **Choice of the base image for Node.js container (node:16-alpine3.17)**:
    - For the Node.js container, using the `node:16-alpine3.17` image offers several advantages. Alpine Linux is a lightweight Linux distribution, and the `alpine` tag signifies that the image is based on Alpine Linux. This results in a smaller image size compared to images based on other Linux distributions, which reduces the overall size of the Docker image and improves deployment efficiency. Additionally, the `node:16` tag ensures that we have Node.js version 16, which provides access to the latest features and enhancements available in Node.js. Using an Alpine-based image combined with Node.js version 16 offers a balance between a lightweight environment and access to the latest Node.js features, making it a suitable choice for building Node.js applications in Docker containers.


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
