# CLAUDE.md

## Secrets

`group_vars/all` holds live API credentials (DigitalOcean, Cloudflare, Proxmox). Never read, grep, print or copy it, and don't run commands or add debug tasks that output its variables. For variable names and layout use [group_vars/all.example](group_vars/all.example) instead.

This is enforced in [.claude/settings.json](.claude/settings.json), not just asked for here:

- `permissions.deny` blocks the Read, Grep and Glob tools on `group_vars/all`.
- The sandbox applies the same deny rule to Bash, so `cat group_vars/all` fails at the OS level.
- `ansible-playbook` is excluded from the sandbox because it has to load these vars and reach hosts over SSH, so it goes through the normal permission prompt instead.

If a task seems to need a value from `group_vars/all`, ask the user rather than working around the block (e.g. by disabling the sandbox).
