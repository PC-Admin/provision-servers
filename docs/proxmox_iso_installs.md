
## Install Proxmox VMs From an ISO Image

Instead of cloning a template, Proxmox VMs can be installed fresh from a Debian netinst ISO image (tested with Debian 13). The Debian installer runs unattended using the preseed file [roles/spawn-server/templates/preseed.cfg.j2](../roles/spawn-server/templates/preseed.cfg.j2), which sets up the same disk layout as the Proxmox templates (GPT with LVM, a single root volume and no swap partition) and adds your SSH key to the root account.

1) Upload a Debian amd64 netinst ISO to a Proxmox storage with the 'ISO image' content type, on each node you want to install VMs on.

2) Set the Proxmox provisioning mode and ISO variables in your inventories file:
```
spawn_on_proxmox: 'iso'
proxmox_iso_storage: "Crucial_SSD"
proxmox_iso: "debian-13.7.0-amd64-netinst.iso"
```

`spawn_on_proxmox` can be `'clone'` (full clone of `proxmox_template`), `'iso'` or `false`. The `proxmox_template`, `proxmox_template_host_key` and `proxmox_template_machine_id` variables aren't needed for ISO installs.

3) Run the spawn.yml playbook as usual. The VM is created with the ISO attached, booted into the installer and powered off once the install is finished, then the ISO is ejected and the VM is booted from its new disk.


### Notes

- The VM is booted into the installer with the `args` option, which can't be set with a Proxmox API token. So the playbook connects to the Proxmox host over SSH (with passwordless sudo) to set it, the same way it runs `qm guest` commands.

- Only VMs that are newly created get installed, so re-running spawn.yml won't reinstall an existing VM.

- VMs are given at least 2GB of RAM while the installer runs (with less the Debian 13 installer stops to warn it's in "low memory mode"), it's set back to `proxmox_kvm_memory` afterwards.

- The root password is set to a random value, log in with your SSH key. If you need to use the Proxmox console, set a root password with: `qm guest passwd <vmid> root`

- The locale, timezone, mirror and packages can be changed in the preseed file.

- If an install fails or is interrupted, remove the half-built VM with remove.yml before trying again.
