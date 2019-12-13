function setup_using_base_dir() {
    # Declare all variables local not no mess with outside env in any way
    local fzf_base
    local fzf_shell
    local fzfdirs
    local dir

    test -d "${FZF_BASE}" && fzf_base="${FZF_BASE}"

    if [[ -z "${fzf_base}" ]]; then
        fzfdirs=(
          "${HOME}/.fzf"
          "/usr/local/opt/fzf"
          "/usr/share/fzf"
          "/usr/local/share/examples/fzf"
        )
        for dir in ${fzfdirs}; do
            if [[ -d "${dir}" ]]; then
                fzf_base="${dir}"
                break
            fi
        done

        if [[ -z "${fzf_base}" ]]; then
            if (( ${+commands[brew]} )) && dir="$(brew --prefix fzf 2>/dev/null)"; then
                if [[ -d "${dir}" ]]; then
                    fzf_base="${dir}"
                fi
            fi
        fi
    fi

    if [[ -d "${fzf_base}" ]]; then
        # Fix fzf shell directory for Archlinux package
        if [[ ! -d "${fzf_base}/shell" ]] && [[ -f /etc/arch-release ]]; then
          fzf_shell="${fzf_base}"
        else
          fzf_shell="${fzf_base}/shell"
        fi

        # Setup fzf binary path
        if ! (( ${+commands[fzf]} )) && [[ ! "$PATH" == *$fzf_base/bin* ]]; then
          export PATH="$PATH:$fzf_base/bin"
        fi

        # Auto-completion
        if [[ ! "$DISABLE_FZF_AUTO_COMPLETION" == "true" ]]; then
          [[ $- == *i* ]] && source "${fzf_shell}/completion.zsh" 2> /dev/null
        fi

        # Key bindings
        if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
          source "${fzf_shell}/key-bindings.zsh"
        fi
    else
        return 1
    fi
}


function setup_using_debian_package() {
    (( $+commands[dpkg] )) && dpkg -s fzf &> /dev/null
    if (( $? )); then
        # Either not a debian based distro, or no fzf installed. In any case skip ahead
        return 1
    fi

    # NOTE: There is no need to configure PATH for debian package, all binaries
    # are installed to /usr/bin by default

    # Determine completion file path: first bullseye/sid, then buster/stretch
    local completions="/usr/share/doc/fzf/examples/completion.zsh"
    [[ -f "$completions" ]] || completions="/usr/share/zsh/vendor-completions/_fzf"

    local key_bindings="/usr/share/doc/fzf/examples/key-bindings.zsh"

    # Auto-completion
    if [[ $- == *i* ]] && [[ ! "$DISABLE_FZF_AUTO_COMPLETION" == "true" ]]; then
         source $completions 2> /dev/null
    fi

    # Key bindings
    if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
        source $key_bindings
    fi

    return 0
}

function indicate_error() {
    print "[oh-my-zsh] fzf plugin: Cannot find fzf installation directory.\n"\
          "Please add \`export FZF_BASE=/path/to/fzf/install/dir\` to your .zshrc" >&2
}

# Check for debian package first, because it easy to short cut
# Indicate to user that fzf installation not found if nothing worked
setup_using_debian_package || setup_using_base_dir || indicate_error

unset -f setup_using_debian_package setup_using_base_dir indicate_error
