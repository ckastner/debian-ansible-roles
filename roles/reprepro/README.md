# APT package repository using reprepro

This role configures a host for use as an APT package repository. Designated
users will be allowed to upload packages, and the repository will be served to
the public via http/s. If so configured, Release files will be signed.

This role depends on the `global-handlers`, `common`, and `apache2` roles.


## Topics

### SSH

This creates a group `reprepro-sftp`, and adds all users with upload
permissions (`reprepro_sftp_users`) to it. Their `authorized_keys` will be
copied to the target.

Users in group `reprepro-sftp` will _only_ be allowed to use the SFTP protocol,
and will be allowed to write to `/srv/reprepro/incoming`. Users will be
chroot'ed to `/srv/reprepro`, so in uploads, they must specify `/incoming` as
the destination directory.

*Note that upload here means "transfer a file to the incoming directory on the
target". Whether this file is ultimately accepted by the repository or not is
governed by `reprepro_uploaders`; see below.*

### Reprepro

This configures the reprepro repository. See 
[reprepro(1)](https://manpages.debian.org/unstable/reprepro/reprepro.1.en.html)

Directories:
- `HOME` of the reprepro user is `/var/lib/reprepro`
- Configuration lives in `/etc/reprepro`
- User-facing data is in `/srv/reprepro`
  - of which `/srv/reprepro/incoming` is writable for group `reprepro-sftp`

Note that every variable with a default value of `"CHANGEME"` is required, and
must be changed.

A minimal configuration needs to set
- some required metadata (origin, label, description of the archive)
- at least one distribution definition in `reprepro_destributions`
- users in `reprepro_sftp_users`, to allow transfers to the incoming directory
- rules `reprepro_uploaders` to determine which of the files in the incoming
  directory may enter the archive.
The above would create a repository with `amd64 source` as default
architectures, and `main` as the default components.

### GnuPG

This is only used used when `reprepro_signwith` is set. It
- manages the keyring in GNUPGHOME in `/var/lib/reprepro/.gnupg`
- copies the `SignWith` hook script, if necessary 
- copies the archive signing key to a publicly available location.

### apache2

Ths generates the site configuration (using `VirtualHost`), and enables it.


## Variables

```yaml
### Values shown here are the defaults ###

# Users for which to allow sftp upload. The users will be created if necessary,
# and added to the 'reprepro-sftp' group. Each user must have a file
# files/<USER>/ssh/authorized_keys, which will be copied to
# /home/<USER>/.ssh/authorized_keys on the target.
reprepro_sftp_users: []


# Origin, Label and Description fields of generated Release files
reprepro_origin: "CHANGEME"
reprepro_label: "CHANGEME"
reprepro_description: "CHANGEME"

# Architectures and components in this repository
reprepro_architectures:
  - source
  - amd64
reprepro_components:
  - main
reprepro_udebcomponents: []

# Distributions in this repository, where an entry is a mapping with the
# following keys:
#   [required] 
#   suite:
#   codename:
#   [optional]
#   version:     Will be omitted from Release file if empty
#   description: Override the global reprepro_description
#   additional:  List of additional names to accept for this release (as set in
#                debian/changelog). For example, the release with with codename
#                'sid' should also accept uploads to the release 'unstable'.
#                'suite' will be implicitly treated like this, if its name
#                 differs from 'codename'.
# The required keys have no default values and must be specified.
reprepro_distributions: []

# Lines to add (verbatim) to conf/uploaders. See UPLOADERS FILES in reprepro(1)
# When using GnuPG keys, the keys must be added to the keyring, otherwise
# signature verification will fail.
reprepro_uploaders: []


# How to sign Release files
# - If "!", then the script HOSTS/<inventory_hostname/reprepro/sign-release.sh
#   will be copied to /usr/local/bin/sign-release.sh, and the SignWith field
#   will use it as a hook script
# - If "", Release files will not be signed
# - Otherwise, the string value is copied verbatim to the SignWith field.
reprepro_signwith: ""

# Short name, for publishing the archive key: deriv-archive-keyring.gpg
# Only used when non-empty and when signwith is used
reprepro_deriv: ""


# Value for the apache2 'ServerName' directive
reprepro_servername: "CHANGEME"
```


## Examples

### SSH upload

Allow these two users to transfer files to the target's incoming directory:

```yaml
reprepro_sftp_users:
 - foouser
 - baruser
 ```

For each of these users, the file `file/USERS/<user>/.ssh/authorized_keys` must
exist. It will be copied to `/home/<user>/.ssh/authorized_keys` on the host.

### reprepro

```yaml
# Required metadata
reprepro_origin: Magic Repo
reprepro_label: Magic Repo
reprepro_description: APT repository of the Magic Team

# Full Example for a distribution
reprepro_distributions:
- suite: stable
  codename: bookworm
  version: 12.1
  description: official bookworm Release
  additional: [unstable, nameA, nameB]
# This distribution will accept uploads with either 'stable', 'bookworm',
# 'unstable', 'nameA', or 'nameB' in debian/changelog.

# Allow packages signed by any key to upload
reprepro_uploaders:
 - allow * by any
# Allow packages signed by keys 0F001 or 0F002 to upload. For 0F002, a
# signature with a subkey is also accepted. The keys must be present in the
# keyring!
reprepro_uploaders:
 - allow * by 0F001
 - allow * by 0F002+
# See reprepro(1) for more options.
```

### GnuPG

```yaml
# No signing of Release files
reprepro_signwith: ""
# Sign with this key id
reprepro_signwith: 0123456789ABCDEF
# Execute /usr/local/bin/sign-release.sh
reprepro_signwith: "!"

# Copy the GPG key HOSTS/<inventory_hostname>/reprepro/archive-keyring.gpg
# to <webroot>/myproj-archive-keyring.gpg
reprepro_deriv: myproj
```

### apache2

Generate the site configuration using `apt.example.com` as `ServerName` in the
`apache2` config:

```yaml
reprepro_servername: apt.example.com
```
