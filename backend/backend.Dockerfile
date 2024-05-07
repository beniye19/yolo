
#nodejs lightweight base image
FROM  node:18-alpine3.17  

#backend workdir
WORKDIR /app/backend
#The email address of the person responsible for maintaining this Dockerfile or image.
LABEL maintainer="beniyemwangi@gmail.com"

#copying backend dependancies
COPY package*.json ./

#install backend dependancies
RUN npm ci --production

# Copy the rest of the project files
COPY . .

VOLUME /data/db

EXPOSE  5000

#run project
CMD ["npm", "start"]