# zsh-sessions plugin

This plugin organizes daily terminal sessions into **persistent, resumable conversation threads** (`zs`). It records executed commands, command outputs (`stdout`/`stderr`), and unified diffs (`diff -u`) of edited files (such as `.yml`, `.json`, or `.conf`), while automatically redacting secrets (`[REDACTED]`) and discarding trivial noise sessions.

To use it, add `zsh-sessions` to the plugins array in your `~/.zshrc` file:

```zsh
plugins=(... zsh-sessions)
```

> **Optional dependency:** Install [`fzf`](https://github.com/junegunn/fzf) (`brew install fzf` or `apt install fzf`) to enable the split-screen terminal interface with live conversation preview. When `fzf` is not installed, `zs` automatically falls back to a built-in numbered interactive menu.

## Usage

Every interactive shell session automatically receives a chronological **UUIDv7** identifier. As you work, `zsh-sessions` records:

1. **Command metadata:** Timestamp, working directory (`PWD`), Git branch, duration, and exit status.
2. **Command output (`stdout`/`stderr`):** Captures CLI output (truncated to `ZS_MAX_OUTPUT_LINES`) while automatically bypassing interactive full-screen TUI applications (`vim`, `nvim`, `nano`, `less`, `htop`, `ssh`, `tmux`, `fzf`).
3. **Edited file diffs (`Snapshot & Diff`):** When a command or editor modifies a configuration/source file (e.g., `vim docker-compose.yml`), records a clean `diff -u` block showing added (`+`) and removed (`-`) lines.
4. **Zero-Junk Filtering:** Sessions containing only trivial navigation commands (`ls`, `cd`, `pwd`, `clear`, `exit`) with no file modifications are automatically discarded on exit.
5. **Category Prompt on Exit:** When closing a meaningful session via `exit` that has not yet been categorized, `zs` prompts you to assign it to an existing category or create a new one on the spot. If the terminal window is closed abruptly (`SIGHUP` / <kbd>Cmd</kbd> + <kbd>W</kbd>), the session is preserved as `[Sem Categoria]` and a one-line notice is shown on the next shell startup.

## Commands

| Command | Description |
| :--- | :--- |
| `zs` | Open the interactive session threads TUI (`fzf` split view or numbered menu) |
| `zs status` | Display current session metadata (UUIDv7, project, category, command count) |
| `zs show [id]` | Display the full colorized timeline (commands, outputs, and file diffs) of a session |
| `zs resume <id>` | Resume a previous session (`cd` into its last directory and continue appending to that thread) |
| `zs rename "<title>" [id]` | Set a custom title for the current or specified session |
| `zs cat` | Interactively assign the session to an existing category or create a new one |
| `zs cat add "<name>"` | Create a new category |
| `zs cat list` | List all categories and the number of sessions in each |
| `zs cat set "<cat>" [id]` | Assign a category to the current or specified session |
| `zs ai [id]` | Auto-categorize and title a session (uses `GEMINI_API_KEY` if set, or local heuristics) |
| `zs rm <id>` | Delete a saved session |
| `zs -h`, `zs --help`, `zs help` | Display complete help guide with all commands, shortcuts, and practical examples |

## Keyboard Shortcuts (inside `zs` / `fzf`)

All shortcuts use portable POSIX/ASCII control codes that work identically across macOS, Linux, WSL, and SSH:

| Shortcut | Description |
| :--- | :--- |
| <kbd>Enter</kbd> | Resume the selected session (`cd` + continue thread) |
| <kbd>Tab</kbd> | Open the arrow-navigable **Action Menu** (`View`, `Resume`, `Category`, `Rename`, `AI`, `Delete`) |
| <kbd>Ctrl</kbd> + <kbd>T</kbd> | Assign or create a Category for the selected session |
| <kbd>Ctrl</kbd> + <kbd>R</kbd> | Rename the selected session |
| <kbd>Ctrl</kbd> + <kbd>F</kbd> | Cycle session filters (`ALL` → `Current Project` → `By Category`) |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> | Auto-categorize and title session (`AI` / heuristics) |
| <kbd>Ctrl</kbd> + <kbd>X</kbd> | Delete the selected session |
| <kbd>Ctrl</kbd> + <kbd>U</kbd> / <kbd>Ctrl</kbd> + <kbd>D</kbd> | Scroll the right-hand conversation preview up / down |

## Examples

### 1. Daily Workflow Examples

```zsh
# Example 1: Open the interactive split-view TUI to browse, search, or resume sessions
zs

# Example 2: Create your custom work categories
zs cat add "Networks & Routers"
zs cat add "DevOps & Docker"
zs cat add "Backups"

# Example 3: List all categories and check session counts
zs cat list

# Example 4: Categorize your current active session interactively or directly
zs cat
zs cat set "Networks & Routers"

# Example 5: Set a clear, memorable title for the current session
zs rename "Backup S6730 switches and M4 router"

# Example 6: Inspect current session metadata or view the full conversation & file diffs
zs status
zs show

# Example 7: Auto-categorize and title the current session using AI / heuristics
zs ai

# Example 8: Run a sensitive command WITHOUT recording it (prefix with a leading space)
 export SECRET_TOKEN="my-private-token"
```

### 2. Sample Output: `zs show` (Commands, Output & File Diffs with Secret Redaction)

```text
➜  ~ echo "services:\n  redis:\n    port: 6379" > /tmp/teste.yml
➜  ~ sed -i '' 's/6379/6380/' /tmp/teste.yml && echo "  password: my_super_secret_password" >> /tmp/teste.yml
➜  ~ zs show
======================================================================
ID: 01a17b3d-2e19-7066-8611-74346f108cb4 | Data: 2026-10-26 23:43 | Categoria: [DevOps & Docker] | Projeto: ruy | Cmds: 2
Título: Backup S6730 switches and M4 router
Última pasta: /Users/ruy
======================================================================
[23:42:54] ~ $ echo "services:\n  redis:\n    port: 6379" > /tmp/teste.yml (exit: 0 | 0s)

[23:43:02] ~ $ sed -i '' 's/6379/6380/' /tmp/teste.yml && echo "  password: [REDACTED] >> /tmp/teste.yml (exit: 0 | 0s)
  📝 Diff em /tmp/teste.yml:
    --- a/tmp/teste.yml
    +++ b/tmp/teste.yml
    @@ -1,3 +1,4 @@
     services:
       redis:
    -    port: 6379
    +    port: 6380
    +  password: [REDACTED]
```

### 3. Built-in Help Guide (`zs -h` / `zs --help`)

Run `zs -h` (or `zs --help` / `zs help`) at any time to display the complete reference guide directly in the terminal:

<details>
<summary>View full <code>zs -h</code> output</summary>

```text
================================================================================
💬 zs (zsh-sessions) — Gerenciador de Sessões/Conversas de Terminal (Oh My Zsh)
================================================================================

USO:
  zs [comando] [argumentos]
  zs -h | --help | help

--------------------------------------------------------------------------------
1. COMANDOS PRINCIPAIS
--------------------------------------------------------------------------------
  zs                         Abre o painel interativo (tela dividida com fzf)
  zs -h, zs --help, zs help  Exibe este guia completo com todos os exemplos
  zs status                  Mostra os dados da sessão atual (UUIDv7, pasta,
                             categoria, título, quantidade de comandos e diffs)
  zs show [session_id]       Exibe a conversa completa (comandos, saídas e diffs
                             coloridos) da sessão atual ou do ID informado
  zs resume <session_id>     Retoma uma sessão anterior (faz 'cd' para a última
                             pasta da sessão e continua gravando na mesma thread)
  zs rename "<título>" [id]  Altera o título da sessão atual (ou do ID informado)
  zs rm <session_id>         Remove permanentemente uma sessão salva

--------------------------------------------------------------------------------
2. GESTÃO DE CATEGORIAS (100% Manual ou com IA)
--------------------------------------------------------------------------------
  zs cat                     Abre o menu interativo para classificar a sessão
                             atual em uma categoria existente ou criar uma nova
  zs cat add "<nome>"        Cria uma nova categoria (ex.: DevOps, Rede, Bugfix)
  zs cat list                Lista todas as categorias e quantas sessões há nelas
  zs cat set "<cat>" [id]    Atribui diretamente uma categoria à sessão atual
                             (ou à sessão do ID informado)
  zs ai [session_id]         Classifica e gera título automaticamente usando IA
                             (se GEMINI_API_KEY estiver definida) ou heurística

--------------------------------------------------------------------------------
3. ATALHOS DENTRO DO PAINEL INTERATIVO (fzf)
--------------------------------------------------------------------------------
  Enter       Retoma a sessão selecionada (entra na pasta e continua a conversa)
  Tab         Abre o Menu de Ações (Ver, Retomar, Categoria, Renomear, IA, Excluir)
  Ctrl + T    Mudar ou criar uma Categoria para a sessão selecionada
  Ctrl + R    Renomear o título da sessão selecionada
  Ctrl + F    Alternar filtro (Todas -> Projeto Atual -> Filtrar por Categoria)
  Ctrl + A    Classificar automaticamente com IA / Heurística
  Ctrl + X    Excluir a sessão selecionada
  Ctrl + U/D  Rolar a conversa (painel da direita) para cima / para baixo
  Esc / ^C    Sair do painel sem fazer alterações

--------------------------------------------------------------------------------
4. EXEMPLOS PRÁTICOS DO DIA A DIA
--------------------------------------------------------------------------------
  # Exemplo 1: Abrir o painel visual para procurar e retomar uma sessão antiga
  zs

  # Exemplo 2: Criar suas categorias de trabalho habituais
  zs cat add "Rede & Roteadores"
  zs cat add "DevOps & Docker"
  zs cat add "Backups"

  # Exemplo 3: Listar todas as suas categorias e ver sessões pendentes
  zs cat list

  # Exemplo 4: Classificar a sessão que você está usando agora
  zs cat
  # (ou diretamente):
  zs cat set "Rede & Roteadores"

  # Exemplo 5: Dar um nome fácil de lembrar para a sessão atual
  zs rename "Backup dos switches S6730 e roteador M4"

  # Exemplo 6: Ver todo o histórico (comandos, saídas e diffs .yml) da aba atual
  zs show

  # Exemplo 7: Pedir para a IA categorizar e dar título para a sessão atual
  zs ai

  # Exemplo 8: Executar um comando sensível SEM gravar na sessão (espaço antes)
   export MINHA_SENHA="123"   # (com um espaço em branco no início da linha)

--------------------------------------------------------------------------------
5. VARIÁVEIS DE CONFIGURAÇÃO (no seu ~/.zshrc)
--------------------------------------------------------------------------------
  export ZS_CAPTURE_OUTPUT=1        # 1 = grava saídas stdout/stderr; 0 = só comandos e diffs
  export ZS_MAX_OUTPUT_LINES=60     # Máximo de linhas de saída salvas por comando
  export ZS_MIN_MEANINGFUL_CMDS=2   # Mínimo de comandos relevantes (Regra Zero Lixo)
  export ZS_BINDKEY="^G"            # Atalho opcional (ex: Ctrl+G) para abrir o 'zs'
================================================================================
```

</details>

## Security & Privacy

* **Strict File Permissions:** Session storage is created with `0700` directory permissions and `0600` file permissions.
* **Sensitive File Blocklist:** Files matching `.env*`, `*.pem`, `*.key`, `id_rsa*`, `id_ed25519*`, `*credentials*`, `.netrc`, `.npmrc`, or `.pypirc` never have their contents or diffs recorded.
* **Automatic Secret Redaction:** Values assigned to keys matching `password`, `passwd`, `pwd`, `secret`, `token`, `api_key`, `access_key`, `private_key`, `auth`, `bearer`, `database_url`, CLI flags (`--requirepass`, `--password`, `--token`), URL credentials, and token prefixes (`ghp_`, `gho_`, `github_pat_`, `sk-`, `AKIA`, `AIza`, JWTs) are masked with `[REDACTED]` before touching disk.
* **`HIST_IGNORE_SPACE` Compliance:** Commands prefixed with a leading space are ignored.

## Configuration

You can customize the plugin behavior by setting these variables in your `~/.zshrc` before Oh My Zsh loads:

* `ZS_DATA_DIR`: Directory where session indexes and logs are stored (default: `${XDG_DATA_HOME:-$HOME/.local/share}/zsh-sessions`).
* `ZS_CAPTURE_OUTPUT`: Set to `0` to disable `stdout`/`stderr` capture while keeping command and file diff tracking (default: `1`).
* `ZS_MAX_OUTPUT_LINES`: Maximum number of output lines stored per command before truncating the middle section (default: `60`).
* `ZS_MIN_MEANINGFUL_CMDS`: Minimum number of non-trivial commands required to persist a session without diffs or manual metadata (default: `2`).
* `ZS_BINDKEY`: Optional ZLE keyboard shortcut to launch `zs` directly from the prompt (e.g., `export ZS_BINDKEY="^G"`).
* `GEMINI_API_KEY`: Optional Google Gemini API key used by `zs ai` to generate smart session titles and categories from sanitized command summaries.
