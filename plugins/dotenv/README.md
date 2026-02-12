# dotenv

Automatically load your project ENV variables from `.env` file when you `cd` into project root directory.

Storing configuration in the environment is one of the tenets of a [twelve-factor app](https://www.12factor.net). Anything that is likely to change between deployment environments, such as resource handles for databases or credentials for external services, should be extracted from the code into environment variables.

To use it, add `dotenv` to the plugins array in your zshrc file:

```sh
plugins=(... dotenv)
```

## Usage

Create `.env` file inside your project root directory and put your ENV variables there.

For example:

```sh
export AWS_S3_TOKEN=d84a83539134f28f412c652b09f9f98eff96c9a
export SECRET_KEY=7c6c72d959416d5aa368a409362ec6e2ac90d7f
export MONGO_URI=mongodb://127.0.0.1:27017
export PORT=3001
```

`export` is optional. This format works as well:

```sh
AWS_S3_TOKEN=d84a83539134f28f412c652b09f9f98eff96c9a
SECRET_KEY=7c6c72d959416d5aa368a409362ec6e2ac90d7f
MONGO_URI=mongodb://127.0.0.1:27017
PORT=3001
```

You can even mix both formats, although it's probably a bad idea.

Multi-line values are supported using quoted strings:

```sh
PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA...
-----END RSA PRIVATE KEY-----"
```

Variables defined earlier in the file can be referenced by later entries:

```sh
BASE_URL=https://example.com
API_URL=$BASE_URL/api
ASSETS_URL=${BASE_URL}/assets
```

Note: only variables defined within the same `.env` file are expanded this way —
shell environment variables that already exist are **not** substituted.

## Settings

### ZSH_DOTENV_FILE

You can also modify the name of the file to be loaded with the variable `ZSH_DOTENV_FILE`.
If the variable isn't set, the plugin will default to use `.env`.
For example, this will make the plugin look for files named `.dotenv` and load them:

```zsh
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_DOTENV_FILE=.dotenv
```

### ZSH_DOTENV_PROMPT

Set `ZSH_DOTENV_PROMPT=false` in your zshrc file if you don't want the confirmation message.
You can also choose the `Always` option when prompted to always allow sourcing the .env file
in that directory. See the next section for more details.

### ZSH_DOTENV_ALLOWED_LIST, ZSH_DOTENV_DISALLOWED_LIST

The default behavior of the plugin is to always ask whether to source a dotenv file. There's
a **Y**es, **N**o, **A**lways and N**e**ver option. If you choose Always, the directory of the .env file
will be added to an allowed list; if you choose Never, it will be added to a disallowed list.
If a directory is found in either of those lists, the plugin won't ask for confirmation and will
instead either source the .env file or proceed without action respectively.

The allowed and disallowed lists are saved by default in `$ZSH_CACHE_DIR/dotenv-allowed.list` and
`$ZSH_CACHE_DIR/dotenv-disallowed.list` respectively. If you want to change that location,
change the `$ZSH_DOTENV_ALLOWED_LIST` and `$ZSH_DOTENV_DISALLOWED_LIST` variables, like so:

```zsh
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_DOTENV_ALLOWED_LIST=/path/to/dotenv/allowed/list
ZSH_DOTENV_DISALLOWED_LIST=/path/to/dotenv/disallowed/list
```

The file is just a list of directories, separated by a newline character. If you want
to change your decision, just edit the file and remove the line for the directory you want to
change.

NOTE: if a directory is found in both the allowed and disallowed lists, the disallowed list
takes preference, _i.e._ the .env file will never be sourced.

### Glob/Wildcard Patterns

Entries in the allowed and disallowed list files are matched as zsh patterns against the
directory path, so wildcards work in addition to exact paths. This is useful when you want
to allow or disallow entire directory trees at once.

For example, if you use [git worktrees](https://git-scm.com/docs/git-worktree) and all your
worktrees live under a common prefix, you can add a single pattern instead of allowing each
one individually:

```sh
# In your dotenv-allowed.list file:
/Users/me/Dev/my-project-wt-*
```

Note that entries are matched against the whole path as a string (as in
`[[ $dir == pattern ]]`), not with filename globbing: `*` and `?` match any characters
**including `/`**, so `/Users/me/*` also matches nested directories like `/Users/me/a/b`.
The basic zsh pattern operators are supported: `*`, `?`, character classes like `[abc]`,
and alternation like `(foo|bar)`. Operators that require `EXTENDED_GLOB` (such as `#`,
`^` and `~`) are **not** enabled by the plugin.

If a literal path contains pattern metacharacters (`*`, `?`, `[`, `(`, etc.), escape them
with a backslash to match the path exactly. Paths added by answering [a]lways or n[e]ver
at the prompt are escaped automatically. Malformed patterns are treated as non-matching.

Lines starting with `#` are treated as comments. Blank lines are ignored, and leading and
trailing whitespace around an entry is stripped.

## Named Pipe (FIFO) Support

The plugin supports `.env` files provided as UNIX named pipes (FIFOs) in addition to regular files.
This is useful when secrets managers like [1Password Environments](https://developer.1password.com/docs/environment/)
mount `.env` files as named pipes to inject secrets on-the-fly without writing them to disk.

No additional configuration is required — the plugin automatically detects and sources named pipes.

## Tests

The tests use [zunit](https://github.com/zunit-zsh/zunit). Install it per its [documentation](https://github.com/zunit-zsh/zunit#installation), then run:

```sh
cd plugins/dotenv && zunit
```

> [NOTE!]
> zunit also requires installing [Revolver](https://github.com/molovo/revolver).

## Version Control

**It's strongly recommended to add `.env` file to `.gitignore`**, because usually it contains sensitive information such as your credentials, secret keys, passwords etc. You don't want to commit this file, it's supposed to be local only.

## Security

The plugin applies several best-effort safeguards when loading a `.env` file:

- **Size limit** — files larger than 10 MiB are rejected to prevent DoS.
- **Syntax check** — the file is validated with `zsh -fn` before any variables are set.
- **No command substitution** — entries containing `$(...)` or backtick constructs are skipped.
- **Forbidden variables** — the following variables are never overwritten, regardless of what the
  `.env` file contains: `NODE_OPTIONS`, `BASH_ENV`, `ENV`, `ZDOTDIR`, `ZSH`, `LD_PRELOAD`,
  `LD_LIBRARY_PATH`, `DYLD_INSERT_LIBRARIES`, `GIT_CONFIG_GLOBAL`, `GIT_DIR`, `GIT_EDITOR`,
  `GIT_EXTERNAL_DIFF`, `GIT_EXEC_PATH`, `GIT_PAGER`, `GIT_SSH`, `GIT_SSH_COMMAND`,
  `GIT_SSL_NO_VERIFY`, `GIT_TEMPLATE_DIR`, `VISUAL`, `PAGER`, `EDITOR`, and all zsh special
  parameters.

These measures are **best-effort** — you are still responsible for the content of your `.env`
file. Do not use this plugin as a security boundary.

If you need more advanced and feature-rich ENV management, check out these awesome projects:

* [direnv](https://github.com/direnv/direnv)
* [zsh-autoenv](https://github.com/Tarrasch/zsh-autoenv)
