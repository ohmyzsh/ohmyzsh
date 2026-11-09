# Personal Zsh configuration

This directory captures the local macOS Oh My Zsh customizations without changing
the upstream default template or checking in third-party plugin repositories.

- `zshrc`: Powerlevel10k, the existing plugin selection, history/completion
  autosuggestions, and up/down history substring search.
- `p10k.zsh`: the existing Pure-style two-line prompt, right-side context,
  command duration, virtual environment, and transient/instant prompt settings.
- `zshenv`: prevents an inherited allproxy virtualenv from overriding Python
  unless that virtualenv was explicitly activated. The same local `.zprofile`
  behavior is covered here, so a second copy is unnecessary.
- `local.zsh.example`: optional machine-specific paths and development shortcuts.
  Authentication integrations only reference external files in `~/.zshrc.d`;
  those files and credentials are deliberately excluded.

## Dependencies

Use Zsh on macOS with an Oh My Zsh installation in `~/.oh-my-zsh`. Install these
custom dependencies only if their destination directories do not already exist:

```zsh
git clone https://github.com/romkatv/powerlevel10k.git \
  ~/.oh-my-zsh/custom/themes/powerlevel10k
git -C ~/.oh-my-zsh/custom/themes/powerlevel10k checkout 604f19a9eaa18e76db2e60b8d446d5f879065f90

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions checkout 85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git -C ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting checkout 1d85c692615a25fe2293bdd44b34c217d5d2bf04
```

These revisions match the source machine. The fork also bundles autosuggestions;
the custom checkout above preserves the version used locally. Other enabled
plugins are bundled with Oh My Zsh. `zsh-syntax-highlighting` stays last in the
plugin list. Use a Nerd Font for the configured prompt glyphs.

## Apply manually

Review the files first and back up any existing `~/.zshrc`, `~/.p10k.zsh`,
`~/.zshenv`, and `~/.zshrc.local` before replacing them. From the repository root:

```zsh
cp personal/zshrc ~/.zshrc
cp personal/p10k.zsh ~/.p10k.zsh
```

Merge `personal/zshenv` into your existing `~/.zshenv`; do not overwrite unrelated
startup settings. To retain the optional tooling, copy `local.zsh.example` to
`~/.zshrc.local` or merge it into that file and edit it for your machine. It
contains Rancher Desktop, Java 17, Codex/Claude mode shortcuts, kiab, lf-oke,
coding-agent-flow, and SCM SSH shortcuts from the source setup. Those commands
require their own installations. The SCM SSH agent is started manually to avoid
running authentication during every shell startup. Remove unavailable shortcuts.
Homebrew Maven uses the normal Homebrew PATH instead of placeholder Cellar paths.

Private authentication files must remain outside the repository. Load any local
initialization requiring password prompts before the Powerlevel10k instant
prompt block. Open a new terminal after applying the configuration.

## Verify without installing

```zsh
zsh -n personal/zshrc
zsh -n personal/p10k.zsh
zsh -n personal/zshenv
zsh -n personal/local.zsh.example
```
