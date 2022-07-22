# JHBuild

This plugin adds some [JHBuild](https://developer.gnome.org/jhbuild/) aliases.

To use it, add `jhbuild` to the plugins array of your zshrc file:

```zsh
plugins=(... jhbuild)
```

**Maintainer:** [Miguel Vaello](https://github.com/miguxbe)

## Aliases

| Alias   | Command                   |
|---------|---------------------------|
| `jh`    | `jhbuild`                 |
| `jhb`   | `jhbuild build`           |
| `jhbo`  | `jhbuild buildone`        |
| `jhckb` | `jhbuild checkbranches`   |
| `jhckm` | `jhbuild checkmodulesets` |
| `jhi`   | `jhbuild info`            |
| `jhl`   | `jhbuild list`            |
| `jhc`   | `jhbuild clean`           |
| `jhco`  | `jhbuild cleanone`        |
| `jhm`   | `jhbuild make`            |
| `jhr`   | `jhbuild run`             |
| `jhrd`  | `jhbuild rdepends`        |
| `jhsd`  | `jhbuild sysdeps`         |
| `jhu`   | `jhbuild update`          |
| `jhuo`  | `jhbuild updateone`       |
| `jhun`  | `jhbuild uninstall`       |
| `jhsh`  | `jhbuild shell`           |
| `jht`   | `jhbuild tinderbox`       |
