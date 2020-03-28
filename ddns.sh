#!/bin/bash
#
# Use OpenSource Public IP Address API from https://www.ipify.org
#
# No-IP IP Detection Service: https://www.noip.com/integrate/ip-detection
# Request Method: https://www.noip.com/integrate/request
#

v4_file=$HOME/.ddns_v4.addr
v6_file=$HOME/.ddns_v6.addr
old_ipv4=''
old_ipv6=''

# Stop on the first sign of trouble
set -e

# Check if curl or wget are available
if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
else
  echo "Neither curl nor wget found! Please install curl or wget."
  sleep 5
  exit 1
fi

# Stored IPv4 & IPv6?
[ -e $v4_file ] && old_ipv4=`cat $v4_file`
[ -e $v6_file ] && old_ipv6=`cat $v6_file`

# Get public IPv4 & IPv6
# Use OpenSource Public IP Address API from ipify.org
#
# No-IP remote IP detection service to check for IP address changes:
# IPv4 http://ip1.dynupdate.no-ip.com/
# IPv6 http://ip1.dynupdate6.no-ip.com/
#
ipv4=$($bin "https://api.ipify.org")
echo "IPv4: $ipv4"
ipv6=$($bin "https://api6.ipify.org")
echo "IPv6: $ipv6"

# IPv4 check
if [ -z "$ipv4" ]; then
  echo "no IPv4 address found"
  sleep 5
  exit 1
elif [ "$old_ipv4" = "$ipv4" ]; then
  echo "IPv4 address unchanged"
else
  # save current address
  echo $ipv4 > $v4_file
fi

# IPv6 check
if [ -z "$ipv6" ]; then
  echo "no IPv6 address found"
  sleep 5
  exit 1
elif [ "$old_ipv6" = "$ipv6" ]; then
  echo "IPv6 address unchanged"
else
  # save current address
  echo $ipv6 > $v6_file
fi

# Exit if IPv4 & IPv6 are unchanged
if [[ "$old_ipv4" = "$ipv4" && "$old_ipv6" = "$ipv6" ]]; then
  echo "IPv4 and IPv6 not changed!"
  sleep 5
  exit 1
fi

# TO-DO:
# If IP changed use "scp" to transfer the new IP to our static-IP-Server,
# or send changed IP via E-Mail.