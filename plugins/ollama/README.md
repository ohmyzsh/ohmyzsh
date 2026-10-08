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
ollama pull qw<Tab>          # Matching public model names, followed by :
ollama pull qwen3.5<Tab>     # Concrete variants for an exact model name
ollama pull qwen3.5:<Tab>    # Concrete variants, including MLX and quantized tags
ollama pull qwen3.5:4<Tab>   # Matching tags such as 4b and 4b-mlx
```

Selecting a public model family inserts a trailing `:` instead of a space.
Press Tab again to select its tag in the same argument. This also applies when
Enter accepts a family from zsh's interactive selection menu. An untagged model
can still be typed normally to pull its default variant.

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
manually. Every model menu lists one candidate per line with aligned metadata
columns. Tag menus include download size and the concrete default marker:

```text
Model               -- Size  Updated     Context  Family capabilities   Cloud
qwen3.8:27b          -- 18GB  1 week ago  256K     vision,tools,thinking  no     *latest (default)
qwen3.8:27b-mlx-bf16 -- 56GB  1 week ago  256K     vision,tools,thinking  no
```

These are rounded sizes published by Ollama, not remaining download bytes after
locally cached layers. The example illustrates the layout; values change with
the library. Missing metadata is shown as `-`.

Public family menus show update date, default-tag context when already cached,
family capabilities, and cloud availability. A family without a default can
show its sole concrete variant's context; multiple variants without a default
leave context unknown. Family menus omit download size in every
sorting mode. A family's cloud availability does not mean every variant runs in
the cloud. Tag menus show the selected variant's context and cloud status;
their capability column is explicitly family-level, not a guarantee for every
variant. Public tag updates use Ollama's relative age because the tag list does
not expose exact dates. Capabilities can include completion, tools, insert,
vision, embedding, thinking, image, audio, and decision when reported by Ollama.

Installed-model menus show reported size, local `Modified` date, capabilities,
and cloud references from the daemon. The inventory does not report the maximum
supported context, so that value remains unknown. Running-model menus label
their reported runtime value `Loaded context`; it is not the supported maximum.
Completion does not issue a separate model-details request for each candidate.

### Scrolling long menus

Long Ollama completion tables use Zsh's scrolling selection menu and stay within
the terminal height. Every match remains available; the list is not truncated.
Tab or the arrow keys move the selection, the footer shows the current position,
and Enter accepts the selected reference without running the command. Ambiguous
lists enter selection when displayed; unique matches complete normally. If menu
selection is explicitly disabled with `menu no`, long lists use a pager instead.

These defaults apply only to Ollama. To change them, put more specific styles in
`.zshrc` after Oh My Zsh loads, for example:

```zsh
zstyle ':completion:*:*:ollama*:*:default' select-scroll 1
zstyle ':completion:*:*:ollama*:*:default' select-prompt '%S%p -- %m matches%s'
```

`select-scroll 1` scrolls one line at a time; the plugin default `0` scrolls by
half a screen. See [Zsh's completion styles](https://zsh.sourceforge.io/Doc/Release/Completion-System.html)
for other menu and scrolling settings.

After updating the installed plugin, start a fresh shell to reload all completion
helpers and styles together. An existing shell can retain an older feed reader
even if a newer table renderer was loaded separately.
Commands and launch integrations also display one name/description per line.

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
eight-field `format=completion-tsv` data and are never executed as shell code.

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
| `newest` | Public families in Ollama's newest-added library order. Tags and installed/running models use natural order. |
| `popular` | Public families in Ollama's popularity order. Tags and installed/running models use natural order. |
| `source` | Preserve the order returned by the public catalogue or daemon. |
| `size` | Smallest listed download size first. Public families use the size of their default `latest` variant. |
| `reverse-size` | Largest listed download size first, with the same default-variant rule. |
| `context` | Smallest reported context window first; equal values use natural name order and unknown values stay last. |

For example:

```zsh
zstyle ':completion:*:ollama*:*' model-sort size
```

Public family menus omit download size, including when sorted by size. Download
sizes appear in tag menus, and installed/running menus show their reported
sizes regardless of sorting mode. Equal sizes use natural
name order, and unknown sizes stay last in either direction. Size ranges sort
by their upper bound. Installed and running models use the daemon's reported
model size. A cold service request hydrates at most 32 families within a short
time budget; large selections may initially have unknown sizes. Further
requests fill the shared cache, prioritizing missing metadata. Fresh entries
are reused without another upstream fetch; failed refreshes retain successful
stale metadata.

Context sorting compares numeric token counts, including abbreviated values:
`K`, `M`, `G`, and `T` multiply by powers of 1024 (`4K` equals `4096`). Public
families use their cached default or sole-variant context, tags use the selected
variant's context, and running models use their loaded context. Installed models
without a reported context use natural name order among the unknown entries.
Public family context sorting uses the same bounded matching-family cache
refresh as size sorting. Configure it independently from tag order, for example:

```zsh
zstyle ':completion:*:ollama-pull:*:remote-models' model-sort context
zstyle ':completion:*:ollama-pull:*:model-tags' model-sort natural
```

Override just the tag menu for `pull`, for example:

```zsh
zstyle ':completion:*:ollama-pull:*:model-tags' model-sort latest-first
```

Choose a separate family order, for example newest families and natural tags:

```zsh
zstyle ':completion:*:ollama-pull:*:remote-models' model-sort newest
zstyle ':completion:*:ollama-pull:*:model-tags' model-sort natural
```

`newest` and `popular` follow the library's own rankings, retained by the shared
service in separate ten-minute caches. `newest` means additions to the library,
not recently updated model files. Family menus show metadata without sizes.

The completion tags are `remote-models` for public names, `model-tags` for an
explicit `model:` prefix, and `models` for installed/running models. An exact
bare public model name also uses `model-tags` when its tag lookup succeeds.
If that lookup fails, available family candidates remain under `remote-models`.
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
