# Deno Plugin

This plugin sets up completion and aliases for [Deno](https://deno.land).

To use it, add `deno` to the plugins array in your zshrc file:

```zsh
plugins=(... deno)
```

## Aliases

| Alias | Full command     |
| ----- | ---------------- |
| dc    | deno compile     |
| dca   | deno cache       |
| dfmt  | deno fmt         |
| dh    | deno help        |
| dli   | deno lint        |
| drn   | deno run         |
| drA   | deno run -A      |
| drw   | deno run --watch |
| dts   | deno test        |
| dup   | deno upgrade     |
