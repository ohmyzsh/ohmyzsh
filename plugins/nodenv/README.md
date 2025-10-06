# nodenv plugin

The primary job of this plugin is to provide `nodenv_prompt_info` which can be added to your theme to include Node
version information into your prompt.

To use it, add `nodenv` to the plugins array in your zshrc file:

```zsh
plugins=(... nodenv)
```

## Functions

* `nodenv_prompt_info`: displays the Node version in use by nodenv; or the global Node
  version, if nodenv wasn't found. You can use this function in your prompt by adding
  `$(nodenv_prompt_info)` to PROMPT or RPROMPT:

  ```zsh
  RPROMPT='$(nodenv_prompt_info)'
  ```
