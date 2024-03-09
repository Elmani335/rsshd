FROM alpine:3.16.3
LABEL org.opencontainers.image.authors="Emmanuel Frecon <efrecon@gmail.com>"

# Update the package list and upgrade existing packages
RUN apk update && apk upgrade

# Install the necessary packages
RUN apk add --no-cache openssh shellinabox openssl

COPY sshd.sh /usr/local/bin/

# Expose the Shell In A Box port (HTTPS by default uses 443)
EXPOSE 443

# Volume for SSL certificates, keys, and SSH host keys
VOLUME /etc/ssh/keys /etc/ssl/private /etc/ssl/certs

ENTRYPOINT ["/usr/local/bin/sshd.sh"]
