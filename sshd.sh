#!/usr/bin/env ash

# Your existing setup script content...

# Start the SSH service in the background
/usr/sbin/sshd -f ${SDIR}/sshd_config -D -e "$@" &

# Start Shell In A Box to serve SSH over HTTPS. Adjust certificate and key paths as needed.
shellinaboxd --cert=/etc/ssl/certs --disable-ssl-menu -s /:SSH:localhost &

# Keep the container running
wait
