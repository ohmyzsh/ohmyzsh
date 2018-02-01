# NPX Plugin
> npx(1) -- execute npm package binaries. ([more info](https://github.com/zkat/npx))

This plugin automatically registers npx command-not-found handler if `npx` exists in your `$PATH`.

## Setup

- Add plugin to `~/.zshrc`

```bash
plugins=(.... npx)
```

- Globally install npx binary (you need node.js installed too!)
```bash
sudo npm install -g npx
```