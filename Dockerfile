# Use a compatible version of Node.js that meets Wetty's requirements
FROM node:18-alpine as builder

# Install build dependencies for native modules
RUN apk add --no-cache make g++ python3

# Optionally update npm to the latest version
RUN npm install -g npm@latest

# Install Wetty globally
RUN npm install -g wetty

# Build stage for customizations (if any)

FROM node:16-alpine

# Copy Wetty from the builder stage
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin

# Install openssh and openssl
RUN apk add --no-cache openssh openssl \
    && echo "root:root" | chpasswd

# Generate a self-signed certificate (or use your own)
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/wetty.key -out /etc/ssl/certs/wetty.crt -days 365 -nodes -subj '/CN=localhost'

# Expose Wetty's default port
EXPOSE 3000

# Run Wetty with the specified configuration
CMD ["wetty", "-p", "3000", "--ssh-host", "localhost", "--ssh-user", "root", "--ssh-auth", "password"]
