# Ollama Plugin for Oh-My-Zsh

This plugin enhances your Zsh shell environment by integrating powerful features for managing, running, and creating large language models locally using the [Ollama CLI](https://ollama.ai/). The plugin provides streamlined workflows, autocompletion, and man page support, making it easier than ever to interact with your local AI models.

## Features

- **Command Autocompletion**: Full support for Ollama CLI commands, options, and arguments.
- **Dynamic Model Suggestions**: Automatically suggests available models based on the output of `ollama list`.

## Installation

### Prerequisites

- A working installation of [Oh-My-Zsh](https://ohmyz.sh/).
- The Ollama CLI installed on your system. Refer to the [official Ollama documentation](https://github.com/ollama/ollama) for setup instructions.

### Steps

1. **Enable the Plugin**
   Add `ollama` to the `plugins` array in your `.zshrc` file:

   ```sh
   # in your ~/.zshrc file
   plugins=(... ollama)
   ```

   or

   ```sh
   # from shell
   omz plugin enable ollama
   ```

   In order to get the most benefit from completions, with helpful usage hints, etc:
   ```sh
   # ~/.zshrc
   # add the following zstyle entry wherever you want
   zstyle ':completion:*:*:*:*:descriptions' format '%F{green}%d%f'
   ```


2. **Restart Your Shell**
   Apply the changes by reloading Oh-My-Zsh:

   ```sh
   omz reload
   ```

## Usage

### Commands

The plugin provides autocompletion and enhanced functionality for the following Ollama commands:

| Command     | Description                              |
|-------------|------------------------------------------|
| `serve`, `start`| Start the Ollama server locally.         |
| `create`    | Create a model from a Modelfile.         |
| `show`      | Display information about a specific model. |
| `run`       | Execute a model with a given prompt.     |
| `stop`      | Terminate a running model.               |
| `pull`      | Download a model from a registry.        |
| `push`      | Upload a model to a registry.            |
| `list`, `ls` | List all available models.               |
| `ps`        | Show currently running models.           |
| `cp`        | Duplicate an existing model locally.     |
| `rm`        | Remove a model from the local system.    |
| `help [command]` | Provide help information for a command.  |

```sh
>>> o ls
NAME                                 ID              SIZE      MODIFIED
deepseek-r1:14b-qwen-distill-q8_0    022efe288297    15 GB     3 hours ago
deepseek-r1:32b                      38056bbcbb2d    19 GB     3 days ago
deepseek-r1:8b                       28f8fd6cdc67    4.9 GB    3 days ago
deepseek-r1:70b                      0c1615a8ca32    42 GB     3 days ago
```

## Notes

- **Model Naming**: Models follow a `model:tag` format. If no tag is provided, Ollama defaults to `latest`. The model can be invoked with or without `latest` (e.g. `ollama run llama3.2` is equivalent to `ollama run llama3.2:latest`)
- **Multiline Input**: Use triple quotes (`"""`) for multiline prompts:

  ```zsh
  > """What is the impact of AI on society?
  ... Include specific examples."""
  ```

## License

This project is licensed under the MIT License.

For more details, visit the [Ollama CLI GitHub repository](https://github.com/ollama/ollama).

Currently maintained by [sealad886](https://github.com/sealad886)
