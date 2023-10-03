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
ansible-galaxy install pc_admin.ansible_role_ufw
```


## Create Proxmox VM Template (If creating Proxmox VMs)

1) Create a new VM in Proxmox with either Debian 12 or Ubuntu 22.04.

2) Make the root disk 10GB with LVM and a single root volume group+partition with no swap.

3) Install QEMU guest agent and enable it, also install sudo:
```
apt install qemu-guest-agent -y
systemctl enable qemu-guest-agent
apt install sudo -y
```

4) Add SSH keys to the desired user account.
```
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcRcwVe1sUuizIFVVf6MXK8wYlY557gX38FKVZRB5jc Testing 2023 SSH Key - Michael Collins' > ~/.ssh/authorized_keys
```

5) Harden the SSH service. Edit the following lines in `/etc/ssh/sshd_config`:
```
PasswordAuthentication no
PermitEmptyPasswords no
```

6) Collect the ed25519 host key from the template, then add it to the `proxmox_template_host_key` variable in your inventories file:
`cat /etc/ssh/ssh_host_ed25519_key.pub`

7) Collect the systemd machine-id from the template, then add it to the `proxmox_template_machine_id` variable in your inventories file:
`cat /etc/machine-id`

8) Shutdown the VM and create a template from it through the Proxmox GUI.


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
- Expand VM disk size with: https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_disk_module.html
- Batch testing for playbook changes
- cleanup known hosts when deleting servers
