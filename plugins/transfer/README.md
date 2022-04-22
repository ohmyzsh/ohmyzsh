# `transfer` plugin

[`transfer.sh`](https://transfer.sh) is an easy to use file sharing service from the command line

To use it, add `transfer` to the plugins array in your zshrc file:

```zsh
plugins=(... transfer)
```

## Usage

- Transfer a file: `transfer file.txt`.

- Transfer a whole directory (it will be automatically compressed): `transfer dir`.

### Encryption / Decryption

- Encrypt and upload a file with symmetric cipher and create ASCII armored output:

  ```zsh
  transfer -c file
  ```

- Encrypt and upload directory with symmetric cipher and gpg output:

  ```zsh
  transfer -c directory
  ```

- Decrypt file:

  ```zsh
  gpg -d file -ca
  ```

- Decrypt directory:

  ```zsh
  gpg -d your_archive.tgz.gpg | tar xz
  ```

### Capturing code to remove file and removing it

- Capturing code

```zsh
transfer -d file
```

- Copy Delete Code
```
Delete Code: vvacju8zyC6P
URL: https://transfer.sh/vaDdEiRpsR/test.md
```

- Removing file

```
# curl <URL>/<Delete Code>
curl https://transfer.sh/vaDdEiRpsR/test.md/vvacju8zyC6P
```