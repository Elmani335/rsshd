FROM alpine:3.16.3
LABEL org.opencontainers.image.authors="Emmanuel Frecon <efrecon@gmail.com>"

RUN apk --update add openssh shellinabox openssl \
    && rm -rf /var/cache/apk/*

# Generate a self-signed certificate (You might want to use your own certificates)
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/shellinabox.key -out /etc/ssl/certs/shellinabox.crt -days 365 -nodes -subj '/CN=localhost'

COPY sshd.sh /usr/local/bin/

# Expose the Shell In A Box port (HTTPS by default uses 443)
EXPOSE 443

# Volume for SSL certificates, keys, and SSH host keys
VOLUME /etc/ssh/keys /etc/ssl/private /etc/ssl/certs

ENTRYPOINT /usr/local/bin/sshd.sh
