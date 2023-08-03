# Global Handlers

This role defines handlers for global use. Other roles can make use of these
handlers by adding a dependency on this role to `meta/main.yml`:

```yaml
dependencies:
  - global-handlers
```

The following global handlers are currently defined:

- Restart Apache webserver
- Restart firewalld
- Restart OpenSSH server
- Restart RabbitMQ server
