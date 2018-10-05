#!/bin/bash

if [ -z "${1}" ]; then
   /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n -e debug
else
  exec "$@"
fi
