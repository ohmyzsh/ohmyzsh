battery: use the same technique as in vpn_ip to avoid reset=2.

---

implement fake gitstatus api on top of vcs_info (or plain git?) + worker and use it if there is no
gitstatus.

---

- call vcs_info on worker. the tricky question is what to display while "loading".

---

- add _SHOW_SYSTEM to all *env segments.

---

- support states in SHOW_ON_COMMAND: POWERLEVEL9K_SEGMENT_STATE_SHOW_ON_COMMAND='...'

---

add POWERLEVEL9K_${SEGMENT}_${STATE}_SHOW_IN_DIR='pwd_pattern'; implement the same way as
SHOW_ON_UPGLOB. how should it interact with POWERLEVEL9K_${SEGMENT}_DISABLED_DIR_PATTERN?

---

add `p10k upglob`; returns 0 on match and sets REPLY to the directory where match was found.

---

when directory cannot be shortened any further, start chopping off segments from the left and
replacing the chopped off part with `…`. e.g., `…/x/anchor/y/anchor`. the shortest dir
representation is thus `…/last` or `…/last` depending on whether the last segment is an anchor.
the replacement parameter's value is `…/` (with a slash) to allow for `x/anchor/y/anchor`.

---

- add to faq: how do i display an environment variable in prompt? link it from "extensible"

---

- add to faq: how do i display an icon in prompt? link it from "extensible"

---

- add root_indicator to config templates

---

- test chruby and add it to config templates

---

- add ssh to config templates

---

- add swift version to config templates; see if there is a good pattern for PROJECT_ONLY

---

- add swiftenv

---

- add faq: how to customize directory shortening? mention POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER,
POWERLEVEL9K_DIR_MAX_LENGTH and co., and truncate_to_last.

---

fix a bug in zsh: https://github.com/romkatv/powerlevel10k/issues/502. to reproduce:

```zsh
emulate zsh -o prompt_percent -c 'print -P "%F{#ff0000}red%F{green}%B bold green"'
```

---

add `p10k explain` that prints something like this:

```text
segment     icons meaning

---

---

---

---

---

---

---

---
--
status      ✔  ✘  exit code of the last command
```

implement it the hard way: for every enabled segment go over all its {state,icon} pairs, resolve
the icon (if not absolute), apply VISUAL_IDENTIFIER_EXPANSION, remove leading and trailing
whitespace and print without formatting (sort of like `print -P | cat`); print segment names in
green and icons in bold; battery can have an unlimited number of icons, so `...` would be needed
(based on total length of concatenated icons rather than the number of icons); user-defined
segments would have "unknown" icons by default (yellow and not bold); can allow them to
participate by defining `explainprompt_foo` that populates array `reply` with strings like this:
'-s STATE -i LOCK_ICON +r'; the first element must be segment description.

---

add `docker_context` prompt segment; similar to `kubecontext`; the data should come from
`currentContext` field in `~/.docker/config.json` (according to
https://github.com/starship/starship/issues/995); there is also `DOCKER_CONTEXT`; more info:
https://docs.docker.com/engine/reference/commandline/context_use; also
https://github.com/starship/starship/pull/996.

---

support `env`, `ionice` and `strace` precommands in `parser.zsh`.

---

Add ruler to configuration wizard. Options: `─`, `·`, `╌`, `┄`, `▁`, `═`.

---

Add frame styles to the wizard.

```text
╭─
╰─

┌─
└─

┏━
┗━

╔═
╚═

▛▀
▙▄
```

Prompt connection should have matching options.

---

Add `POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_MIRROR_SEPARATOR`. If set, left segments get separated with
`POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR` followed by `POWERLEVEL9K_LEFT_SEGMENT_MIRROR_SEPARATOR`.
Each is drawn without background. The first with the foreground of left segment, the second with
the background of right segment. To insert space in between, embed it in
`POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_MIRROR_SEPARATOR`.
`POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR` is unused.

---

Add *Segment Connection* screen to configuration wizard with options *Fused*, *Touching* and
*Disjoint*. The last two differ by the absence/presence of space between `SEGMENT_SEPARATOR` and
`SEGMENT_MIRROR_SEPARATOR`.

*Fused* requires line separator (there is already a screen for it) but the other two options require
two filled separators similar to heads and tail. Figure out how to present this choice.

---

Optimize auto-wizard check.

```text
time ( repeat 1000 [[ -z "${parameters[(I)POWERLEVEL9K_*~(POWERLEVEL9K_MODE|POWERLEVEL9K_CONFIG_FILE)]}" ]] )
user=0.21s system=0.05s cpu=99% total=0.264

time ( repeat 1000 [[ -z "${parameters[(I)POWERLEVEL9K_*]}" ]] )
user=0.17s system=0.00s cpu=99% total=0.175
```

---

Add the equivalent of `P9K_PYTHON_VERSION` to all `*env` segments where it makes sense.

---

Define `P9K_ICON` on initialization. Fill it with `$icon`. Duplicate every key that ends in `_ICON`.
Respect `POWERLEVEL9K_VCS_STASH_ICON` overrides but not anything with segment name or state.

Define `POWERLEVEL9K_VCS_*` parameters in config templates for all symbols used in
`my_git_formatter`. Add missing entries to `icons`. Use `$P9K_ICON[...]` within `my_git_formatter`.
Add a screen to the wizard to choose between clear and circled icons.

---

Add a screen to the wizard asking whether to set `POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'`.
Show it only if there is `$HOME/.git`. By default this parameter should be commented out.
