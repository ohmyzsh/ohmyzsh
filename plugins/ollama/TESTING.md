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
zsh -f plugins/ollama/tests/windowed.zsh
```

The offline suite passed **127 checks** on system zsh `5.9`. It creates an isolated
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

The separate windowed-menu suite passed **20 checks** with 60 synthetic model
families in a 12-row terminal. It verifies bounded display, Tab/arrow navigation,
middle/final candidate reachability, Enter/colon acceptance, resizing to 8 and
24 rows, partial/unique completion, and restoration of unset and pre-existing
prompt settings before unrelated command completion. It uses Oh My Zsh's normal
global `menu select`; explicit `menu no` requests a pager instead of selection.
The shell-cache regression prevents prior four-field rows from entering enriched
tables in an already-open shell.

Five additional live viewport checks on 2026-10-08 used the deployed version-5
API's 245-family catalogue in a 12-row system-Zsh PTY. They verified bounded
initial display, the navigation footer, populated cloud-only metadata, and
selection of interior model 121 and final model 245. No model command executed.
The cache was warmed through 41 sequential requests of up to six families using
the existing bounded API. Final readback showed 245 update dates, 245 cloud
statuses, 238 contexts and 127 families with published capability badges. Context
can remain unknown for families without an unambiguous default or sole variant;
missing capability badges are not inferred. This was functional testing, not a
repeat of the prior version-3 volume test.

A blank `ollama pull <Tab>` also verifies public models absent from the local
inventory and makes no daemon or CLI model-list query. Session reload checks
start with an existing completion function and prove that the documented
`unfunction`/autoload sequence replaces it with the checkout's implementation.

Model ordering checks cycle through the real completion menu and verify natural,
alphabetical, reverse, latest-first, newest, popular, source, size,
reverse-size, and context order. Context checks compare raw token counts with
K/M units and fractional values, verify natural ties and unknowns last, use
running-model loaded context, preserve independent family/tag styles, and
reuse enriched offline metadata. They verify newest-added and popularity family ordering
independently of default-tag ordering, separate family/tag styles, and isolated
offline ranking caches. They cover public names,
numeric and fractional tags, installed models, a tag-specific style override,
unrecognized-value fallback, and a style change against cached offline results.
Size checks cover default-family sizes, SI units, range upper bounds, equal-size
natural ties, unknown sizes last, one variant per terminal line, and aligned
download-size columns. Family completion inserts `:` and continues into tag
selection. Family menus hide size metadata in every sorting mode, while size
ordering still uses the default variant's size. Interactive menus verify Enter
acceptance. The HTTP
fixtures use the shared service's eight-field completion TSV protocol. Requests
for family sizes are restricted to candidates matching the shell's rules.

Metadata checks verify one row per candidate in `run`, `show`, `push`, `cp`,
`rm`, `stop`, and `launch --model`, regardless of sorting mode. They cover
separate local/public table headers, aligned size/date/context/capability/cloud
columns, missing values, the concrete default badge, and metadata retained
during sorting. Commands, integrations, root flags, and run flags also have
one described entry per row. The test child clears inherited `FPATH` so that a
different Zsh installation cannot replace the system completion functions.

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
and lease races were tested with controlled clocks. These initial checks did
not include hosted load testing.

No live daemon was reachable during that initial validation. Installed-model
and running-model behavior was verified with API fixtures. No models were
pulled, pushed, created, run, stopped, copied, or removed.

On 2026-10-08, the 95 isolated ZLE checks passed again. The service passed all
24 cache/API tests. Additional controlled SQLite stress scenarios exercised
800 concurrent reader calls in groups of 100: cold refresh coalescing, warm
reuse, expiry, stale fallback during an upstream outage, retry backoff,
recovery, and independent newest/popular caches. Each shared-key refresh made
one upstream call. These are controlled tests, not distributed D1 load tests.

All 53 live ZLE checks passed in a corrected end-to-end run using the deployed
metadata API, installed Ollama 0.35.1 help, and a reachable local daemon.
They verified all nine family/tag sorting modes,
independent styles (including newest families with natural tags), colon
insertion and Enter acceptance, tag transitions, aligned sizes, family names
without sizes, local model candidates, free copy destinations, CLI integrations,
file arguments, and flags. Ordering checks traversed the first three matching
families and first five tags per mode using live metadata snapshots.
No model operation was executed. The daemon had no loaded models, so actual
running-model candidates remain untested; its empty running inventory was
checked. The controlled suite covers populated running-model responses.

The first live run had three incorrect harness expectations, involving combined
local/public run candidates, an empty running inventory, and Zsh's confirmation
prompt for 119 Dolphin tags. Corrected assertions retained the original results.
Large-list confirmation was disabled only in the test shell to check the menu.
The current user sorting styles were reproduced in an isolated shell; other
user configuration was excluded. Computer-use access to macOS Terminal was
denied, so these checks used actual Tab/menu/Enter keystrokes in a system-Zsh
pseudo-terminal. They do not constitute a human tester endorsement.

The deployed service received 320 bounded requests over roughly two
minutes, including 300 metadata reads in three stages. Actual peak concurrency
was 1, 5, and 7; request starts were capped at eight per second. All responses
passed their expected status and body contracts. Stage p95 response times were
1.13, 1.30, and 1.00 seconds. Two metadata responses exceeded the completion
client's three-second timeout, at 3.10 and 5.09 seconds. HTTP success therefore
does not establish that every completion request meets its deadline. Warm
shell metadata can fall back after a timeout; a cold shell has no such result.
Twenty follow-up reads using the client's actual curl timeouts succeeded in
0.47–1.04 seconds; they do not erase the two slower original observations.
Three JSON probes confirmed fresh catalogue indexes, while the overall stale
header reflected expired family-size entries retained in the lazy cache.
This bounded single-client run does not establish global capacity or long-term
availability, and no production outage or forced cache expiry was introduced.

The subsequent metadata-table change passed 118 controlled ZLE checks and
29 service tests, with independent verification. The service's enriched feed
was published as Sites version 4. A live catalogue read returned 245 eight-field
records with exact family update dates and capability/cloud metadata. The
published four-field feed remains available for its existing API consumers.
The enriched implementation then passed 36 live checks: 33 interaction checks
plus three targeted checks comparing metadata cells with their header columns.
These used actual daemon inventories and the deployed API in a wide isolated
system-Zsh pseudo-terminal. No model operations ran, and the daemon still had
no loaded models. An initial post-deployment diagnostic returned HTTP 400;
subsequent enriched reads worked. The cause of that first response was not
established. Original receipts and corrected harness expectations were retained.
The volume measurements above describe version 3; version 4 has not repeated
that load run. Richer metadata reuses existing fetch budgets and cache leases,
and family context is read only from already cached default-tag metadata.

## Upstream contribution

The branch was based on upstream master
`60c9a7a839b790cd905d0fd4419435124fd1bdc0`, following the
[contributing guidelines](../../CONTRIBUTING.md). Existing feature request
[#12336](https://github.com/ohmyzsh/ohmyzsh/issues/12336) describes the requested
feature. Upstream submission requires the repository's pull request template,
comparison with existing proposals, human tester endorsements, and meaningful
AI-assistance disclosure. This implementation and its tests were AI-assisted.
Local automated checks do not replace human tester endorsements.
