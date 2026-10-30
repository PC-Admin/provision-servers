
# Changelog

All notable changes to this project are listed here.


## 2026-10-30

### Upgrade notes

- `spawn_on_proxmox` is no longer `true` or `false`. Change `true` to `'clone'` in your inventory files. If you don't, `spawn.yml` skips those hosts without failing, and `remove.yml` deletes their DNS records but leaves the VM running.
- Ansible now runs from a Python venv. Follow the new Prerequisites steps in the [README](README.md).

### Added

- An `'iso'` mode for Proxmox, which installs Debian from an ISO image on a Proxmox storage without any input (tested with Debian 13). See [docs/proxmox_iso_installs.md](docs/proxmox_iso_installs.md).
- The `proxmox_iso_storage` and `proxmox_iso` variables.
- `requirements.txt` and `requirements.yml` with pinned versions, installed into `.venv`.
- Debian 13 (trixie) support in the setup-server role.
- A demo inventory example for an ISO host (`scrutiny.bestozvapes.com`).
- [docs/proxmox_other_notes.md](docs/proxmox_other_notes.md) with fixes for common Proxmox errors.

### Changed

- `spawn_on_proxmox` now takes `'clone'`, `'iso'` or `false`.
- Proxmox tasks use the `community.proxmox` module names. The Proxmox login settings are set once, in `module_defaults` in `spawn.yml` and `remove.yml`.
- Proxmox API calls no longer check TLS certificates (`validate_certs: no`), as the nodes use self-signed certificates.
- The ufw role is installed from GitHub, as it's no longer on Ansible Galaxy.
- The guest agent IP check now really waits up to 180 seconds.
- The unattended-upgrades setup on Debian is a single task that only uncomments existing lines.
- The demo inventory examples (`matrix.testing.org`, `pg01.testing.org`, `pg02.testing.org`) use `spawn_on_proxmox: 'clone'` and Debian 12.

### Removed

- Debian 11 (bullseye) and Ubuntu 20.04 (focal) support.

### Fixed

- Conditions that newer ansible-core versions reject as errors, in `resize_root_partition.yml` and `swap_file.yml`.
- The demo inventory examples were missing `proxmox_root_disk_size`, which the playbook needs.
