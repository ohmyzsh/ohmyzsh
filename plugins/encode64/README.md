# encode64

Alias plugin for encoding or decoding using `base64` command

## Functions and Aliases

| Function   | Alias | Description                    |
| ---------- | ----- | ------------------------------ |
| `encode64` | `e64` | Encodes given data to base64   |
| `decode64` | `d64` | Decodes given data from base64 |

## Enabling plugin

1. Edit your `.zshrc` file and add `encode64` to the list of plugins:

   ```sh
   plugins=(
     # ...other enabled plugins
     encode64
   )
   ```

2. Restart your terminal session or reload configuration by running:

   ```sh
   source ~/.zshrc
   ```

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
  $ echo "b2gtbXktenNoCg==" | decode64
  oh-my-zsh
  ```
