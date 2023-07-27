# WireGuard VPNs

This role configures a host for participation in a WireGuard-based VPN.

This role depends on the `global-handlers` and the `common` roles.

## Topics

### WireGuard

Assuming an interface name of `ansible-wg0`, the WireGuard set is managed
through two files:

1. `/etc/wireguard/ansible-wg0.conf`

   Configuration file for WireGuard itself (for use with `setconf`). This file
   will contain an `[Interface]` section, and `[Peer]` sections for all
   configured peers.

1. `/etc/network/interfaces.d/ansible-wg0`

   Network interface definition for use with `ifup`/`ifdown`, which will create
   an interface of type `wireguard`, set the above configuration on it, and
   assign it an IP address.


## Variables

```yaml
### Values shown here are the defaults

# [Interface] option 'PrivateKey'
wireguard_privatekey: "CHANGEME"

# Setting this will allow peers to auto-read it for their [Peer] sections
wireguard_publickey: "CHANGEME"

# IP address to assign to the network interface
wireguard_address: "CHANGEME"

# [Interface] option 'PersistentKeepalive'. Leave blank to disable
wireguard_persistent_keepalive:

# [Interface] option 'ListenPort'. Leave blank for random port selection
wireguard_listenport:

# If set,
#  1. the [Peer] entry of other hosts will have an entry
#         Endpoint = wireguard_endpoint:wireguard_listenport
#  2. wireguard_listenport will be opened for incoming traffic in zone
#     wireguard_endpoint_firewalld_zone if set, otherwise in the default zone
wireguard_endpoint: ""
wireguard_endpoint_firewalld_zone: ""

# Interface name
wireguard_interface_name: "ansible-wg0"

# If non-blank, create a new zone with this name, and add the interface to it
wireguard_interface_firewalld_zone: ""

# Peers of this host, where an entry is a mapping with the following keys:
#   [required]
#   name:
#   [semi-required]
#   publickey:
#   allowed_ips:
#   [optional]
#   endpoint:
# The options publickey, allowed_ips and endpoint correspond to the PublicKey,
# AllowedIPs and Endpoint entries of a [Peer] section.
#
# If a peer is also managed by this configuration, then it is sufficient to
# specify 'name' which should match the inventory_hostname. All other values
# will then be read from its host_vars (hence 'semi-required').
wireguard_peers: []
```


## Examples

A minimal `host_vars` configuration would be:

```yaml
# Configuration for host foo.example.com
wireguard_privatekey: oEDMrkNHCNUBQWwfTutT/sO36lK3N/07jajaG6f07WM=
wireguard_publickey: Q6MRVla3vUZpfor4JaDnTBq00uKGdIVCb0yvk04VgGQ=
wireguard_address: 192.168.34.41/24

wireguard_peers:
  - name: bar.example.com
    publickey: 7couKwaliAx0cAX/jkD8Pu5yKSPCw47LCJA/2hoqZ1s=
    allowed_ips: 192.168.34.52/32
    endpoint: bar.example.com:51820

```
This would create an interface `ansible-wg0` with an address of
`192.168.34.41/24`. It would also create a config file
`/etc/wireguard/ansible-wg0.conf` with the following contents:

```ini
[Interface]
PrivateKey = oEDMrkNHCNUBQWwfTutT/sO36lK3N/07jajaG6f07WM=

[Peer]
PublicKey = 7couKwaliAx0cAX/jkD8Pu5yKSPCw47LCJA/2hoqZ1s=
AllowedIPs = 192.168.34.52/32
Endpoint = bar.example.com:51820
```

If host `bar.example.com` were also managed by this configuration, then
for `foo.example.com`, the variable `wireguard_peers` could be reduced to:

```yaml
wireguard_peers:
  - name: bar.example.com
```

All other options would then be read from `bar.example.com`'s `host_vars`.
