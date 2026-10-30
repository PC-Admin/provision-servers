
# Proxmox Other Notes

## Common Issues


### "VM with name = X not exist in cluster"

```
TASK [spawn-server : Create a full clone of the template for each host (sequentially)] **********************************************************************************************************************************************************
failed: [haproxy01.michael5collins.com -> localhost] (item=haproxy01.michael5collins.com) => {"ansible_loop_var": "item", "changed": false, "item": "haproxy01.michael5collins.com", "msg": "VM with name = ubuntu22-template-10g-4 does not exist in cluster"}
```

You either:

- Need to upgrade your Proxmox API token.
or
- Need to re-add the storage pool in Datacentre > Storage.


### "QEMU guest agent is not running"

```
TASK [spawn-server : Probe proxmox host for VMs network details for up to 180 seconds] **********************************************************************************************************************************************************
FAILED - RETRYING: [haproxy01.michael5collins.com -> jigglypuff]: Probe proxmox host for VMs network details for up to 180 seconds (3 retries left).
FAILED - RETRYING: [haproxy01.michael5collins.com -> jigglypuff]: Probe proxmox host for VMs network details for up to 180 seconds (2 retries left).
FAILED - RETRYING: [haproxy01.michael5collins.com -> jigglypuff]: Probe proxmox host for VMs network details for up to 180 seconds (1 retries left).
failed: [haproxy01.michael5collins.com -> jigglypuff] (item=haproxy01.michael5collins.com) => {"ansible_loop_var": "item", "attempts": 3, "changed": true, "cmd": ["qm", "guest", "cmd", "115", "network-get-interfaces"], "delta": "0:00:03.595935", "end": "2024-09-21 13:54:30.398825", "item": "haproxy01.michael5collins.com", "msg": "non-zero return code", "rc": 255, "start": "2024-09-21 13:54:26.802890", "stderr": "QEMU guest agent is not running", "stderr_lines": ["QEMU guest agent is not running"], "stdout": "", "stdout_lines": []}
```

You might need to reset the hosts, sometimes guest agent doesn't come up properly on the first boot.
