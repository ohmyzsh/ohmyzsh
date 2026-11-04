## fishysave

Plugin to save and update functions and aliases directly from shell, reminiscent of the fish "funcsave" feature.

## Install

add fishysave to the plugins array of your zshrc file:
```bash
# ~/.zshrc
plugins=(... fishysave)

```

## Usage

```bash
# Save an alias
alias lsal="ls -al"
fishysave lsal

# Save a function
function lsa() {
    ls -al
}
fishysave lsa

```
