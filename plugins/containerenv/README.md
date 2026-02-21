# containerenv plugin

A lightweight plugin that provides convenient functions to access container environment variables from `/run/.containerenv`. Useful in containerized environments (Podman, Docker, Toolbox, etc.).

To use it, add `containerenv` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... containerenv)
```

## Usage

### Accessor functions

Each function reads one key from `/run/.containerenv` and prints its value to stdout. On error (not in a container or missing key), a message is printed to stderr and the function returns 1.

| Function | Key | Description |
|----------|-----|-------------|
| `containerenv_engine` | `engine` | Container runtime (e.g. `podman`, `docker`) |
| `containerenv_name` | `name` | Container name |
| `containerenv_id` | `id` | Container ID |
| `containerenv_image` | `image` | Image name/reference |
| `containerenv_imageid` | `imageid` | Image ID |
| `containerenv_rootless` | `rootless` | Whether the container is rootless |
| `containerenv_graphrootmounted` | `graphRootMounted` | Whether the graph root is mounted |

**Examples:**

```bash
# Show container name
containerenv_name

# Use in a conditional or variable
if name=$(containerenv_name 2>/dev/null); then
  echo "Container: $name"
fi
```

### Show all container env vars

```bash
containerenv_all
```

Prints the full contents of `/run/.containerenv`. Exits with 1 if not in a container.

### Check if running in a container

```bash
is_containerized
```

Returns 0 if `/run/.containerenv` exists, 1 otherwise. Useful in scripts:

```bash
if is_containerized; then
  echo "Inside container: $(containerenv_name 2>/dev/null)"
fi
```

### Prompt integration

Use `containerenv_prompt_info` in your theme to show container info in the prompt (e.g. `📦 container-name`). If not in a container, it prints nothing.

In a custom theme or in `PROMPT`/`RPROMPT`:

```bash
# Example: add to RPROMPT
RPROMPT='$(containerenv_prompt_info)'
```

---

## About `/run/.containerenv`

Podman (and compatible runtimes) write a file at `/run/.containerenv` inside the container with key=value pairs such as `engine`, `name`, `id`, `image`, `imageid`, `rootless`, and `graphRootMounted`. This plugin reads that file; outside a container or if the file is missing, the accessors report an error.
