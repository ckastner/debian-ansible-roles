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

# Connection string for the RabbitMQ server to connect to
debci_amqp_server: ""

# Whether to use SSL/TLS or not. If set to true, the files
#  - ca.crt
#  - client.crt
#  - client.key
# are copied from files/HOSTS/<inventory_hostname>/debci/ to
# /etc/debci/ on the target.
debci_amqp_ssl: false

# Value for the apache2 'ServerName' directive
debci_servername: "CHANGEME"
```
