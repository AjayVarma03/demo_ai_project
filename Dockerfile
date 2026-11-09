# Step 1: Build the app
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Step 2: Serve using NGINX on port 3000
FROM nginx:alpine
# If using Vite, change /app/build to /app/dist
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 3000 (matching your ECS task definition)
EXPOSE 3000

# Configure NGINX to listen on port 3000 instead of default 80
RUN sed -i 's/listen       80;/listen       3000;/' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
