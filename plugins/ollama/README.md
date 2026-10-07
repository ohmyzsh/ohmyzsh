# ollama

This plugin provides completion for the [Ollama CLI](https://docs.ollama.com/cli).
It defines no shell aliases.

Add `ollama` to the plugins array in your `.zshrc`:

```zsh
plugins=(... ollama)
```

## Completion

- Commands, CLI command synonyms (`start`, `ls`), help, and command-specific flags.
- Installed models for `show`, `push`, `cp`, and repeated `rm` arguments.
- Running models for `stop`.
- Installed and public models for `run` and `launch --model`.
- Modelfile paths, quantization levels, thinking modes, output formats, and durations.
- Launch integrations and their existing CLI synonyms from the installed CLI's
  help. Arguments after `launch ... --` are left to the integration.

`curl` and `awk` are required for model completion. Installed/running models also
require `jq`. Dependencies are not installed by the plugin. Completion queries the daemon
specified by `OLLAMA_HOST` (default `http://127.0.0.1:11434`) without starting it.

### Pullable models and tags

```text
ollama pull qw<Tab>          # Matching public model names
ollama pull qwen3.5<Tab>     # Default name and concrete variants
ollama pull qwen3.5:<Tab>    # Concrete variants, including MLX and quantized tags
ollama pull qwen3.5:4<Tab>   # Matching tags such as 4b and 4b-mlx
```

Public completion queries the shared
[Ollama Model Metadata Cache](https://ollama-model-cache.amcox886.chatgpt.site).
The service stores the public catalogue and each model's tag metadata in a
durable database. Entries expire after ten minutes; only missing or expired
entries are refreshed from [ollama.com](https://ollama.com/library). No catalogue
is hardcoded and no network request runs when the shell starts. Tag lookup
also supports explicitly typed public `namespace/model` references.
Arbitrary registries and Hugging Face references can be typed normally, but are
not enumerated by the public catalogue.

Bare model names appear without a `latest` label. Ollama resolves an untagged
reference through `:latest`; that tag may refer to another variant. Only concrete
tags marked as latest on the public tags page are described as `*latest (default)`.
`model:latest` is not duplicated in the tag menu, but remains valid when typed
manually. Tag menus list one variant per line with its listed download size:

```text
qwen3.8:27b -- 18GB, *latest (default)
qwen3.8:27b-mlx-bf16 -- 56GB
```

These are rounded sizes published by Ollama, not remaining download bytes after
locally cached layers. Missing metadata is shown as `size unavailable`.

Requests have a one-second connection timeout and a three-second overall timeout
(two seconds for daemon queries). An exact bare model name can make two requests:
one for the catalogue and one for that model's tags. Size ordering can also make
a request for matching families' default sizes. The last successful public
result is kept in shell memory and reused if a request fails. This cache lasts
until the shell exits; it is never written as executable shell code. With no successful result yet,
offline public completion offers no models. Shell matcher styles filter matches
locally. The service receives explicitly requested public model names for tag
or size lookup, but no local model inventory or prompt. The completion never
falls back to fetching Ollama's library pages directly.

Use a different deployment of the same API, including a local development server:

```zsh
zstyle ':completion:*:ollama*:*' metadata-url 'https://your-metadata-service.example'
```

This URL is the service origin, without `/api/v1`. Responses are validated as
four-field TSV data and are never executed as shell code.

Disable public network completion while retaining installed model completion:

```zsh
zstyle ':completion:*:ollama*:*' remote-models false
```

### Model ordering

Set `model-sort` in your `.zshrc` to control public model names, model tags, and
installed/running model menus:

```zsh
zstyle ':completion:*:ollama*:*' model-sort natural
```

| Value | Ordering |
| --- | --- |
| `natural` (default) | Names with numeric parts in ascending order: `0.8b`, `2b`, `9b`, `27b`, `122b`. |
| `alphabetical` | Lexicographic ascending order: `0.8b`, `122b`, `27b`, `2b`, `9b`. |
| `reverse` | Reverse natural order. |
| `latest-first` | The concrete `*latest` variant first, then natural order. Menus without that marker use natural order. |
| `source` | Preserve the order returned by the public catalogue or daemon. |
| `size` | Smallest listed download size first. Public families use the size of their default `latest` variant. |
| `reverse-size` | Largest listed download size first, with the same default-variant rule. |

For example:

```zsh
zstyle ':completion:*:ollama*:*' model-sort size
```

Size menus use one candidate per line with its size. Equal sizes use natural
name order, and unknown sizes stay last in either direction. Size ranges sort
by their upper bound. Installed and running models use the daemon's reported
model size. A cold service request hydrates at most 32 families within a short
time budget; large selections may initially have unknown sizes. Further
requests fill the shared cache, prioritizing missing metadata. Fresh entries
are reused without another upstream fetch; failed refreshes retain successful
stale metadata.

Override just the tag menu for `pull`, for example:

```zsh
zstyle ':completion:*:ollama-pull:*:model-tags' model-sort latest-first
```

The completion tags are `remote-models` for public names, `model-tags` for an
explicit `model:` prefix, and `models` for installed/running models. An exact
bare public model name uses `remote-models` for its combined name/variant menu.
Sorting applies to each candidate list; installed candidates are added before
public candidates when a command offers both. Numeric sorting follows the
reference's text; it does not infer model quality. Unset or
unrecognized values use `natural`. Styles are read on each completion, including cached offline results,
and the `*latest` label stays attached to its variant in every order.

The CLI options were checked against Ollama `0.35.1` help and
[CLI source](https://github.com/ollama/ollama/blob/v0.35.1/cmd/cmd.go).
Hidden/internal flags are omitted. `--think` alone means `true`; explicit values
use `--think=high` or `--think=false`, not a separate word.

## Local development

Test a checkout without changing your existing Oh My Zsh installation:

```zsh
zsh -f
fpath=(/path/to/ohmyzsh/plugins/ollama $fpath)
autoload -Uz compinit
compinit -D
```

Then type the examples above and press Tab. Use a correctly installed system zsh
if another zsh executable on `PATH` lacks its completion modules.

If your current shell already loaded another Ollama plugin, changing `fpath`
alone does not replace its defined `_ollama` function. For a temporary test in
that shell, run:

```zsh
fpath=(/path/to/ohmyzsh/plugins/ollama $fpath)
unfunction _ollama 2>/dev/null
autoload -Uz _ollama
compdef _ollama ollama
```

This selects the checkout for the current shell session. A custom plugin at
`${ZSH_CUSTOM:-$ZSH/custom}/plugins/ollama` takes precedence over the repository's
plugin when Oh My Zsh loads, so check that path if a new shell still offers only
downloaded models for `pull`.

Run the offline behavioral checks from the repository root:

```zsh
zsh -f plugins/ollama/tests/run.zsh
```

Oh My Zsh's [contributing guidelines](../../CONTRIBUTING.md) require testers for
new plugins and disclosure of meaningful AI assistance in any future PR.

See [testing and contribution notes](TESTING.md) for verification evidence,
source references, and remaining validation limits.
