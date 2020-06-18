#!/bin/sh
set -e
# Import SSH keys
if [ -d /tmp/.ssh ]; then
  cp -R /tmp/.ssh /root/.ssh
  chmod 600 /root/.ssh/*
fi
# Forward command
/bin/sh -c -l "$*"
