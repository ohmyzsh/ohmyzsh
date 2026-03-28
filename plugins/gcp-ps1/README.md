# gcp prompt for zsh

Prompt which displays current configuration

## Current state

Tested only on ubuntu.
May or may not work on FreeBSD or osX. Feel free to fix any issue!

## Requirements

[gcloud](https://cloud.google.com/sdk/docs/downloads-interactive)


## Enabling

In order to use gcp-ps1 with Oh My Zsh, you'll need to enable them in the
.zshrc file. You'll find the zshrc file in your $HOME directory. 

```shell
vim $HOME/.zshrc
```

Add gcp-ps1 to the list of enabled plugins and enable it on the prompt:

```shell
plugins=(
  git
  gcp-ps1
)

PROMPT=$PROMPT'$(gcp_ps1) '
```

