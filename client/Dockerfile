
#nodejs lightweight base image
FROM  node:16-alpine3.17  

#client workdir
WORKDIR /MyApp
#The email address of the person responsible for maintaining this Dockerfile or image.
LABEL maintainer="beniyemwangi@gmail.com"
#copying client dependancies
COPY package*.json ./

#install client dependancies
RUN npm ci --production

# Copy the rest of the project files
COPY . .

#EXPOSE port 3000
EXPOSE 3000

#run client project
CMD ["npm", "start"]