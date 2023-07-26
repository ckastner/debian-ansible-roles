# Utilities

- `gpg-passphrase-client.sh`: Manage secrets in Ansible Vault using `gpg`

  Expects a gpg-encrypted file `local/vault-passphrase.gpg` and will use the
  decrypted contents as a key to encrypt/decrypt secrets in the vault.

  To grant permissions to a user, decrypt and re-encrypt this file for all
  existing users + the new user (using `--recipient`).

  The current key was generated with:

  ```shell
  dd if=/dev/random bs=1 count=128 | gpg -e -a -o local/vault-passphrase.gpg --recipient ...
  ```
