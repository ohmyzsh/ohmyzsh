# Ollama

This plugin adds completion for [Ollama](https://ollama.com), the tool for running large language models locally.

To use it, add `ollama` to the plugins array in your zshrc file:

```zsh
plugins=(... ollama)
```

It completes `ollama` subcommands, their flags, and model names (from `ollama list`, or `ollama ps` for `ollama stop`).

## Credits

Adapted from [Grégoire Compagnon's gist](https://gist.github.com/obeone/9313811fd61a7cbb843e0001a4434c58)
by [Konstantin Gredeskoul](https://github.com/kigster).
