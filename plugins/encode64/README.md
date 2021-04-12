# encode64

Alias plugin for encoding or decoding using `base64` command.

To use it, add `encode64` to the plugins array in your zshrc file:

```zsh
plugins=(... encode64)
```

## Functions and Aliases

| Function   | Alias | Description                    |
| ---------- | ----- | ------------------------------ |
| `encode64` | `e64` | Encodes given data to base64   |
| `decode64` | `d64` | Decodes given data from base64 |

## Usage and examples

### Encoding

- From parameter

  ```console
  $ encode64 "oh-my-zsh"
  b2gtbXktenNo
  $ e64 "oh-my-zsh"
  b2gtbXktenNo
  ```

- From piping

  ```console
  $ echo "oh-my-zsh" | encode64
  b2gtbXktenNo==
  $ echo "oh-my-zsh" | e64
  b2gtbXktenNo==
  ```

### Decoding

- From parameter

  ```console
  $ decode64 b2gtbXktenNo
  oh-my-zsh%
  $ d64 b2gtbXktenNo
  oh-my-zsh%
  ```

- From piping

  ```console
  $ echo "b2gtbXktenNoCg==" | decode64
  oh-my-zsh
  $ echo "b2gtbXktenNoCg==" | d64
  oh-my-zsh
  ```
