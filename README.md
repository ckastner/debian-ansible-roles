# Ansible Roles for Debian

This is a collection of Ansible roles for Debian-based systems.

These are based on my own personal needs, and the needs of projects that I
contribute to. Consequently, the selection of choices is still quite limited,
but it will grow.

## Roles

- [common](roles/common) - Configuration common to most Debian systems

  Configures APT sources and preferences, but can also configure some hardware
  and system aspects of a target.

- [apache2](roles/apache2) - Apache 2.x web server

  Performs installation and basic configuration of the
  [Apache 2](https://httpd.apache.org) web server, including management of
  [Let's Encrypt](https://letsencrypt.org) certificates.

- [approx](roles/approx) - APT cache server

  Sets up an APT cache server using
  [approx](https://packages.debian.org/sid/approx).

- [debci_master](roles/debci_master) - debci master server

  Configures a host to server as the master within a
  [debci](https://ci.debian.net/) CI instance. The master queues tests,
  collects results from workers, and published them via a web application.

- [debci_worker](roles/debci_master) - debci worker

  Configures a host to serve as a worker within a
  [debci](https://ci.debian.net/) CI instance. A worker reads and executes jobs
  queued by the debci master.

- [rabbitmq](roles/rabbitmq) - RabbitMQ server

  Configures a host to run as a RabbitMQ server.

- [reprepro](roles/reprepro) - reprepro APT repository

  Sets up a reprepro repository, to which selected users can upload. The
  repository is made available via http/s, including signed Release files.

- [wireguard](roles/wireguard) - WireGuard VPN

  Configures a host for participation in a
  [WireGuard](https://www.wireguard.com) VPN, including network interface and
  peer management.


## Utilities

### Ansible Vault

If you want to use Ansible Vault together with a GnuPG-encrypted passphrase,
a [helper](bin/gpg-passphrase-client.sh) is provided. You'll need to create the
file `local/vault-passphrase.gpg` first. See [bin](bin/README.md).

### PKI

Some roles may need custom certificates to communicate via TLS. To this end,
the [pki/](pki) contains a utility and an OpenSSL configuration for quickly
creating CA, server, and client certificates.
