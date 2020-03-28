# Get public IPv4 and public IPv6 address

Get public IPv4 & IPv6 via `curl` or `wget` using the OpenSource Public IP Address API from [https://www.ipify.org](https://www.ipify.org).
Your public IPv4 & IPv6 get stored inside your home-directory for further use.

`curl` is used to send email notifications.


### Requirements

- Internet connection
- `curl` or `wget` (NOTE: email notification only works using `curl`)


### Usage

Make the script executable:

`chmod +x ddns.sh`

Run the script:

`bash ddns.sh`


### Troubleshooting

**Error "curl: (67) Login denied.":**

This may be because of your Google account security settings,
please turn on less secure apps (https://www.google.com/settings/security/lesssecureapps) and try again.


### TO-DO

If IP changed use "scp" to transfer the new IP to our static-IP-Server.
