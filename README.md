
# Ansible Provision Servers

This playbook configures 1 to N servers using either DigitalOcean or a Proxmox cluster, it also adds/removes the DNS records for each server automatically using CloudFlare.

It also automatically adds new hosts to your known_hosts to allow for an immediate SSH connection, so you can start working sooner!

It was created as a devops tool to help speed up testing.


## Prerequisites

Some packages need to be installed on the ansible controller to provision VMs on Proxmox:
```
pip3 install proxmoxer
pip3 install requests
ansible-galaxy collection install community.general
ansible-galaxy install PC-Admin.ansible_role_ufw
```


## Prepare Proxmox Templates

For creating Proxmox templates to use with this playbook, see [docs/create_proxmox_templates.md](docs/create_proxmox_templates.md).


## Setup Servers

1) Configure the [inventories/](inventories/) files for all the desired inventories and hosts appropriately.

2) Configure the DigitalOcean and CloudFlare API keys in [group_vars/all](group_vars/all).
```
cp -n group_vars/all.example group_vars/all
nano group_vars/all
```

3) Run the spawn.yml playbook:

`ansible-playbook -v -i inventories/demo/hosts spawn.yml`


## Removing Servers

`ansible-playbook -v -i inventories/demo/hosts remove.yml`


## Tags

To only remove CloudFlare DNS records, use the `cloudflare-dns` tag:

`ansible-playbook -v -i inventories/demo/hosts --tags cloudflare-dns remove.yml`


## License

Copyright 2023 Michael Collins

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Roadmap

- Stop preserving variables in inventory files - DONE
- Figure out a better (more reliable) SSH hostkey system (should collect hostkey from template?) - DONE
- add dynamic firewall section for UFW - https://github.com/application-research/haproxy-cluster-playbook/compare/main...PC-Admin:haproxy-cluster-playbook:ufw-changes - DONE
- create custom systemd machine-id for each Proxmox VM if it differs from the template - DONE
- Expand VM disk size with: https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_disk_module.html - DONE
- Allow adjustment of VM resources (CPU, RAM, Ballooning) - DONE
- Seperate UFW sections into a seperate playbook as it's overkill for some use cases
- Alert the user when unapplied changes are detected in Proxmox hosts (So they can manually restart these hosts)
- Saner DNS advice? (should only display if the playbook isn't setting DNS at all)
- Batch testing for playbook changes
- Cleanup known hosts when deleting servers
