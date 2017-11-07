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

echo -n '{"data":['
sed -n -e "s/^\s\+bind .*:\([0-9]\+\).*/\1/p" "$configfile" | awk '$1>='"$minport" | awk '$1<='"$maxport" | sed 's/\(.*\)/{"{#PORT}":"\1"}/g' | sed '$!s/$/,/' | tr '\n' ' '
echo -n ']}'

