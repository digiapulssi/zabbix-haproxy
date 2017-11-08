#!/bin/bash
set -e

# Find all ports that HAProxy listens to and print them in discovery format
# Arguments:
#  1) minport  (minimum port number to include, by default 0)
#  2) maxport  (maximum port number to include, by default 65535)
#  3) HAProxy configuration file path (by default /etc/haproxy/haproxy.cfg)

minport="${1:-0}"
maxport="${2:-65535}"
configfile="${3:-/etc/haproxy/haproxy.cfg}"

# Bind syntax may be like
# bind :80
# bind 10.0.0.1:10080
# bind ipv6@:80
# bind *:80
# bind :80,:443 (multiple ports, not supported by this script so far)

echo -n '{"data":['
sed -n -e "s/^\s\+bind \(.*@\)\{0,1\}\(.*\):\([0-9]\+\).*/\2:\3/p" "$configfile" \
  | awk -F ':' '$2>='"$minport" \
  | awk -F ':' '$2<='"$maxport" \
  | sed 's/^\*:/0.0.0.0:/' \
  | sed 's/^:/0.0.0.0:/' \
  | sed 's/\(.*\):\(.*\)/{"{#IP}":"\1","{#PORT}":"\2"}/g' \
  | sed '$!s/$/,/' \
  | tr '\n' ' '
echo -n ']}'

