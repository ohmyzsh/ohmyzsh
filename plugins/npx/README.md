# NPX Plugin
> npx(1) -- execute npm package binaries. ([more info](https://github.com/zkat/npx))

This plugin automatically registers npx command-not-found handler if `npx` exists in your `$PATH`.

## Setup

- Add plugin to `~/.zshrc`

```bash
plugins=(.... npx)
```

- Globally install npx binary (npx will be auto installed with recent versions of Node.js)
```bash
sudo npm install -g npx
```

## Note

The shell auto-fallback doesn't auto-install plain packages. In order to get it to install something, you need to add `@`:

```
➜  jasmine@latest # or just `jasmine@`
npx: installed 13 in 1.896s
Randomized with seed 54385
Started
```

It does it this way so folks using the fallback don't accidentally try to install regular typoes.

