 # nasghoi
FROM ubuntu:24.04

# Set timezone and suppress prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kuala_Lumpur

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    tzdata \
    nginx \
    nano \
    unzip \
    git && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Install Node.js (LTS 20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy rest of source code
COPY . .

# Build Vite-based React app
RUN npm run build

# Clear default Nginx HTML files
RUN rm -rf /var/www/html/*

# Copy Vite build output (dist) to Nginx
RUN cp -r dist/* /var/www/html/

# Nginx config for SPA routing support
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /var/www/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/sites-available/default

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
