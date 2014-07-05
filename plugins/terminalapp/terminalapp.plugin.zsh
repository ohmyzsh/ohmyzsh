# Set Apple Terminal.app resume directory
# based on this answer: http://superuser.com/a/315029
# 2012-10-26: (javageek) Changed code using the updated answer

# Run only on OS X < 10.9 because the whole functionality has been replaced by Mavericks natively.
# https://github.com/robbyrussell/oh-my-zsh/issues/2416
if [[ "$(uname)" == "Darwin" ]] && [[ "$(uname -r | cut -d . -f 1)" -lt 13 ]]; then

    # Tell the terminal about the working directory whenever it changes.
    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
      update_terminal_cwd() {
            # Identify the directory using a "file:" scheme URL, including
            # the host name to disambiguate local vs. remote paths.

            # Percent-encode the pathname.
            local URL_PATH=''
            {
                # Use LANG=C to process text byte-by-byte.
                local i ch hexch LANG=C
                for ((i = 1; i <= ${#PWD}; ++i)); do
                    ch="$PWD[i]"
                    if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                        URL_PATH+="$ch"
                    else
                        hexch=$(printf "%02X" "'$ch")
                        URL_PATH+="%$hexch"
                    fi
                done
            }

            local PWD_URL="file://$HOST$URL_PATH"
            #echo "$PWD_URL"        # testing
            printf '\e]7;%s\a' "$PWD_URL"
        }

        # Register the function so it is called whenever the working
        # directory changes.
        autoload add-zsh-hook
        add-zsh-hook precmd update_terminal_cwd

        # Tell the terminal about the initial directory.
        update_terminal_cwd
    fi

fi

