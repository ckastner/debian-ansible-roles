# Web Server using apache2

This role performs the most basic configuration of an
[Apache 2.4](https://httpd.apache.org) web server, optionally managing
[Let's Encrypt](https://letsencrypt.org) certificates.

This is pretty useless by itself. It is assumed that other roles depend on
this role, and then add configurations to `sites-enabled`.

This role depends on the `global-handlers` and the `common` roles.


## Topics

### apache2

This ensures that package `apache2` is installed, and it disables the default
site.

### firewalld

Ports 80 (http) and 443 (https) will be opened up in `firewalld`. The zone can
be configured.

### dehyrated (ACME)

This is only used when `acme_domains` is non-empty. If not-empty, this
- populates `/etc/dehydrated/domains.txt` with those domains
- installs packages `dehydrated` and `dehydrated-apache2`
- registers a Let's Encrypt account if none exists yet (you accept the terms)
- requests certificates for every domain
- sets up a systemd timer and service for weekly renewal of the certificates.


## Variables

```yaml
### Values shown here are the defaults

# If set, opens ports 80 and 443 in the named zone, rather than the default zone
apache2_firewalld_zone: ""

# Populate domains.txt with this list of strings. If left empty, no
# certificates will be requested
acme_domains: []

# When registering a new account, use this as contact email
acme_contact_email: ""
```
