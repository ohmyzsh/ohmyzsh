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

`curl` is required for model completion. Installed/running models also require
`jq`. Neither dependency is installed by the plugin. Completion queries the daemon
specified by `OLLAMA_HOST` (default `http://127.0.0.1:11434`) without starting it.

### Pullable models and tags

```text
ollama pull qw<Tab>          # Matching public model names
ollama pull qwen3.5<Tab>     # Default name and concrete variants
ollama pull qwen3.5:<Tab>    # Concrete variants, including MLX and quantized tags
ollama pull qwen3.5:4<Tab>   # Matching tags such as 4b and 4b-mlx
```

Every model completion request fetches the current public catalogue from
[ollama.com](https://ollama.com/library). No catalogue is hardcoded and no network
request runs when the shell starts. Name lookup reads the public library; tag
lookup reads the model's tags page, including public `namespace/model` references.
Arbitrary registries and Hugging Face references can be typed normally, but are
not enumerated by the public catalogue.

Bare names select the default `latest` tag. The concrete variant carrying that
tag is described as `*latest (default)`; `model:latest` is not duplicated in the
tag menu. Explicit `model:latest` remains valid when typed manually.

Requests have a one-second connection timeout and a three-second overall timeout
(two seconds for daemon queries). An exact bare model name can make two requests:
one for the library and one for that model's tags. The last successful public
result is kept in shell memory and reused if a request fails. This cache lasts
until the shell exits; it is never written as executable shell code. With no successful result yet,
offline public completion offers no models. Shell matcher styles filter matches
locally; the full catalogue is fetched rather than sending your typed prefix.

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

Override just the tag menu for `pull`, for example:

```zsh
zstyle ':completion:*:ollama-pull:*:model-tags' model-sort latest-first
```

The completion tags are `remote-models` for public names, `model-tags` for an
explicit `model:` prefix, and `models` for installed/running models. An exact
bare public model name uses `remote-models` for its combined name/variant menu.
Sorting applies to each candidate list; installed candidates are added before
public candidates when a command offers both. Numeric sorting follows the
reference's text; it does not infer download size or model quality. Unset or
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
