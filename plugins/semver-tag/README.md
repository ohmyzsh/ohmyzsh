# semver-tag plugin

Bumps a repo's latest `MAJOR.MINOR.PATCH` git tag and creates the next one, with a confirmation prompt before anything is created.

To use it, add `semver-tag` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... semver-tag)
```

## Commands

| Command | Description |
|---|---|
| `gtM` | Bump the major version and create the tag (e.g. `1.4.2` -> `2.0.0`) |
| `gtm` | Bump the minor version (e.g. `1.4.2` -> `1.5.0`) |
| `gtp` | Bump the patch version (e.g. `1.4.2` -> `1.4.3`) |
| `gtvM` | Same as `gtM`, but on first use in a repo with no tags, bootstraps with a `v` prefix (`v1.0.0`) |
| `gtvm` | Same as `gtm`, `v`-prefixed bootstrap |
| `gtvp` | Same as `gtp`, `v`-prefixed bootstrap |

`M` = major, `m` = minor, `p` = patch (case-sensitive).

Every command shows what it's about to do and asks for confirmation before creating the tag:

```
$ gtM
This will create tag 2.0.0, continue? [y/N]
```

## Bootstrapping a new repo

If a repo has no tags yet, the version bumps become the starting version instead of erroring:

```
$ gtM   # -> 1.0.0
$ gtm   # -> 0.1.0
$ gtp   # -> 0.0.1
```

`gtvM`/`gtvm`/`gtvp` do the same but prefix the bootstrapped tag with `v` (`v1.0.0` / `v0.1.0` / `v0.0.1`). Once a repo has a real tag, `v` is no longer a flag you choose - it's inferred from whatever the latest tag actually looks like.

## Tag format mismatch

The `v`/no-`v` decision is only yours to make when bootstrapping. Once tags exist, the plugin always bumps using the *real* prefix of the latest tag - it never invents a format the repo doesn't already use. But if what you typed doesn't match what's actually there, you get a warning baked into the confirmation prompt instead of a silent surprise:

```
$ gtM
Running this will create v1.0.0, but your existing tags are formatted v0.1.1, are you sure? [y/N]
```

## Latest tag detection

"Latest" means most recently *created* (`git for-each-ref --sort=-creatordate`), not the highest version number and not `git describe`'s "nearest tag reachable from HEAD." This matters if you ever tag out of numeric order - the plugin follows creation time, not the version string.

One caveat: for a lightweight tag, "creation time" falls back to the *tagged commit's* date (lightweight tags don't carry their own timestamp). If you bump more than once without an intervening commit, two lightweight tags on the same commit can tie and the ordering between them isn't guaranteed. This doesn't come up in normal use, since a real release always has a new commit before the next tag.

## Annotated, signed, or otherwise customized tags

By default every tag is lightweight (`git tag <name>`, no message, no tagger metadata). Anything you pass beyond the command name is forwarded straight to `git tag` after the computed tag name, so you get the rest of `git tag`'s own flags for free:

```
$ gtM --annotate -m "Release notes here"
$ gtM -s -m "Signed release"   # GPG-signed annotated tag
```

Note that `-m` is required for annotated/signed tags when passed this way - `git tag <name> --annotate "some text"` (no `-m`) is not valid git syntax; without `-m`/`-F`, git opens `$EDITOR` for the message instead, same as running `git tag -a` directly, and refuses to create the tag if you save an empty message.
