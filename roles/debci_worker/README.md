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

# List of all architectures/suites/backends this worker uses in tests. These
# lists will be used by the cron job that periodically rebuilds the test
# environments.
# debci_default: A list with the single value from the variable above.
debci_arch_list: []
debci_suite_list: []
debci_backend_list: []

# Passed on through to the autopkgtest runner (not the virtualization provider)
debci_autopkgtest_args: ""

# List of extra files to copy from files/HOSTS/{{ inventory_hostname}}/debci to /etc/debci
debci_conf_extra: []
```


## Examples

```yaml
# Passwords should be avoided until #1037322 and #1038139 get fixed
debci_amqp_server: "amqps://user:pass@10.0.0.1"

# Connect to RabbitMQ using a client certificate
debci_amqp_ssl: true

# This host can test the 'stable', 'testing', and 'unstable' suites using the
# 'lxc' and 'qemu' backends.
debci_suite_list: [stable, testing, unstable]
debci_backend_list: [qemu, lxc]

# Given the above, on an amd64 worker (where debci_arch defaults to 'amd64'),
# the cron job would periodically rebuild the following test environments:
# arch   suite     backend
# ----   -----     -------
# amd64  stable    qemu
# amd64  testing   qemu
# amd64  unstable  qemu
# amd64  stable    lxc
# amd64  testing   lxc
# amd64  unstable  lxc

# Increase the test run timeout to 3h (default is 1h)
debci_autopkgtest_args="--timeout-test 10800"

# Copy to /etc/debci/suite_bases.txt
debci_conf_extra:
  - suite_bases.txt
```
