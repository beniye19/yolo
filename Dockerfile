# Stage 1: Build
FROM node:19.6.0-slim AS build
LABEL maintainer="beniyemwangi@gmail.com"
WORKDIR /MyApp
COPY package.json package-lock.json ./
RUN npm install
COPY . .
# I will add any build steps here if necessary

# Stage 2: Runtime
FROM node:19.6.0-slim AS runtime
LABEL maintainer="beniyemwangi@gmail.com"
WORKDIR /MyApp
COPY --from=build /MyApp .  # Copy built artifacts from the build stage
EXPOSE 3000
CMD [ "npm", "start" ]
