# profiles plugin

The `profiles` plugin allows you to automatically load machine-specific Zsh configuration files based on your fully qualified hostname.
This is especially useful if you work across multiple systems (e.g. personal laptop, work server, containers) and need different aliases, environament variables, or behaveors on each.

To use it, add `profiles` to the plugins array of your zshrc file:

```sh
plugins=(... profiles)
```

## How It Works
The plugin inspects the `$HOST` environament variable and attempts to source configuration files based on its domain hierarchy.
For a hostname like:
```bash
HOST=host.domain.com
```
It fill try to source the following files in order of generality -> specificity:
```text
$ZSH_CUSTOM/profiles/com
$ZSH_CUSTOM/profiles/domain.com
$ZSH_CUSTOM/profiles/host.domain.com
```
Each files is sourced if it exists. More specific files override earlier general settings.

## Directory Structure
Create your profile files under:
```bash
$ZSH_CUSTOM/profiles/
```
Example structure:
```bash
~/.oh-my-zsh/custom/
├── plugins/
│   └── profiles/
│       └── profiles.plugin.zsh
└── profiles/
    ├── com
    ├── domain.com
    └── host.domain.com
```

## Example
For `HOST=dev.internal.example.com`, the plugin will attempts to load:
```bash
$ZSH_CUSTOM/profiles/com
$ZSH_CUSTOM/profiles/example.com
$ZSH_CUSTOM/profiles/internal.example.com
$ZSH_CUSTOM/profiles/dev.internal.example.com
```

## Tips
 - Each profile file should contain valid Zsh code (e.g., `export`, `alias`, etc.).
 - Later (more specific) profiles override settings from earlier (more general) ones.
 - You can use this for environment-specific variables, host-specific tool paths, aliases, or functions.
