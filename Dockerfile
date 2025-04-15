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

# Expose Vite development server port
EXPOSE 5173

# Start development server
CMD ["npm", "run", "dev", "--", "--host"]
