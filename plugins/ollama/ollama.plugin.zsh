#compdef ollama

# Acknowledgements: Grégoire Compagnon (https://github.com/obeone)
# © 2025 https://gist.github.com/obeone/9313811fd61a7cbb843e0001a4434c58
# Adopted for ohmyzsh by Konstantni Gredeskoul (https://kig.re)

# Purpose:
# This script file `_ollama` should be placed in your fpath to provide zsh completions functionality for ollama commands.
# It utilizes zsh's native completion system by defining specific completion behaviors tailored to ollama commands.

# Installation:
# 1. Check your current fpath by executing: `echo $fpath` in your zsh shell.
# 2. To introduce a new directory to fpath, edit your .zshrc file:
#    Example: `fpath=($HOME/.zsh-completions $fpath)`
# 3. Store this script file in the directory you have added to your fpath.
# 4. For a system-wide installation on Linux:
#    Download and deploy this script with the following command:
#    sudo wget -O /usr/share/zsh/site-functions/_ollama https://gist.githubusercontent.com/obeone/9313811fd61a7cbb843e0001a4434c58/raw/_ollama.zsh

# Contributions:
# Principal contributions by:
# - ChatGPT [ZSH Expert](https://chatgpt.com/g/g-XczdbjXSW-zsh-expert) as the primary creator.
# - Guidance and revisions by [obeone](https://github.com/obeone).

# Note:
# - This configuration file presupposes the utilization of Zsh as your primary shell environment.
# - It is crucial to restart your zsh session subsequent to alterations made to your fpath to ensure the updates are effectively recognized.

# Function to fetch and return model names from 'ollama list'
_fetch_ollama_models() {
    local -a models
    local output="$(ollama list 2>/dev/null | sed 's/:/\\:/g')"  # Escape semicolons for zsh
    if [[ -z "$output" ]]; then
        _message "no models available or 'ollama list' failed"
        return 1
    fi
    models=("${(@f)$(echo "$output" | awk 'NR>1 {print $1}')}")
    if [[ ${#models} -eq 0 ]]; then
        _message "no models found"
        return 1
    fi
    _describe 'model names' models
}

# Main completion function
_ollama() {
    local -a commands

    _arguments -C \
        '1: :->command' \
        '*:: :->args'

    case $state in
        command)
            commands=(
                'serve:Start ollama'
                'create:Create a model from a Modelfile'
                'show:Show information for a model'
                'run:Run a model'
                'pull:Pull a model from a registry'
                'push:Push a model to a registry'
                'list:List models'
                'cp:Copy a model'
                'rm:Remove a model'
                'help:Help about any command'
            )
            _describe -t commands 'ollama command' commands
        ;;
        args)
            case $words[1] in
                serve)
                    _arguments \
                        '--host[Specify the host and port]:host and port:' \
                        '--origins[Set allowed origins]:origins:' \
                        '--models[Path to the models directory]:path:_directories' \
                        '--keep-alive[Duration to keep models in memory]:duration:'
                ;;
                create)
                    _arguments \
                        '-f+[Specify the file name]:file:_files'
                ;;
                show)
                    _arguments \
                        '--license[Show license of a model]' \
                        '--modelfile[Show Modelfile of a model]' \
                        '--parameters[Show parameters of a model]' \
                        '--system[Show system message of a model]' \
                        '--template[Show template of a model]' \
                        '*::model:->model'
                    if [[ $state == model ]]; then
                        _fetch_ollama_models
                    fi
                ;;
                run)
                    _arguments \
                        '--format[Specify the response format]:format:' \
                        '--insecure[Use an insecure registry]' \
                        '--nowordwrap[Disable word wrap]' \
                        '--verbose[Show verbose output]' \
                        '*::model and prompt:->model_and_prompt'
                    if [[ $state == model_and_prompt ]]; then
                        _fetch_ollama_models
                        _message "enter prompt"
                    fi
                ;;
                pull|push)
                    _arguments \
                        '--insecure[Use an insecure registry]' \
                        '*::model:->model'
                    if [[ $state == model ]]; then
                        _fetch_ollama_models
                    fi
                ;;
                list)
                    _message "no additional arguments for list"
                ;;
                cp)
                    _arguments \
                        '1:source model:_fetch_ollama_models' \
                        '2:target model:_fetch_ollama_models'
                ;;
                rm)
                    _arguments \
                        '*::models:->models'
                    if [[ $state == models ]]; then
                        _fetch_ollama_models
                    fi
                ;;
                help)
                    _message "no additional arguments for help"
                ;;
            esac
        ;;
    esac
}

mydir=${0:a:h}
fpath=(${mydir} $fpath)
