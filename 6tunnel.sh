#!/bin/bash
#
# Setup 6tunnel for applications that don't speak IPv6
#

# Configuration
new_ip_file=/etc/ddns/.ddns_v6.addr
known_ip_file=/etc/ddns/.known_ddns_v6.addr
old_ip=""

PORTS=(
    '80'
    '443'
)

# Let the fun begin
if [[ ! -z $1 ]]; then
  new_ip=$1
elif [ -e $new_ip_file ]; then
  new_ip=`cat $new_ip_file`
else
  echo "No IP given or found!"
  sleep 5
  exit 0
fi

[ -e $known_ip_file ] && old_ip=`cat $known_ip_file`

if [ "$new_ip" = "$old_ip" ]; then
  echo "IP address unchanged"
  sleep 5
  exit 1
else
  # Add new IP to known_ip_file
  echo $new_ip > $known_ip_file

  # Setup 6tunnel rules
  for port in "${PORTS[@]}"; do
    # Check if port is in use already, if yes kill the process using it
    lsof -ti :${port} | xargs --no-run-if-empty kill -9

    # Setup 6tunnel and let it by default listen on IPv6 address (IPv4 is default)
    6tunnel ${port} ${new_ip} ${port} -6
  done
fi
