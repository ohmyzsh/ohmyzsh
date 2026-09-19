# hermes plugin

This plugin adds completions for the Hermes AI agent.

To use it, add `hermes` to the plugin array in your zshrc file:

```zsh
plugins=(... hermes)
```

## Completions

| Argument | Description |
| :--- | :--- |
| acp | Run Hermes Agent as an ACP (Agent Client Protocol) server |
| approvals | Approval-prompt tools (mine history into allowlist proposals) |
| auth | Manage pooled provider credentials |
| backup | Back up Hermes home directory to a zip file |
| browser | Real-profile browsing helpers (close a browser locking its profile) |
| bundles | Create, list, and manage skill bundles (aliases for multiple skills) |
| chat | Interactive chat with the agent |
| checkpoints | Inspect / prune / clear ~/.hermes/checkpoints/ |
| claw | OpenClaw migration tools |
| completion | Print shell completion script (bash, zsh, or fish) |
| computer-use | Manage the Computer Use (cua-driver) backend (macOS/Windows/Linux) |
| config | View and edit configuration |
| console | Open the safe Hermes command console |
| cron | Cron job management |
| curator | Background skill maintenance (curator) — status, run, pause, pin |
| dashboard | Start the web UI dashboard |
| debug | Debug tools — upload logs and system info for support |
| desktop | Build and launch the native desktop app |
| doctor | Check configuration and dependencies |
| dump | Dump setup summary for support/debugging |
| egress | Manage the iron-proxy egress credential-injection firewall |
| fallback | Manage fallback providers (tried when the primary model fails) |
| gateway | Messaging gateway management |
| hooks | Inspect and manage shell-script hooks |
| import | Restore a Hermes backup from a zip file |
| import-agent | Import a Claude Code or Codex CLI setup into Hermes |
| insights | Show usage insights and analytics |
| journey | Timeline of learned skills + memories over time |
| kanban | Multi-profile collaboration board (tasks, links, comments) |
| logout | Clear authentication for an inference provider |
| logs | View and filter Hermes log files |
| lsp | Language Server Protocol management |
| mcp | Manage MCP servers and run Hermes as an MCP server |
| memory | Configure external memory provider |
| migrate | Migrate configuration for retired models or deprecated settings |
| moa | Configure Mixture of Agents provider/model slots |
| model | Select default model and provider |
| monitoring | Inspect gateway monitoring (health & diagnostics export) |
| pairing | Manage DM pairing codes for user authorization |
| pause | Emergency stop: pause cron/kanban dispatch and new gateway turns |
| peer | Bot-to-bot DMs across machines (peer Hermes gateways) |
| pets | Browse, install, and select petdex animated pets |
| plugins | Manage and validate plugins |
| portal | Set up Nous Portal (login, model pick, Tool Gateway); see also `portal info` |
| profile | Manage profiles — multiple isolated Hermes instances |
| project | Manage projects (named, multi-folder workspaces) |
| prompt-size | Show a byte breakdown of the system prompt + tool schemas |
| proxy | Local OpenAI-compatible proxy to OAuth providers |
| resume | Lift the emergency stop set by `hermes pause` |
| secrets | Manage external secret sources (Bitwarden, 1Password) |
| security | Supply-chain audit (OSV.dev) for venv, plugins, and MCP servers |
| send | Send a message to a configured platform (scripts, cron jobs, CI) |
| serve | Start the Hermes backend server (headless; powers the desktop app and remote backends) |
| sessions | Manage session history (list, rename, export, prune, delete) |
| setup | Interactive setup wizard |
| skills | Search, install, configure, and manage skills |
| skin | List, switch, and tweak skins |
| slack | Slack integration helpers (manifest generation, etc.) |
| status | Show status of all components |
| sync | Skill Sync — sync your skills across devices and with your team |
| tools | Configure which tools are enabled per platform |
| uninstall | Uninstall Hermes Agent |
| update | Update Hermes Agent to the latest version |
| vault | Manage the local encrypted autofill vault (add/list/rm credentials) |
| verify | Detect a project's run recipe and smoke-test it |
| webhook | Manage dynamic webhook subscriptions |
| whatsapp | Set up WhatsApp integration |
| whatsapp-cloud | Set up WhatsApp Business Cloud API integration |
| worktree | Audit and reclaim accumulated git worktrees and merged branches |
