# `transfer` plugin

[`transfer.sh`](https://transfer.sh) is an easy to use file sharing service from the command line

## Usage

Add `transfer` to your plugins array in your zshrc file:
```zsh
plugins=(... transfer)
```

Then you can:

- transfer a file:

```zsh
transfer file.txt
```

- transfer a whole directory (it will be automatically compressed):

```zsh
transfer directory/
```

### Encryption/Decryption

- encrypt and upload file with symmetric cipher and create ASCII armored output
```zsh
transfer file -ca
```

- encrypt and upload folder with symmetric cipher and gpg output
```zsh
transfer folder -ca
```

- decrypt file
```zsh
gpg -d file -ca
```

- decrypt folder
```zsh
gpg -d your_archive.tgz.gpg | tar xz
```