# Get public IPv4 and public IPv6 address

Get public IPv4 & IPv6 via `curl` or `wget` using the OpenSource Public IP Address API from [https://www.ipify.org](https://www.ipify.org).
Your public IPv4 & IPv6 get stored for further use.

`curl` is used to send email notifications.


### :gear: Requirements

- Internet connection
- `curl` or `wget` (NOTE: email notification only works using `curl`)


### :wrench: Usage

#### Prerequisites

To use `scp` to transfer your IP address files to your *Static-IP-Server* you first need to add your public ssh key
to your *Static-IP-Servers* authorized ssh keys:

`cat ~/.ssh/id_rsa.pub | ssh root@sever 'cat >> .ssh/authorized_keys'`

Confirm by entering your password.

You should now be able to ssh into your Static-IP-Server without entering the password.


#### Run the script manually

1. Download the `ddns.sh` script:

  `wget https://raw.githubusercontent.com/andi34/ddns/master/ddns.sh`

2. Make the script executable:

  `chmod +x ddns.sh`

3. Create /etc/ddns folder to store your IP address

  ```
  sudo -i
  mkdir -p /etc/ddns
  chmod 711 /etc/ddns
  ```

4. Change the config depending on your needs using your favourite text editor:

  `nano ddns.sh`


5. Run the script:

  `bash ddns.sh`


#### Setup cron job

1. Login as "root"

  `sudo -i`

2. Create /etc/ddns folder to store your IP address

  ```
  mkdir -p /etc/ddns
  chmod 711 /etc/ddns
  ```

3. Add a hourly cron job:

  ```
  cd /etc/cron.hourly
  wget https://raw.githubusercontent.com/andi34/ddns/master/etc/cron.hourly/ddns
  chmod 755 ddns
  cd /usr/local/bin
  wget https://raw.githubusercontent.com/andi34/ddns/master/ddns.sh
  mv ddns.sh ddns
  chmod 755 ddns
  ```


4. Change the config inside `/usr/local/bin/ddns` depending on your needs using your favourite text editor:

  `nano /usr/local/bin/ddns`


### :question: Troubleshooting

- **Error "curl: (67) Login denied.":**

  This may be because of your Google account security settings,
  please turn on less secure apps (https://www.google.com/settings/security/lesssecureapps) and try again.

- **How can i create a public and private key pair so i can use `ssh` and `scp` without using a password?**

  Use `ssh-keygen` to create your key pair, for example you can use `ssh-keygen -t rsa -b 4096 -C "root@localhost"`.


### :grey_question: TO-DO

- ?


### :tada: Donation

If you like my work and like to keep me motivated you can buy me a coconut water:

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/andreasblaesius)
