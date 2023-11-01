# debci - Master Server

This role configures a host for use as a `debci` master server. It will drive
test execution, collect test results from workers, and publishes them via a web
application.

This role depends on the `global-handlers`, `common`, `rabbitmq` and `apache2`
roles.


## Topics

### debci

This installs all necessary packages and creates the configuration file
`/etc/debci/debci.conf`.

### apache2

This creates a `VirtualHost` over which the debci frontend can be accessed.

### RabbitMQ

This unconditionally increases `consumer_timeout`, the timeout for consumer
acknowledgments, from the default of 30min to 12h, so that long-running jobs
can finish normally.


## Variables

```yaml
### Values shown here are the defaults

# Value for the apache2 'ServerName' directive
debci_servername: "CHANGEME"

# Connection string for the RabbitMQ server to connect to
debci_amqp_server: ""

# Whether to use SSL/TLS or not. If set to true, the files
#  - ca.crt
#  - client.crt
#  - client.key
# are copied from files/HOSTS/<inventory_hostname>/debci/ to
# /etc/debci/ on the target.
debci_amqp_ssl: false

# List of all architectures, suites, and backend that this CI environment
# supports:
debci_arch_list:
  - amd64
debci_suite_list:
  - unstable
debci_backend_list:
  - lxc

# List of extra files to copy from files/HOSTS/{{ inventory_hostname}}/debci to /etc/debci
debci_conf_extra: []
```


## Examples

```yaml
# Server name for the apache2 VirtualHost configuration (see the template)
debci_servername: "ci.example.com"

# Passwords should be avoided until #1037322 and #1038139 get fixed
debci_amqp_server: "amqps://user:pass@10.0.0.1"

# Connect to RabbitMQ using a client certificate
debci_amqp_ssl: true

# This CI environment can cover the 'stable', 'testing', and 'unstable' suites
# using the 'lxc' and 'qemu' backends.
debci_suite_list: [stable, testing, unstable]
debci_backend_list: [qemu, lxc]

# Copy to /etc/debci/extra_apt_sources_list.yaml
debci_conf_extra:
  - extra_apt_sources_list.yaml
```

Given the above configuration (and assuming worker nodes are set up properly),
here are some examples for test submissions:

```shell
# Test libfoo in unstable on amd64 using the lxc backend
$ debci enqueue -s unstable -b lxc libfoo

# Test libbar in stable on amd64 using the qemu backend
$ debci enqueue -s stable -b qemu libfoo
```
