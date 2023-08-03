# debci - Worker

This role configures a host for use as a `debci` worker; that is, a host
reading and executing
[autopkgtest](https://salsa.debian.org/ci-team/autopkgtest/-/blob/master/doc/README.package-tests.rst)
jobs queued by the debci master.

This role depends on the `global-handlers` and `common` roles.


## Topics

### debci

This installs all necessary packages, including those needed by the requested
backend, and creates the configuration file `/etc/debci/debci.conf`.


## Variables

```yaml
### Values shown here are the defaults

# Connection string for the RabbitMQ server to connect to
debci_amqp_server: ""

# Whether to use SSL/TLS or not. If set to true, the files
#  - ca.crt
#  - client.crt
#  - client.key
# are copied from files/HOSTS/<inventory_hostname>/debci/ to
# /etc/debci/ on the target.
debci_amqp_ssl: false


### If the default values below are not changed, then they will be left unset
### in /etc/debci/debci.conf, which means that debci will use its own defaults

# Package architecture this worker can test.
# debci default: host architecture (dpkg --print-architecture)
debci_arch: ""

# Suite to use as defaults for debci-{setup,worker,test}.
# debci default: "unstable"
debci_suite: ""

# Backend this worker uses to test packages. Leave empty to use the default,
# which is "lxc".
debci_backend: ""
```
