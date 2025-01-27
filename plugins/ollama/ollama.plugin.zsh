# Function to retrieve available models for completion
_ollama_get_models() {
  # Execute 'ollama list' and capture its output, suppressing any error messages
  local models_output
  models_output="$(ollama list 2>/dev/null)"

  # Initialize an array to hold the model suggestions
  local -a models
  local line

  # Read the output line by line
  while IFS=" " read -r line; do
    # Skip blank lines
    [[ -z "$line" ]] && continue

    # Skip the header line that starts with 'NAME'
    if [[ "$line" =~ ^NAME ]]; then
      continue
    fi

    # Split the line into words and extract the first word (model name:tag)
    set -- $line
    local suggestion="${$(echo $1 | cut -d ' ' -f 1)/:/\\:}"  # Escape ':' by replacing it with '\:'
    models+=( "$suggestion" )  # Add the escaped model name to the array
  done <<< "$models_output"

  # Use the '_describe' function to provide the model suggestions for completion
  _describe -t models 'models' models
}

# Main completion function for the 'ollama' command
_ollama() {
  # Define an array of available commands with their descriptions
  local -a commands
  commands=(
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

  # Initialize context variables for the completion
  local context curcontext="$curcontext" state line
  local -A opt_args

  # Define the arguments and options for the 'ollama' command
  _arguments -C \
    '(-h --help)'{-h,--help}'[Display help information]' \
    '(-v --version)'{-v,--version}'[Show version information]' \
    '1: :->command' \
    '*:: :->args'

  # Determine the state of the completion (command or arguments)
  case $state in
    command)
      # Provide command suggestions
      _describe -t commands 'ollama commands' commands
      ;;
    args)
      # Handle argument completion based on the specified command
      case $words[1] in
        run|rm|stop|show|pull|push)
          # For these commands, provide model name suggestions
          _ollama_get_models
          ;;
        cp)
          if [[ $CURRENT -eq 2 ]]; then
            # For the 'cp' command, suggest source model names
            _ollama_get_models
          elif [[ $CURRENT -eq 3 ]]; then
            # For the 'cp' command, prompt for the destination model name
            _message 'destination model name'
          fi
          ;;
        create)
          # For the 'create' command, suggest Modelfile paths
          _arguments \
            '(-f --filename)'{-f,--filename}'[Specify the path to the Modelfile]:Modelfile:_files'
          ;;
        serve)
          # For the 'serve' command, suggest specifying the port number
          _arguments \
            '(-p --port)'{-p,--port}'[Specify the port number]:port number:'
          ;;
        *)
          # For any other commands, use the default completion
          _default
          ;;
      esac
      ;;
  esac
}

# Register the '_ollama' function as the completion handler for the 'ollama' command
compdef _ollama ollama

# Register aliases
alias o=ollama
