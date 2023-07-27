# RabbitMQ server

This role minimally configures a RabbitMQ server instance.

This role depends on the `global-handlers` and the `common` roles.


## Topics

### RabbitMQ

This creates `/etc/rabbitmq/rabbitmq.conf`. There isn't much to this yet, other
than to manage certificates for TLS connections.

### firewalld

This opens ports 5671 (amqp) and 5672 (ampqs) in the given zone.


## Variables

```yaml
### Values shown here are the defaults

# Whether to listen on (unencrypted) TCP
rabbitmq_tcp: true

# Whether to use SSL/TLS or not. If set to true, the files
#  - ca.crt
#  - server.crt
#  - server.key
# are copied from files/HOSTS/<inventory_hostname>/rabbitmq/ to
# /etc/rabbitmq/ on the target.
rabbitmq_ssl: false

# If set, opens ports 5671 and 5672 in the named zone, rather than the default
# zone
rabbitmq_firewalld_zone: ""
```
