close-vault() {
  echo "Usage: close-vault [keyfile] [encryptedFile] [destination]"
  gpg-zip --gpg-args "--passphrase-file $1 --batch --yes" -c -o $2 $3
}

open-vault() {
  echo "Usage: open-vault [keyfile] [encryptedFile] [destination]"
  gpg-zip --gpg-args "--passphrase-file $1 --batch --yes" -d $2 -o $3
}

create-password() {
  echo "Usage: create-password"
  openssl rand -base64 20
}

custom-pass() {
  echo "Usage: custom-pass [STORAGEDIR] [COMMONARGS]"
  local first=$1
  shift
  PASSWORD_STORE_DIR=$first pass $@
}
