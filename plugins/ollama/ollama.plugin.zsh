# ------------------------------------------------------------------------------
# ollama.plugin.zsh
#
# Plugin providing Zsh completions for the `ollama` command.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Function: _ollama_get_models
# Purpose:  Retrieves the list of available models for completion.
#           Uses `ollama list` with a short timeout and provides candidates.
# ------------------------------------------------------------------------------
_ollama_get_models() {
  local models_output
  local timeout=5  # Timeout duration in seconds

  # Attempt to fetch models via `ollama list`; if it fails, show a short message.
  models_output="$(timeout $timeout ollama list 2>/dev/null)" || {
    _message "Failed to fetch models"
    return 1
  }

  # Accumulate parsed model names here
  local -a models
  local line
  while IFS= read -r line; do
    # Skip blank lines and header lines (starting with NAME)
    [[ -z "$line" || "$line" =~ ^NAME ]] && continue

    # Extract the first column and escape any colons for safety
    local suggestion="${line%% *}"
    suggestion="${suggestion/:/\\:}"
    models+=("$suggestion")
  done <<< "$models_output"

  # Provide model suggestions using `_describe`
  _describe -t models 'models' models
}

# ------------------------------------------------------------------------------
# Function: _ollama
# Purpose:  The main completion function for the `ollama` CLI. Determines which
#           subcommand is being completed, then sets up the corresponding flags
#           and suggestions.
# ------------------------------------------------------------------------------
_ollama() {
  # List of top-level commands and their descriptions
  local -a commands=(
    'serve:Start the Ollama server'
    'create:Create a model from a Modelfile'
    'show:Display information about a specific model'
    'run:Execute a model with a given prompt'
    'stop:Terminate a running model'
    'pull:Download a model from the registry'
    'push:Upload a model to the registry'
    'list:Display all available models'
    'ps:Show currently running models'
    'cp:Duplicate an existing model'
    'rm:Delete a model from the local system'
    'help:Provide help information for a command'
  )

  # Standard local variables used by _arguments
  local curcontext="$curcontext" state line
  local -A opt_args

  # The main `_arguments` call for handling top-level options (e.g. -h, -v)
  # and capturing the first positional argument -> subcommand, then the rest.
  _arguments -C \
    '(-h --help)'{-h,--help}'[Display help information]' \
    '(-v --version)'{-v,--version}'[Show version information]' \
    '1: :->command' \
    '*:: :->args'

  # If the user is trying to complete the first argument (the subcommand),
  # then we present them the `commands` array above.
  case $state in
    command)
      _describe -t commands 'ollama commands' commands
      return
      ;;
  esac

  # If the first argument is known, proceed with subcommand-specific completions
  case $words[1] in
    serve)
      _arguments \
        '(-p --port)'{-p,--port}'[Specify the port number]:port number:'
      ;;

    create)
      # If user typed only `ollama create ` (with no second arg),
      # display a short message to remind them to name the new model
      if [[ $CURRENT -eq 2 ]]; then
        _message 'Specify the new model name'
      else
        # Otherwise, offer flags for `create`
        _arguments \
          '(-f --filename)'{-f,--filename}'[Path to the Modelfile]:Modelfile:_files' \
          '(-q --quantize)'{-q,--quantize}'[Quantization method (e.g. q4_0)]' \
          '--prefix[Set a prefix for the created model]' \
          '(-h --help)--help[Show help for create]'
      fi
      ;;

    show)
      _message 'Usage: ollama show MODEL [flags]'
      if [[ $CURRENT -eq 2 ]]; then
        _ollama_get_models
      else
        _arguments \
          '--license[Show the model’s license]' \
          '--modelfile[Show the model’s Modelfile]' \
          '--parameters[Show model parameters]' \
          '--system[Show the system message of the model]' \
          '--template[Show the model’s template]' \
          '(-h --help)--help[Show help for show]'
      fi
      ;;

    run)
      # Display usage message only if there's no argument yet
      if [[ $CURRENT -eq 2 ]]; then
        _message "Usage: ollama run MODEL [PROMPT] [flags]"
        _ollama_get_models
      else
        # Define flags for the `run` command
        local -a _run_flags=(
          '--format-string=[Format string for the output (e.g. json)]'
          '--insecure[Use an insecure registry]'
          '--keepalive=[Time to keep the model loaded (e.g. 5m)]'
          '--nowordwrap[Disable word wrapping]'
          '--verbose[Show response timings]'
          '(-h --help)--help[Show help for run]'
        )

        # Use a mix of `_arguments` and manual handling for freeform input
        if [[ $CURRENT -eq 3 ]]; then
          # Suggest a freeform prompt (arbitrary input)
          _message "Enter a prompt as a string"
        else
          # Provide flag completions
          _arguments -S "${_run_flags[@]}"
        fi
      fi
      ;;

    cp)
      # The `cp` command expects `ollama cp SOURCE DEST`
      if [[ $CURRENT -eq 2 ]]; then
        _ollama_get_models
      elif [[ $CURRENT -eq 3 ]]; then
        _message 'Specify the destination model name'
      fi
      ;;

    rm|stop|pull|push)
      # All of these commands accept one or more model names
      if [[ $CURRENT -eq 2 ]]; then
        _ollama_get_models
      fi
      ;;

    # If the subcommand doesn’t match anything above, fall back to default
    *)
      _default
      ;;
  esac
}

# Finally, register the completion function for the `ollama` command
compdef _ollama ollama
