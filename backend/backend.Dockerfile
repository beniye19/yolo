FROM node:13.12.0-slim
LABEL maintainer="beniyemwangi@gmail.com"
WORKDIR /MyApp
COPY ./package.json /MyApp/package.json
RUN npm install
COPY . /MyApp

EXPOSE 5000

CMD [ "npm", "start"] 