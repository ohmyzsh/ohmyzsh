# Ollama completion testing

## Source baseline

Options and positional arguments were checked on 2026-10-07 against the installed
Ollama `0.35.1` client: root help and every public subcommand's `--help`.
Primary source references:

- [CLI definitions](https://github.com/ollama/ollama/blob/v0.35.1/cmd/cmd.go)
- [Launch parsing](https://github.com/ollama/ollama/blob/v0.35.1/cmd/launch/launch.go)
- [Integration registry](https://github.com/ollama/ollama/blob/v0.35.1/cmd/launch/registry.go)
- [Quantization levels](https://github.com/ollama/ollama/blob/v0.35.1/mlx/quant/quant.go)
- [Daemon host normalization](https://github.com/ollama/ollama/blob/v0.35.1/envconfig/config.go)
- [Official CLI overview](https://docs.ollama.com/cli)

Current upstream source was also inspected. Its additional `create --combine`
flag is absent from installed `0.35.1`; this completion targets that release's
public interface. Internal/hidden commands and flags are not advertised.

## Reproducible checks

From the repository root, using zsh with its standard completion modules:

```zsh
zsh -n plugins/ollama/_ollama
zsh -f plugins/ollama/tests/run.zsh
```

The offline suite passed **77 checks** on system zsh `5.9`. It creates an isolated
PTY shell and presses Tab through real ZLE and `_arguments`, using synthetic
HTTP/CLI fixtures. It never submits a model command or changes an Ollama server.

Coverage includes commands, root versus subcommand flags, options before and
after model arguments, optional equals-only thinking values, Modelfile paths,
quantization levels, new copy destinations, repeated removal arguments, running
models, model/tag insertion, namespace preservation, the latest marker,
deduplicated latest tags, dynamic integrations and existing CLI synonyms,
launch pass-through, refresh on the next Tab, warm and cold offline behavior,
disabled public requests, and missing `jq`. Loading the plugin makes no CLI or
network requests.

A blank `ollama pull <Tab>` also verifies public models absent from the local
inventory and makes no daemon or CLI model-list query. Session reload checks
start with an existing completion function and prove that the documented
`unfunction`/autoload sequence replaces it with the checkout's implementation.

Model ordering checks cycle through the real completion menu and verify natural,
alphabetical, reverse, latest-first, source, size, and reverse-size order. They
cover public names,
numeric and fractional tags, installed models, a tag-specific style override,
unrecognized-value fallback, and a style change against cached offline results.
Size checks cover default-family sizes, SI units, range upper bounds, equal-size
natural ties, unknown sizes last, one variant per terminal line, and aligned
download-size columns. Family completion inserts `:` and continues into tag
selection; an interactive menu also verifies Enter acceptance. The HTTP
fixtures use the shared service's four-field TSV protocol. Requests for family
sizes are restricted to candidates matching the shell's completion rules.

The repository's CI syntax loop also passed for **593 files**. The local sandbox
emitted scheduler permission warnings while parsing existing background-command
syntax; no syntax failures occurred. These are local results; the upstream pull
request reports remote CI separately.

## Live checks and limits

On 2026-10-07, HTTPS checks against the [public library](https://ollama.com/library)
returned 245 model families. The [Qwen 3.5 tags page](https://ollama.com/library/qwen3.5/tags)
returned 71 concrete tags after omitting the duplicate `latest` entry. Both the
bare and explicit `library/` namespace paths were checked. Live interactive Tab
completion displayed matching MLX/quantized variants and marked `qwen3.5:9b` as
`*latest (default)`.

Those initial checks exercised the direct parser before migration to the shared
service. Public completion now uses the
[shared metadata API](https://ollama-model-cache.amcox886.chatgpt.site/api/v1/models).
HTML parsing lives in the service, whose durable cache has a ten-minute TTL,
atomic refresh leases, bounded concurrency, and stale data retention. Ollama's
markup is not a documented API contract; changes can interrupt refreshes.
A previously successful service or shell result remains usable on failure,
but may be stale. The catalogue
covers Ollama's public library and explicitly named public namespace tag pages;
private registries and Hugging Face repositories are not enumerated.

The public Sites deployment was verified anonymously on 2026-10-07. Health
reported storage ready, the catalogue returned 245 families, and Qwen 3.8 returned
11 concrete tags with listed sizes. Repeat reads preserved the same fresh-cache
timestamp. Invalid traversal input returned HTTP 400. Live ZLE completion using
the default service URL displayed one Qwen 3.8 variant per line, size order,
`18GB` on the concrete `27b` default, and `56GB` on `27b-mlx-bf16`.
The separate service passed 21 SQLite-backed cache/API tests, TypeScript,
ESLint, a portable Vinext build, and local D1 migration/HTTP checks. Cache expiry
and lease races were tested with controlled clocks; hosted availability under
sustained public load has not been tested.

No live daemon was reachable during validation. Installed/running-model behavior
was verified with API fixtures; a user's running server and custom `OLLAMA_HOST`
configuration still need hands-on testing. No models were pulled, pushed,
created, run, stopped, copied, or removed.

## Upstream contribution

The branch was based on upstream master
`60c9a7a839b790cd905d0fd4419435124fd1bdc0`, following the
[contributing guidelines](../../CONTRIBUTING.md). Existing feature request
[#12336](https://github.com/ohmyzsh/ohmyzsh/issues/12336) describes the requested
feature. Upstream submission requires the repository's pull request template,
comparison with existing proposals, human tester endorsements, and meaningful
AI-assistance disclosure. This implementation and its tests were AI-assisted.
Local automated checks do not replace human tester endorsements.
