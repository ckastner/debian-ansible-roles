# Host Variables

Host variables are stored in two files:
1. `<inventory_hostname>/public.yml` for insensitive variables
1. `<inventory_hostname>/private.yml` for variables of which the contents
   should be kept confidential. This file should always be encrypted with
   Ansible Vault.
