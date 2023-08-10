# Configuration Common to most Debian Systems

This role performs some general configuration steps common to most Debian 12
("bookworm") systems.


## Topics

### APT

APT sources and preferences are configured. This is done through
`/etc/apt/sources.list.d/ansible-managed.list` and
`/etc/apt/preferences.d/ansible-managed.prefs`.

The target's release is read from the file `/etc/os-release` on the target.
This doesn't work for `unstable` and `experimental`, so if you want to use one
of those releases, you'll need to set `apt_codename`.

### Hardware and System

This provides a way to manage kernel modules, udev rules, and `sysfs`
attributes.

A target's `/etc/modules` can be configured by providing a list of module names
to load. For `/etc/modprobe.d`, `/etc/sysfs.d` and `/etc/udev/rules.d`,
host-specific files must be supplied. They will be copied to their respective
destinations.

### systemd

This ensures that `systemd-timesyncd` is installed, and that the systemd
journal is persisted to disk.

Optionally, a hardware watchdog timer can be enabled.

### Network

For now, this just ensures that [firewalld](https://firewalld.org) is
installed.

As a result, all incoming traffic will be filtered except for traffic on ports
`dhcpv6-client` and `ssh`; so whenever you add a listening service, be sure to
include a play that opens any necessary ports.

### SSH

This doesn't do much yet, other than adding the ability to change a few
commonly used options.


## Variables

```yaml
### Values shown here are the defaults ###

# Whether to empty /etc/apt/sources.list
# Set to false if you'd like that file to co-exist with
# /etc/apt/sources.list.d/ansible-managed.list
apt_sourceslist_empty: true

# Sets the mirror for all entries (except for security.debian.org)
apt_uri: https://deb.debian.org/debian

# Change this to override the codename read from /etc/os-release
apt_codename: ""

# Sets the (udeb-)components for all entries
apt_components: main
apt_udebcomponents: main

# Generate these types of entries
apt_type: [deb, deb-src]

# Set to false to disable official <codename>-security
apt_securty_enable: true

# Set to false to disable official <codename>-updates
# This is skipped when codename is sid, unstable, or experimental
apt_updates_enable: true

# Set to true to enable official <codename>-backports
# This is skipped when codename is sid, unstable, or experimental
apt_backports_enable: false

# List of additional sources.list entries to create, where an entry is a
# mapping with the following keys:
#   [required] 
#   uri:
#   codename:    Release or distribution name (bookworm, experimental, ...)
#   [optional]
#   components:  default: main
#   type:        default: [deb, deb-src]
#   signed_by:   If present, an [signed-by=<value>] option will be added to the
#                source entry
#   comment:     Will place this comment before the sources.list entry
# The required keys have no default values and must be specified.
apt_additional_sources: []

# List of apt_preferences(5) entries to create in
# /etc/apt/preferences.d/ansible-managed.prefs, where an entry is a mapping
# with the following keys:
#   [required] 
#   package:
#   pin:
#   priority:
# Note that the package wildcard '*' must be quoted to avoid a YAML error.
apt_pin: []


# Modules to add to /etc/modules
etc_modules: []

# Host-specific files to add to /etc/modprobe.d
# The source files are expected in files/HOSTS/<inventory_hostname>/modprobe.d
etc_modprobe_d: []

# Host-specific files to add to /etc/udev/rules.d
# The source files are expected in files/HOSTS/<inventory_hostname>/udev/rules.d
etc_udev_rules_d: []

# Host-specific files to add to /etc/sysctl.d
# The source files are expected in files/HOSTS/<inventory_hostname>/sysctl.d
etc_sysctl_d: []

# Host-specific files to add to /etc/sysfs.d
# The source files are expected in files/HOSTS/<inventory_hostname>/sysfs.d
etc_sysfs_d: []


# Set to anything greater than 0 to enable the systemd watchdog
systemd_watchdog_sec: 0


# Set this to false to disable password auth (OpenSSH default is 'enable')
sshd_password_auth: true

# Set this to true to enable the legacy ssh-rsa hashing algorithm
# This was (rightfully) disabled by default in OpenSSH 8.8, but this breaks
# some clients, most notably dput-ng in bullseye (via python3-paramiko).
sshd_legacy_sshrsa: false
```

### Examples

#### APT

```yaml
apt_uri: http://ftp.at.debian.org/debian
apt_components: main non-free-firmware

apt_backports_enable: true
apt_pin:
  - package: *
    pin: release a=bookworm-backports
    priority: 991


apt_additional_sources:
  - uri: http://ftp.at.debian.org/debian
    codename: unstable
    components: main contrib
    comment: For development work
```

On a bookworm system, the above `host_vars` would generate the following
`/etc/apt/sources.list`:

```
deb     https://ftp.at.debian.org/debian bookworm main non-free-firmware
deb-src https://ftp.at.debian.org/debian bookworm main non-free-firmware

deb     https://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src https://security.debian.org/debian-security bookworm-security main non-free-firmware

# See https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb     https://ftp.at.debian.org/debian bookworm-updates main non-free-firmware
deb-src https://ftp.at.debian.org/debian bookworm-updates main non-free-firmware

# See https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb     https://ftp.at.debian.org/debian bookworm-backports main contrib non-free-firmware
deb-src https://ftp.at.debian.org/debian bookworm-backports main contrib non-free-firmware

# For development work
deb     https://ftp.at.debian.org/debian unstable main contrib
deb-src https://ftp.at.debian.org/debian unstable main contrib
```

Additionally, it would generate the following
`/etc/apt/preferences.d/ansible-managed.pref`:
```
Package: *
Pin: release a=bookworm-backports
Pin-Priority: 991
```

#### Hardware and System

The following `host_vars` would ensure that `vfio`, `vfio_pci`, and
`vfio_iommu_type1` are present in `/etc/modules`:

```yaml
etc_modules:
  - vfio
  - vfio_pci
  - vfio_iommu_type1
```

The following `host_vars` would ensure that
`files/HOSTS/<inventory_hostname>/modprobe.d/vfio.conf` is copied to the
target's `/etc/modprobe.d/vfio.conf`:

```yaml
etc_modprobe_d:
  - vfio.conf
```

The following `host_vars` would ensure that
`files/HOSTS/<inventory_hostname>/udev/rules.d/99-plugdev.rules` is copied to
`/etc/udev/rules.d/99-plugdev.rules`:

```yaml
etc_udev_rules_d:
  - 99-plugdev.rules
```

The following `host_vars` would ensure that
`files/HOSTS/<inventory_hostname>/sysctl.d/ip_forward.conf` is copied to
`/etc/sysctl.d/ip_forward.conf`:

```yaml
etc_sysctl_d:
  - ip_forward.conf
```
The following `host_vars` would ensure that
`files/HOSTS/<inventory_hostname>/syfs.d/lowpower.conf` is copied to
`/etc/sysfs.d/lowpower.conf`:

```yaml
etc_sysfs_d:
  - lowpower.conf
```
