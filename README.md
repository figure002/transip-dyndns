# TransIP Dynamic DNS script

This script can be used to autmatically update the DNS entries of one or more
domains when a dynamic IP address is changed.

This script should be run on the server that the DNS entries should point to.
It should **not** be served by a webserver! That is, **don't** put this in your
`htdocs` or `www` folder or whatever.

When you use this script, it is advisable to set the Time To Live (TTL) of your
DNS records to 1 hour to limit the amount of downtime when the address changes.


## Requirements

Python 3.6 or higher and the `cryptography` and `requests` packages:

    pip install cryptography requests


## Setting up the script

1. Go to the TransIP Control Panel at <https://www.transip.nl/cp/account/api/>
   (Account > API) and enable the API. Add a key pair to generate a private
   key, this must be generated without the "whitelisted" option! (After change
   to an unknown dynamic IP, this new IP is not in the whitelist!)
2. Save the private key to a text file and ensure only you can read it
   (`chmod 600 key.asc`).
3. Make the script executable: `chmod +x transip-dyndns.py`
4. See `./transip-dyndns.py --help` for usage instructions.
5. Execute the `transip-dyndns.py` script on the command-line whenever you want
   the DNS to be automatically updated. You can use `cron` to do this
   periodically for you.


## Examples

IPv4 only, determined using an online service:

```sh
./transip-dyndns.py -u bob -k key.asc --ipv4 --domain example.com:@ --domain example.org:www
```

IPv4 only, with provided IP address:

```sh
./transip-dyndns.py -u bob -k key.asc --ipv4 192.0.2.44 --domain example.com:@ --domain example.org:www
```

IPv4 and IPv6:

```sh
./transip-dyndns.py -u bob -k key.asc --ipv4 --ipv6 2001:db8::ff00:42:8329 --domain example.com:@ --domain example.org:www
```


## IPv6 support

To enable IPv6 support, you need to add one argument to the command-line. This
is the current IPv6 address:

    ./transip-dyndns.py --ipv6 2001:db8::ff00:42:8329 ...

Alternatively, you can remove the argument. In that case, the script
will query an online service for the IPv6 address.

    ./transip-dyndns.py --ipv6 ...

Note that this method may result in a temporary IPv6 address (due to Privacy
Extensions). It is therefore highly recommended to supply a stable, SLAAC IPv6
address to this script directly. You can use the following command line to get
the current SLAAC IPv6 address from the `eth0` network interface:

    ip addr show eth0 | grep -Poh '(?<=inet6\s)[0-9a-f:]+(?=/64)' | grep -vm 1 '^fe80'


## Development

Use Pipenv to install the requirements inside a Python virtualenv:

```sh
# Install requirements.
sudo apt install make
pip install --user pipenv

# Create and start virtualenv.
pipenv install --dev
pipenv shell

# Check code for errors.
make lint

# Execute script.
./transip-dyndns.py --help
```
