# Symfony

> **⚠️ DEPRECATION WARNING**  
> This plugin is deprecated and will be removed in a future release.  
> **Please migrate to the unified [`symfony`](../symfony/) plugin** which supports all Symfony versions (2.x through 6+).  
> Simply change `symfony6` to `symfony` in your `.zshrc` plugins list.

This plugin provides native completion for [Symfony](https://symfony.com/), but requires at least Symfony 6.2.

To use it add `symfony6` to the plugins array in your zshrc file.

```bash
plugins=(... symfony6)
```

## Migration

**Recommended:** Use the unified [`symfony`](../symfony/) plugin instead:

```bash
plugins=(... symfony)  # Replace symfony6 with symfony
```

The unified plugin provides the same native completion functionality plus automatic version detection and support for all Symfony versions.
