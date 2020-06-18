#!/bin/sh

set -e

# Import SSH keys
if [ -f /tmp/.ssh/id_rsa ]; then
    cp -R /tmp/.ssh /root/.ssh
    chmod 600 /root/.ssh/id_rsa
fi

# Forward command
/bin/sh -c -l "$*"
