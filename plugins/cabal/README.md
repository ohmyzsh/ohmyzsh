# Cabal

This plugin provides completion for [Cabal](https://www.haskell.org/cabal/), a build tool for Haskell. It
also provides a function `cabal_sandbox_info` that prints whether the current working directory is in a sandbox.

To use it, add cabal to the plugins array of your zshrc file:
```
plugins=(... cabal)
```
