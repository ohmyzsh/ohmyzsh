#compdef hermes
# Hermes Agent zsh completion
# Add to ~/.zshrc:
#   eval "$(hermes completion zsh)"

_hermes_profiles() {
    local -a profiles
    profiles=(default)
    if [[ -d "$HOME/.hermes/profiles" ]]; then
        profiles+=($HOME/.hermes/profiles/*(N/:t))
    fi
    _describe 'profile' profiles
}

_hermes() {
    local context state line
    typeset -A opt_args

    _arguments -C \
        '(-)'{-h,--help}'[Show help and exit]' \
        '(-)'{-V,--version}'[Show version and exit]' \
        '(-)'{-p,--profile}'[Profile name]:profile:_hermes_profiles' \
        '1:command:->commands' \
        '*::arg:->args'

    case $state in
        commands)
            local -a subcmds
            subcmds=(
                'acp:Run Hermes Agent as an ACP (Agent Client Protocol) server'
                'approvals:Approval-prompt tools (mine history into allowlist proposals'
                'auth:Manage pooled provider credentials'
                'backup:Back up Hermes home directory to a zip file'
                'browser:Real-profile browsing helpers (close a browser locking its p'
                'bundles:Create, list, and manage skill bundles (aliases for multiple'
                'chat:Interactive chat with the agent'
                'checkpoints:Inspect / prune / clear ~/.hermes/checkpoints/'
                'claw:OpenClaw migration tools'
                'completion:Print shell completion script (bash, zsh, or fish)'
                'computer-use:Manage the Computer Use (cua-driver) backend (macOS/Windows/'
                'config:View and edit configuration'
                'console:Open the safe Hermes command console'
                'cron:Cron job management'
                'curator:Background skill maintenance (curator) — status, run, pause,'
                'dashboard:Start the web UI dashboard'
                'debug:Debug tools — upload logs and system info for support'
                'desktop:Build and launch the native desktop app'
                'doctor:Check configuration and dependencies'
                'dump:Dump setup summary for support/debugging'
                'egress:Manage the iron-proxy egress credential-injection firewall'
                'fallback:Manage fallback providers (tried when the primary model fail'
                'gateway:Messaging gateway management'
                'hooks:Inspect and manage shell-script hooks'
                'import:Restore a Hermes backup from a zip file'
                'import-agent:Import a Claude Code or Codex CLI setup into Hermes'
                'insights:Show usage insights and analytics'
                'journey:Timeline of learned skills + memories over time'
                'kanban:Multi-profile collaboration board (tasks, links, comments)'
                'logout:Clear authentication for an inference provider'
                'logs:View and filter Hermes log files'
                'lsp:Language Server Protocol management'
                'mcp:Manage MCP servers and run Hermes as an MCP server'
                'memory:Configure external memory provider'
                'migrate:Migrate configuration for retired models or deprecated setti'
                'moa:Configure Mixture of Agents provider/model slots'
                'model:Select default model and provider'
                'monitoring:Inspect gateway monitoring (health & diagnostics export)'
                'pairing:Manage DM pairing codes for user authorization'
                'pause:Emergency stop: pause cron/kanban dispatch and new gateway t'
                'peer:Bot-to-bot DMs across machines (peer Hermes gateways)'
                'pets:Browse, install, and select petdex animated pets'
                'plugins:Manage and validate plugins'
                'portal:Set up Nous Portal (login, model pick, Tool Gateway); see al'
                'profile:Manage profiles — multiple isolated Hermes instances'
                'project:Manage projects (named, multi-folder workspaces)'
                'prompt-size:Show a byte breakdown of the system prompt + tool schemas'
                'proxy:Local OpenAI-compatible proxy to OAuth providers'
                'resume:Lift the emergency stop set by `hermes pause`'
                'secrets:Manage external secret sources (Bitwarden, 1Password)'
                'security:Supply-chain audit (OSV.dev) for venv, plugins, and MCP serv'
                'send:Send a message to a configured platform (scripts, cron jobs,'
                'serve:Start the Hermes backend server (headless; powers the deskto'
                'sessions:Manage session history (list, rename, export, prune, delete)'
                'setup:Interactive setup wizard'
                'skills:Search, install, configure, and manage skills'
                'skin:List, switch, and tweak skins'
                'slack:Slack integration helpers (manifest generation, etc.)'
                'status:Show status of all components'
                'sync:Skill Sync — sync your skills across devices and with your t'
                'tools:Configure which tools are enabled per platform'
                'uninstall:Uninstall Hermes Agent'
                'update:Update Hermes Agent to the latest version'
                'vault:Manage the local encrypted autofill vault (add/list/rm crede'
                'verify:Detect a projects run recipe and smoke-test it'
                'webhook:Manage dynamic webhook subscriptions'
                'whatsapp:Set up WhatsApp integration'
                'whatsapp-cloud:Set up WhatsApp Business Cloud API integration'
                'worktree:Audit and reclaim accumulated git worktrees and merged branc'
            )
            _describe 'hermes command' subcmds
            ;;
        args)
            case ${line[1]} in
                approvals)
                    local -a approvals_cmds
                    approvals_cmds=(
                    'suggest:Propose command_allowlist entries from past approvals'
                    'test:Dry-run the approval verdict for a command (never executes i'
                    )
                    _describe 'approvals command' approvals_cmds
                    ;;
                auth)
                    local -a auth_cmds
                    auth_cmds=(
                    'add:Add a pooled credential'
                    'list:List pooled credentials'
                    'logout:Log out a provider and clear stored auth state'
                    'priority:Move a pooled credential to a priority (0 = tried first unde'
                    'refresh:Refresh a pooled OAuth credentials tokens and clear its cool'
                    'remove:Remove a pooled credential by index, id, or label'
                    'reset:Clear exhaustion status for a providers credentials (all, or'
                    'spotify:Authenticate Hermes with Spotify via PKCE'
                    'status:Show auth status for a provider'
                    'upgrade:Sign in with a Nous account, keeping your connectors'
                    )
                    _describe 'auth command' auth_cmds
                    ;;
                browser)
                    local -a browser_cmds
                    browser_cmds=(
                    'close-profile:Close the browser locking your real profile (asks nothing — '
                    )
                    _describe 'browser command' browser_cmds
                    ;;
                bundles)
                    local -a bundles_cmds
                    bundles_cmds=(
                    'create:Create a new skill bundle'
                    'delete:Delete a skill bundle'
                    'list:List installed skill bundles'
                    'reload:Re-scan the bundles directory and report changes'
                    'show:Show one bundles contents'
                    )
                    _describe 'bundles command' bundles_cmds
                    ;;
                checkpoints)
                    local -a checkpoints_cmds
                    checkpoints_cmds=(
                    'clear:Delete the entire checkpoint base (all /rollback history)'
                    'clear-legacy:Delete only the legacy-<ts>/ archives from v1 migration'
                    'list:Alias for status'
                    'prune:Delete orphan/stale checkpoints and GC the store'
                    'status:Show total size, project count, and per-project breakdown'
                    )
                    _describe 'checkpoints command' checkpoints_cmds
                    ;;
                claw)
                    local -a claw_cmds
                    claw_cmds=(
                    'cleanup:Archive leftover OpenClaw directories after migration'
                    'migrate:Migrate from OpenClaw to Hermes'
                    )
                    _describe 'claw command' claw_cmds
                    ;;
                computer-use)
                    local -a computer_use_cmds
                    computer_use_cmds=(
                    'doctor:Run cua-driver `health_report` and surface the check matrix'
                    'install:Install or repair the cua-driver binary (macOS/Windows/Linux'
                    'permissions:Check or grant macOS Accessibility + Screen Recording (macOS'
                    'status:Print whether cua-driver is installed and on PATH'
                    )
                    _describe 'computer-use command' computer_use_cmds
                    ;;
                config)
                    local -a config_cmds
                    config_cmds=(
                    'check:Check for missing/outdated config'
                    'edit:Open config file in editor'
                    'env-path:Print .env file path'
                    'get:Print a resolved configuration value'
                    'migrate:Update config with new options'
                    'path:Print config file path'
                    'set:Set a configuration value'
                    'show:Show current configuration'
                    'unset:Remove a configuration value'
                    )
                    _describe 'config command' config_cmds
                    ;;
                cron)
                    local -a cron_cmds
                    cron_cmds=(
                    'create:Create a scheduled job'
                    'doctor:Check scheduled jobs for common health issues'
                    'edit:Edit an existing scheduled job'
                    'incidents:List or acknowledge durable cron failure incidents'
                    'list:List scheduled jobs'
                    'notepad:Read/write a jobs durable notepad (persistent KV across runs'
                    'pause:Pause a scheduled job'
                    'remove:Remove a scheduled job'
                    'resnap:Adopt the current global inference resolution for unpinned j'
                    'resume:Resume a paused job'
                    'run:Run a job on the next scheduler tick'
                    'runs:Show durable execution attempts'
                    'status:Check if cron scheduler is running'
                    'tick:Run due jobs once and exit'
                    )
                    _describe 'cron command' cron_cmds
                    ;;
                curator)
                    local -a curator_cmds
                    curator_cmds=(
                    'adopt:Hand unmanaged skills to the curator (provenance is a user d'
                    'archive:Manually archive a skill (move to .archive/, excluded from p'
                    'backup:Take a manual tar.gz snapshot of ~/.hermes/skills/ (curator '
                    'ledger:List the per-mutation skill audit ledger (all actors: curato'
                    'list-archived:List archived skills'
                    'list-unmanaged:List curation-eligible skills with no provenance marker'
                    'pause:Pause the curator until resumed'
                    'pin:Pin a skill so the curator never auto-transitions it'
                    'prune:Bulk-archive curator-managed skills idle for >= N days (defa'
                    'purge:Delete archived skills older than curator.archive_ttl_days ('
                    'restore:Restore an archived skill'
                    'resume:Resume a paused curator'
                    'rollback:Restore ~/.hermes/skills/ from a curator snapshot, or a sing'
                    'run:Trigger a curator review now'
                    'status:Show curator status and skill stats'
                    'unpin:Unpin a skill'
                    'usage:Show usage telemetry for ALL skills (built-in, hub, agent) w'
                    )
                    _describe 'curator command' curator_cmds
                    ;;
                dashboard)
                    local -a dashboard_cmds
                    dashboard_cmds=(
                    'register:Register a self-hosted dashboard with Nous Portal (writes th'
                    )
                    _describe 'dashboard command' dashboard_cmds
                    ;;
                debug)
                    local -a debug_cmds
                    debug_cmds=(
                    'delete:Delete a paste uploaded by hermes debug share'
                    'share:Upload debug report to a paste service and print a shareable'
                    )
                    _describe 'debug command' debug_cmds
                    ;;
                egress)
                    local -a egress_cmds
                    egress_cmds=(
                    'config:Print the generated proxy.yaml path'
                    'disable:Turn off the proxy integration'
                    'install:Download iron-proxy binary (v0.39.0)'
                    'reload:Hot-reload the running daemons ruleset from proxy.yaml (mana'
                    'restart:Restart the managed iron-proxy (stop if running, then start)'
                    'setup:Interactive wizard: install + CA + mint tokens + write confi'
                    'start:Start the managed iron-proxy'
                    'status:Show proxy state and mappings'
                    'stop:Stop the managed iron-proxy'
                    )
                    _describe 'egress command' egress_cmds
                    ;;
                fallback)
                    local -a fallback_cmds
                    fallback_cmds=(
                    'add:Pick a provider + model (same picker as `hermes model`) and '
                    'clear:Remove all fallback entries'
                    'list:Show the current fallback chain (default when no subcommand)'
                    'remove:Pick an entry to delete from the chain'
                    )
                    _describe 'fallback command' fallback_cmds
                    ;;
                gateway)
                    local -a gateway_cmds
                    gateway_cmds=(
                    'enroll:Enroll this gateway with a relay connector (writes relay aut'
                    'install:Install gateway as a systemd/launchd background service'
                    'list:List all profiles and their gateway status'
                    'migrate:Move per-profile gateways onto one multiplexed default gatew'
                    'migrate-legacy:Remove legacy hermes.service units from pre-rename installs'
                    'restart:Restart gateway service'
                    'run:Run gateway in foreground (recommended for WSL, Docker, Term'
                    'setup:Configure messaging platforms'
                    'start:Start the installed systemd/launchd background service'
                    'status:Show gateway status'
                    'stop:Stop gateway service'
                    'uninstall:Uninstall gateway service'
                    )
                    _describe 'gateway command' gateway_cmds
                    ;;
                hooks)
                    local -a hooks_cmds
                    hooks_cmds=(
                    'doctor:Check each configured hook: exec bit, allowlist, mtime drift'
                    'list:List configured hooks with matcher, timeout, and consent sta'
                    'revoke:Remove a commands allowlist entries (takes effect on next re'
                    'test:Fire every hook matching <event> against a synthetic payload'
                    )
                    _describe 'hooks command' hooks_cmds
                    ;;
                journey)
                    local -a journey_cmds
                    journey_cmds=(
                    'delete:Delete a learned skill (archived) or memory by node id.'
                    'edit:Edit a learned skill or memory by node id in $EDITOR.'
                    'list:List node ids (for delete/edit).'
                    )
                    _describe 'journey command' journey_cmds
                    ;;
                kanban)
                    local -a kanban_cmds
                    kanban_cmds=(
                    'archive:Archive one or more tasks'
                    'assign:Assign or reassign a task'
                    'assignees:List known profiles + per-profile task counts (union of ~/.h'
                    'attach:Attach a local file to a task'
                    'attach-rm:Delete an attachment by id'
                    'attachments:List a tasks attachments'
                    'block:Mark one or more tasks blocked'
                    'boards:Manage kanban boards (one board per project / workstream)'
                    'claim:Atomically claim a ready task (prints resolved workspace pat'
                    'comment:Append a comment'
                    'complete:Mark one or more tasks done'
                    'context:Print the full context a worker sees for a task (title + bod'
                    'create:Create a new task'
                    'daemon:DEPRECATED — dispatcher now runs in the gateway. Use `hermes'
                    'decompose:Decompose a triage-column task into a graph of child tasks r'
                    'diagnostics:List active diagnostics on the current board'
                    'dispatch:One dispatcher pass: reclaim stale, promote ready, spawn wor'
                    'edit:Edit recovery fields on an already-completed task'
                    'gc:Garbage-collect archived-task workspaces, old events, and ol'
                    'heartbeat:Emit a heartbeat event for a running task (worker liveness s'
                    'init:Create kanban.db if missing (idempotent)'
                    'link:Add a parent->child dependency'
                    'list:List tasks'
                    'log:Print the worker log for a task (from <kanban-root>/kanban/l'
                    'notify-list:List notification subscriptions (optionally for a single tas'
                    'notify-subscribe:Subscribe a gateway source to a tasks terminal events (used '
                    'notify-unsubscribe:Remove a gateway subscription from a task'
                    'promote:Manually move one or more todo/blocked tasks to ready (recov'
                    'reassign:Reassign a task to a different profile, optionally reclaimin'
                    'reclaim:Release an active worker claim on a running task'
                    'reopen-review:Send one or more review tasks back for changes (review -> re'
                    'repair:Check kanban.db integrity and auto-repair index-only corrupt'
                    'request-changes:Reviewer verdict: return the active review run to its implem'
                    'request-review:Move a task to review (implementation done, awaiting review)'
                    'runs:Show attempt history for a task (one row per run: profile, o'
                    'schedule:Park one or more tasks in Scheduled (waiting on time, not hu'
                    'set-model:Set or clear a tasks model/provider override (takes effect o'
                    'show:Show a task with comments + events'
                    'specify:Flesh out a triage-column task into a concrete spec (title +'
                    'stats:Per-status + per-assignee counts + oldest-ready age'
                    'swarm:Create a Kanban Swarm v1 graph (parallel workers → verifier '
                    'tail:Follow a tasks event stream'
                    'unblock:Return blocked/scheduled tasks to ready, or todo while paren'
                    'unlink:Remove a parent->child dependency'
                    'watch:Live-stream task_events to the terminal (Ctrl+C to exit)'
                    )
                    _describe 'kanban command' kanban_cmds
                    ;;
                lsp)
                    local -a lsp_cmds
                    lsp_cmds=(
                    'install:Install a server binary'
                    'install-all:Install every server with a known auto-install recipe'
                    'list:List supported language servers'
                    'restart:Tear down running LSP clients (next edit re-spawns)'
                    'status:Show LSP service status'
                    'which:Print binary path for a server'
                    )
                    _describe 'lsp command' lsp_cmds
                    ;;
                mcp)
                    local -a mcp_cmds
                    mcp_cmds=(
                    'add:Add an MCP server (discovery-first install)'
                    'catalog:List Nous-approved MCPs available for one-click install'
                    'configure:Toggle tool selection'
                    'install:Install a catalog MCP by name (e.g. `hermes mcp install n8n`'
                    'list:List configured MCP servers'
                    'login:Force re-authentication for an OAuth-based MCP server'
                    'picker:Interactive catalog picker (also the default for `hermes mcp'
                    'reauth:Re-authenticate one OAuth MCP server, or all of them (--all)'
                    'remove:Remove an MCP server'
                    'serve:Run Hermes as an MCP server (expose conversations to other a'
                    'test:Test MCP server connection'
                    )
                    _describe 'mcp command' mcp_cmds
                    ;;
                memory)
                    local -a memory_cmds
                    memory_cmds=(
                    'off:Disable external provider (built-in only)'
                    'reset:Erase all built-in memory (MEMORY.md and USER.md)'
                    'setup:Interactive provider selection and configuration'
                    'status:Show current memory provider config'
                    )
                    _describe 'memory command' memory_cmds
                    ;;
                migrate)
                    local -a migrate_cmds
                    migrate_cmds=(
                    'relay:Convert legacy HERMES_NEMO_RELAY_ATIF_*/ATOF_* exporter vars'
                    'xai:Migrate xAI models scheduled for retirement on May 15, 2026'
                    )
                    _describe 'migrate command' migrate_cmds
                    ;;
                moa)
                    local -a moa_cmds
                    moa_cmds=(
                    'configure:Interactively pick MoA models'
                    'delete:Delete a MoA preset'
                    'list:Show current MoA model slots'
                    )
                    _describe 'moa command' moa_cmds
                    ;;
                monitoring)
                    local -a monitoring_cmds
                    monitoring_cmds=(
                    'status:Show monitoring settings, export state, and redaction postur'
                    )
                    _describe 'monitoring command' monitoring_cmds
                    ;;
                pairing)
                    local -a pairing_cmds
                    pairing_cmds=(
                    'approve:Approve a pairing request'
                    'clear-pending:Clear all pending codes'
                    'list:Show pending + approved users'
                    'revoke:Revoke user access'
                    )
                    _describe 'pairing command' pairing_cmds
                    ;;
                peer)
                    local -a peer_cmds
                    peer_cmds=(
                    'add:Register (or update) a peer gateway'
                    'dm:Message an agent on a peer gateway and print its reply'
                    'list:List registered peers'
                    'remove:Remove a peer'
                    'run:Start a long peer turn asynchronously and return its run ID'
                    'status:Read the status and final output of an asynchronous peer run'
                    'stop:Stop one asynchronous peer run without affecting another tur'
                    )
                    _describe 'peer command' peer_cmds
                    ;;
                pets)
                    local -a pets_cmds
                    pets_cmds=(
                    'doctor:Check pet setup + terminal graphics support'
                    'install:Install a pet from the gallery'
                    'list:Browse the petdex gallery'
                    'off:Disable the pet display'
                    'remove:Delete an installed pet'
                    'scale:Resize the pet everywhere (display.pet.scale)'
                    'select:Set the active pet (writes display.pet.*)'
                    'show:Animate the active pet in the terminal'
                    )
                    _describe 'pets command' pets_cmds
                    ;;
                plugins)
                    local -a plugins_cmds
                    plugins_cmds=(
                    'browse:List every curated plugin catalog entry'
                    'capabilities:Show declared vs granted capabilities per plugin'
                    'compat:Show installed plugins that import paths removed by the Sep '
                    'disable:Disable a plugin without removing it'
                    'doctor:Validate a plugin with the real runtime contracts'
                    'enable:Enable a disabled plugin'
                    'install:Install a plugin from the curated catalog, a Git URL, or own'
                    'list:List installed plugins'
                    'pack:Declarative, shareable plugin sets (hermes-pack.yaml)'
                    'remove:Remove an installed plugin'
                    'search:Search the curated Hermes plugin catalog'
                    'show:Show details for a single plugin (including emits/listens)'
                    'update:Pull latest changes for an installed plugin'
                    'validate:Validate a plugin directory for catalog admission (CI gate)'
                    )
                    _describe 'plugins command' plugins_cmds
                    ;;
                portal)
                    local -a portal_cmds
                    portal_cmds=(
                    'info:Show Portal auth + Tool Gateway routing summary'
                    'login:Log in to Nous Portal + set it up (default; one-shot onboard'
                    'open:Open the Portal subscription page in your default browser'
                    'tools:List Tool Gateway tools and which are routed via Nous'
                    )
                    _describe 'portal command' portal_cmds
                    ;;
                profile)
                    case ${line[2]} in
                        use|delete|show|alias|rename|export)
                            _hermes_profiles
                            ;;
                        *)
                            local -a profile_cmds
                            profile_cmds=(
                        'alias:Manage wrapper scripts'
                        'create:Create a new profile'
                        'delete:Delete a profile'
                        'describe:Read or set a profiles description (used by the kanban orche'
                        'export:Export a profile to archive'
                        'import:Import a profile from archive'
                        'info:Show a profiles distribution manifest (version, requirements'
                        'install:Install a profile distribution from a git URL or local direc'
                        'list:List all profiles'
                        'migrate-identity:Retry a renamed profiles session/routing identity migration'
                        'purge-identity:Retry a deleted profiles session/routing identity purge'
                        'rename:Rename a profile (default: sets a display name; id unchanged'
                        'show:Show profile details'
                        'update:Re-pull a distribution and apply updates (user data preserve'
                        'use:Set sticky default profile'
                            )
                            _describe 'profile command' profile_cmds
                            ;;
                    esac
                    ;;
                project)
                    local -a project_cmds
                    project_cmds=(
                    'add-folder:Add a folder to a project'
                    'archive:Archive a project'
                    'bind-board:Bind a kanban board to a project'
                    'create:Create a new project'
                    'list:List projects'
                    'remove-folder:Remove a folder from a project'
                    'rename:Rename a project'
                    'restore:Restore an archived project'
                    'set-primary:Set the primary folder'
                    'show:Show a projects details'
                    'use:Set the active project'
                    )
                    _describe 'project command' project_cmds
                    ;;
                proxy)
                    local -a proxy_cmds
                    proxy_cmds=(
                    'providers:List available proxy upstream providers'
                    'start:Run the proxy in the foreground'
                    'status:Show which proxy upstreams are ready'
                    )
                    _describe 'proxy command' proxy_cmds
                    ;;
                secrets)
                    local -a secrets_cmds
                    secrets_cmds=(
                    'bitwarden:Bitwarden Secrets Manager integration'
                    'onepassword:1Password (op:// references) integration'
                    )
                    _describe 'secrets command' secrets_cmds
                    ;;
                security)
                    local -a security_cmds
                    security_cmds=(
                    'audit:Run a one-shot supply-chain audit'
                    )
                    _describe 'security command' security_cmds
                    ;;
                sessions)
                    local -a sessions_cmds
                    sessions_cmds=(
                    'archive:Bulk-archive (soft-hide) sessions matching filters — no dele'
                    'browse:Interactive session picker — browse, search, and resume sess'
                    'clean-markers:Permanently clear stale tool-call marker content left by ses'
                    'delete:Delete a specific session'
                    'export:Export sessions to JSONL, Markdown, or QMD'
                    'import:Import a Claude Code or Codex CLI session into Hermes'
                    'list:List recent sessions'
                    'optimize:Reclaim disk space: merge FTS5 segments + VACUUM (no data ch'
                    'optimize-storage:Migrate the search index to the compact v23 layout (reclaims'
                    'pin:Pin session(s) — durable keep flag, exempt from auto-archive'
                    'pinned:List pinned sessions'
                    'prune:Delete old sessions (filterable by time window, source, titl'
                    'recover:Rebuild canonical session data into a separate clean databas'
                    'rename:Set or change a sessions title'
                    'repair:Repair a malformed state.db schema so hidden sessions reappe'
                    'repair-routing:Re-stamp gateway sessions that lost their routing identity'
                    'retitle-skills:Re-title sessions whose auto-title came from a /skills own t'
                    'stats:Show session store statistics'
                    'unpin:Remove the pin (durable keep flag) from session(s)'
                    )
                    _describe 'sessions command' sessions_cmds
                    ;;
                skills)
                    local -a skills_cmds
                    skills_cmds=(
                    'audit:Re-scan installed hub skills'
                    'browse:Browse all available skills (paginated)'
                    'check:Check installed hub skills for updates'
                    'config:Interactive skill configuration — enable/disable individual '
                    'diff:Show how your copy of a bundled skill differs from the stock'
                    'inspect:Preview a skill without installing'
                    'install:Install a skill'
                    'list:List installed skills'
                    'list-modified:List bundled skills youve edited (which `hermes update` keep'
                    'opt-in:Re-enable bundled-skill seeding (undo opt-out)'
                    'opt-out:Stop bundled skills from being seeded into this profile'
                    'publish:Publish a skill to a registry'
                    'repair-official:Backfill or restore official optional skills from repo sourc'
                    'reset:Reset a bundled skill — clears user-modified tracking so upd'
                    'search:Search skill registries'
                    'snapshot:Export/import skill configurations'
                    'tap:Manage skill sources'
                    'trust:Trust a project so its repo-local skills (./.hermes/skills, '
                    'uninstall:Remove a hub-installed skill'
                    'untrust:Revoke project-skill trust for a repo'
                    'update:Update installed hub skills'
                    )
                    _describe 'skills command' skills_cmds
                    ;;
                skin)
                    local -a skin_cmds
                    skin_cmds=(
                    'list:List available skins'
                    'set:Set one color of the active skin (e.g. `skin set ui_tool #00'
                    'use:Switch the active skin'
                    )
                    _describe 'skin command' skin_cmds
                    ;;
                slack)
                    local -a slack_cmds
                    slack_cmds=(
                    'manifest:Print or write a Slack app manifest with every gateway comma'
                    )
                    _describe 'slack command' slack_cmds
                    ;;
                sync)
                    local -a sync_cmds
                    sync_cmds=(
                    'device:Show or set this devices label (shown in the sync console)'
                    'disable:Exclude a skill from your sync'
                    'enable:Include a skill in your sync'
                    'now:Reconcile now: pull then push'
                    'propose:Share a skill with your organisation'
                    'pull:Pull your synced skills (and your organisations)'
                    'push:Push your opted-in skills'
                    'status:Show what is synced, and from where'
                    )
                    _describe 'sync command' sync_cmds
                    ;;
                tools)
                    local -a tools_cmds
                    tools_cmds=(
                    'disable:Disable toolsets or MCP tools'
                    'enable:Enable toolsets or MCP tools'
                    'list:Show all tools and their enabled/disabled status'
                    'post-setup:Run a providers post-setup install hook (npm/pip/binary)'
                    )
                    _describe 'tools command' tools_cmds
                    ;;
                vault)
                    local -a vault_cmds
                    vault_cmds=(
                    'add:Save a login, card or address ahead of time (optional: the a'
                    'list:List vault items (metadata only, never values)'
                    'rm:Remove a vault item by handle'
                    'sources:Show detected password managers (1Password, Bitwarden); they'
                    )
                    _describe 'vault command' vault_cmds
                    ;;
                webhook)
                    local -a webhook_cmds
                    webhook_cmds=(
                    'list:List all dynamic subscriptions'
                    'remove:Remove a subscription'
                    'subscribe:Create a webhook subscription'
                    'test:Send a test POST to a webhook route'
                    )
                    _describe 'webhook command' webhook_cmds
                    ;;
                worktree)
                    local -a worktree_cmds
                    worktree_cmds=(
                    'list:Classify every tree: age, size, verdict, reason (default act'
                    'prune:Remove safe trees and delete fully-merged local branches'
                    )
                    _describe 'worktree command' worktree_cmds
                    ;;
            esac
            ;;
    esac
}

compdef _hermes hermes

