# Combined Dockerfile
# Use multi-stage build for both backend and client
FROM node:18-alpine3.17 AS builder
LABEL maintainer="beniyemwangi@gmail.com"

# Backend build stage
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci --production && npm cache clean --force
COPY backend .

# Client build stage
WORKDIR /MyApp
COPY client/package*.json ./
RUN npm ci --production && npm cache clean --force
COPY client .

# Final image stage
FROM node:18-alpine3.17

# Backend setup
WORKDIR /app/backend
COPY --from=builder /app/backend .
VOLUME /data/db
EXPOSE 5000

# Client setup
WORKDIR /MyApp
COPY --from=builder /MyApp .
EXPOSE 3000

CMD ["npm", "start"]
