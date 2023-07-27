# APT package caching using approx

This role sets up a local APT package cache using `approx`, which will be
listening on `*:9999`.

This role depends on the `global-handlers` and `common` roles.


## Open Issues

It is not yet possible for the system's main APT configuration make use of this
cache in one `ansible-playbook` pass, as this complicates things a bit. The
main use case for a local APT package cache considered here is to improve upon
download-heavy workloads, like Debian package builds.

If you'd like the target host's APT configuration to also use this cache, then
you'll need to do this in two passes:
1. With a "regular" APT configuration, so that `approx` can be installed and
   configured correctly
2. With updated `host_vars` that switch over the APT configuration to point to
   the cache.


## Variables

```yaml
### Values shown here are the defaults ###

# Whether to download incremental or fulll package lists
# (Depending on the number of pdiffs, incremental can actually be slower)
approx_pdiffs: true

# Interval (in minutes) before checking for a newer version of a file
approx_interval: 60

# The actual URI mappings.
# The defaults below implement the following mapping:
#  - http://localhost:9999/debian   -> https://deb.debian.org/debian
#  - http://localhost:9999/security -> https://security.debian.org/debian-security
approx_mappings:
  - name: debian
    uri: https://deb.debian.org/debian
  - name: security
    uri: https://security.debian.org/debian-security
```
