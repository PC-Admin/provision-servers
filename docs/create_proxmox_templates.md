
## Create Proxmox VM Template (If creating Proxmox VMs)

1) Create a new VM in Proxmox with either Debian 12 or Ubuntu 22.04.

2) Make the root disk 10GB with LVM and a single root volume group+partition with no swap. Note that with Debian12 it still partitions smaller disks using MBR, to force it to create a GPT install:

After booting the Debian 12 installation medium you highlight the option to run the installer. (I chose the Graphical Installer option here.) You then hit the TAB key and it'll bring up the command that launches.

To the end of that command add "d-i:partman-partitioning/default_label=gpt" then you're good to go! Debian will use GPT instead of MBR.

![debian_gpt_install](https://github.com/PC-Admin/provision-servers/assets/29645145/9ea41a6f-aba7-42b1-a836-5b7b7236375c)

3) Install QEMU guest agent and enable it, also install sudo:
```
apt install qemu-guest-agent -y
systemctl enable qemu-guest-agent
apt install sudo -y
```

4) Add your SSH key to the desired user account.
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
