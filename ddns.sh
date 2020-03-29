#!/usr/bin/env bash
#
# Use OpenSource Public IP Address API from https://www.ipify.org
#
# No-IP IP Detection Service: https://www.noip.com/integrate/ip-detection
# Request Method: https://www.noip.com/integrate/request
#
# curl is used to send email notifications (googlemail account works fine)
#

v4_file=/etc/ddns/.ddns_v4.addr
v6_file=/etc/ddns/.ddns_v6.addr
old_ipv4=''
old_ipv6=''

# Email config
mail_url="smtps://smtp.gmail.com:465"
always_send_email="false"	# true or false
mail_from="YOU@googlemail.com"
mail_name_from="YOUR NAME"
mail_rcpt="recipient@example.com"
mail_name_rcpt="RECIPIENT NAME"
mail_pw="PASSWORD"
# You could also store your password inside a file instead:
# mail_pw=`cat /PATH/TO/PASSWORD/FILE/password.txt`
mailtemplate="/etc/ddns/mail.txt"
mail_subject="Your public IP address changed!"

# Check if curl or wget are available
if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
  always_send_email="false"
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
if [[ $always_send_email != "true" && "$old_ipv4" = "$ipv4" && "$old_ipv6" = "$ipv6" ]]; then
  echo "IPv4 and IPv6 not changed! Not sending email!"
elif [ -e /usr/bin/curl ]; then
  DATE=$(date)
  cat > ${mailtemplate} <<EOF
From: "${mail_name_from}" <${mail_from}>
To: "${mail_name_rcpt}" <${mail_rcpt}>
Subject: ${mail_subject}

$DATE:
Hostname: $HOSTNAME

IPv4: $ipv4
IPv6: $ipv6

EOF

  if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "All addresses for the host:" >> ${mailtemplate}
    echo "$(hostname -I)" >> ${mailtemplate}
  fi

  # Let's define the user based on given config before sending the email
  mail_connect="${mail_from}:${mail_pw}"

  curl -fsS --url ${mail_url} --ssl-reqd \
    --mail-from ${mail_from} --mail-rcpt ${mail_rcpt} \
    --upload-file ${mailtemplate} --user ${mail_connect} --insecure

  if [ $? -ne 0 ]; then
    echo "Something went wrong!"
  else
    echo "Mail send!"
  fi
else
  echo "curl not found! Please install curl to send emails."
fi
sleep 5
