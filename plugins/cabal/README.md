# Cabal

It provides completion for Cabal (a build tool for Haskell). 

Adds the function cabal_sandbox_info to show whether the current working directory is in a sandbox: 358b6ff#diff-72a60029f69e410b0dd2f8323a62310b.

To use it, add cabal to the plugins array of your zshrc file:
```
plugins=(... cabal)
```
