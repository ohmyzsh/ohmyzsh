# Octozen plugin

Displays a zen quote from GitHub's Octocat on start up.

To use it, add `octozen` to the plugins array in your zshrc file:

```zsh
plugins=(... octozen)
```

It defines a `display_octozen` function that fetches a GitHub Octocat zen quote.
NOTE: Internet connection is required (will time out if not fetched in 2 seconds).
