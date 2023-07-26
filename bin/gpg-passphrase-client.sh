#!/bin/sh
set -e

# Create the passphrase with:
# dd if=/dev/random bs=1 count=128 | gpg -e -a -o local/vault-passphrase.gpg --recipient <YOUR-ID>

VAULT_ID=
if [ -n "$1" ]
then
	if [ "$1" != "--vault-id" ]
	then
		echo "Argument $1 not understood." >&2
		exit 1
	elif [ -z "$2" ]
	then
		echo "No vault ID specified." >&2
		exit 1
	fi
	VAULT_ID="$2"
fi

gpg --batch --use-agent --decrypt local/vault-passphrase.gpg
