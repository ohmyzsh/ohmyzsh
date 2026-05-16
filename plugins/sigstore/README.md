# Sigstore plugin

This plugin sets up completion for the following [Sigstore](https://sigstore.dev/) CLI tools.

- [Cosign](https://docs.sigstore.dev/cosign/overview)
- [Sget](https://docs.sigstore.dev/cosign/installation#alpine-linux)
- [Rekor](https://docs.sigstore.dev/rekor/overview)

To use it, add `sigstore` to the plugins array in your zshrc file:

```zsh
plugins=(... sigstore)
```
