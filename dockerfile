
# Stage 1: Build the Angular application
FROM node:22-alpine AS build

WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy Angular source code
COPY . .

# Build the Angular application
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the Angular production build
COPY --from=build /app/dist/angular/browser /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
