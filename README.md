# Ansible Provision Servers

This playbook configures 1 to N servers using either DigitalOcean or a Proxmox cluster, it also adds/removes the DNS records for each server automatically using CloudFlare.

It also automatically configures ~/.ssh/config and ~/.hosts files to allow for an immediate SSH connection, so you can start working sooner!

I created it as a devops tool to speed up testing.


## Prerequisites

Some packages need to be installed on the ansible controller to provision VMs on Proxmox:
```
$ pip3 install proxmoxer
$ pip3 install requests
$ ansible-galaxy collection install community.general
```


## Setup Servers

1) Configure the [inventory/](inventory/) files for all the desired hosts appropriately.

2) Configure the DigitalOcean and CloudFlare API keys in [group_vars/all](group_vars/all).

3) Run the spawn.yml playbook:

`$ ansible-playbook -v -i inventory/hosts spawn.yml`

Or even easier, provision a server with automatic CloudFlare DNS configuration:

`$ ansible-playbook -v -i inventory/hosts --tags "cloudflare-dns" spawn.yml`


## Removing Servers

`$ ansible-playbook -v -i inventory/hosts remove.yml`

Or remove a server and it's CloudFlare DNS record automatically:

`$ ansible-playbook -v -i inventory/hosts --tags "cloudflare-dns" remove.yml`


## License

Copyright 2022 Michael Collins

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
