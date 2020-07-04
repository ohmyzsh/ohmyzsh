# Themes Plugin

This plugin allows you to list the themes and plugins available in your system locally. You can also list the custom themes/plugins that are available. 

To use it, add `zshl` to the plugins array in your zshrc file:

```
plugins=(... zshl)
```

## Usage

`zshlt` - List locally available oh-my-zsh themes.
`zshlp` - List locally available oh-my-zsh plugins.
`zshlcp` - List locally available custom oh-my-zsh themes.
`zshlct` - List locally available custom oh-my-zsh plugins.

## Examples

1. zshlt #zsh list themes
```bash
➜  ~ zshlt
3den.zsh-theme           gallois.zsh-theme          nicoulaj.zsh-theme
adben.zsh-theme          garyblessington.zsh-theme  norm.zsh-theme
af-magic.zsh-theme       gentoo.zsh-theme           obraun.zsh-theme
afowler.zsh-theme        geoffgarside.zsh-theme     peepcode.zsh-theme
agnoster.zsh-theme       gianu.zsh-theme            philips.zsh-theme
alanpeabody.zsh-theme    gnzh.zsh-theme             pmcgee.zsh-theme
amuse.zsh-theme          gozilla.zsh-theme          pygmalion-virtualenv.zsh-theme
apple.zsh-theme          half-life.zsh-theme        pygmalion.zsh-theme
arrow.zsh-theme          humza.zsh-theme            random.zsh-theme
aussiegeek.zsh-theme     imajes.zsh-theme           re5et.zsh-theme
avit.zsh-theme           intheloop.zsh-theme        refined.zsh-theme
awesomepanda.zsh-theme   itchy.zsh-theme            rgm.zsh-theme
bira.zsh-theme           jaischeema.zsh-theme       risto.zsh-theme
...
```
2. zshlct #zsh list custom themes
```bash
➜  ~ zshlcp
example  zshl  zsh-syntax-highlighting
```