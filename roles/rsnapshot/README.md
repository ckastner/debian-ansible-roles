# Backups with `rsnapshot`

This role provides a very basic configuration for backups using `rsnapshot`, a
minimalistic, `rsync`-based backup utility. It sets up its own systemd timers.

This role depends on the `common` role.


## Variables

```yaml
### Values shown here are the defaults ###

# Directory in which to store the backups (this value is the program default)
rsnapshot_root: "/var/cache/rsnapshot"

# Level and interval definitions
#
# Note that intervals merely determine rotation between levels. Given levels of
# alpha, beta, and gamma, an argument of
#  - alpha will shift all alpha backups, and create a new backup
#  - beta will shift all beta backups, and take over the oldest copy from alpha
#  - gamma will shift all gamma backups, and take over the oldest copy from beta
#  
# Each definition is a mapping with the following keys:
#   [required]
#   level:      arbitrary name
#   oncalendar: systemd time specification, see systemd.time(5)
#   count:      how many instances to keep
rsnapshot_retain: []

# Backup point definitions (see 'backup' in rsnapshot(1)), where each entry is
# a mapping with the following keys:
#   [required]
#   src:        directory to back up
#   dest:       destination directory in the snapshot
rsnapshot_backups: []

# Backup exclude patterns, which are pattern as described in rsync(1)
rsnapshot_excludes: []
```


## Examples

```yaml
# The default /var/cache may not be the best choice, considering the FHS
rsnapshot_root: "/var/backups/rsnapshot"

# See the explanation above
rsnapshot_retain:
  - level: alpha
    oncalendar: 4 hours
    count: 6
  - level: beta
    oncalendar: 1 day
    count: 7
  - level: gamma
    oncalendar: 1 week
    count: 52

# host /etc/ will go to /var/backups/rsnapshot/<level>.N/etc, and so on
rsnapshot_backup:
  - { src: "/etc/", dest: "etc/" }
  - { src: "/var/", dest: "var/" }
  - { src: "/srv/", dest: "srv/" }

# /var/cache should be regeneratable per FHS, and we need to exclude our backup
# directory
rsnapshot_excludes:
  - "/var/cache"
  - "/var/backups/rsnapshot"
```
