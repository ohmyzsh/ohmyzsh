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

The offline suite passed **46 checks** on system zsh `5.9`. It creates an isolated
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

The repository's CI syntax loop also passed for **593 files**. The local sandbox
emitted scheduler permission warnings while parsing existing background-command
syntax; no syntax failures occurred. CI has not run remotely for this branch.

## Live checks and limits

On 2026-10-07, HTTPS checks against the [public library](https://ollama.com/library)
returned 245 model families. The [Qwen 3.5 tags page](https://ollama.com/library/qwen3.5/tags)
returned 71 concrete tags after omitting the duplicate `latest` entry. Both the
bare and explicit `library/` namespace paths were checked. Live interactive Tab
completion displayed matching MLX/quantized variants and marked `qwen3.5:9b` as
`*latest (default)`.

Public enumeration parses Ollama's HTML pages, whose markup is not a documented
API contract. Site changes can interrupt discovery; a previously successful
in-memory result remains usable on failure, but may be stale. The catalogue
covers Ollama's public library and explicitly named public namespace tag pages;
private registries and Hugging Face repositories are not enumerated.

No live daemon was reachable during validation. Installed/running-model behavior
was verified with API fixtures; a user's running server and custom `OLLAMA_HOST`
configuration still need hands-on testing. No models were pulled, pushed,
created, run, stopped, copied, or removed.

## Upstream contribution

The branch was based on upstream master
`60c9a7a839b790cd905d0fd4419435124fd1bdc0`, following the
[contributing guidelines](../../CONTRIBUTING.md). Existing feature request
[#12336](https://github.com/ohmyzsh/ohmyzsh/issues/12336) should be referenced in a
future PR. Human tester endorsements and meaningful AI-assistance disclosure are
required for that submission. This implementation and its tests were AI-assisted.
No upstream PR has been submitted.
