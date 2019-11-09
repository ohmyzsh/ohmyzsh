# This plugin loads rbenv into the current shell and provides prompt info via
# the 'rbenv_prompt_info' function.

FOUND_RBENV=$+commands[rbenv]

if [[ $FOUND_RBENV -ne 1 ]]; then
    rbenvdirs=("$HOME/.rbenv" "/usr/local/rbenv" "/opt/rbenv" "/usr/local/opt/rbenv")
    for dir in $rbenvdirs; do
        if [[ -d $dir/bin ]]; then
            export PATH="$dir/bin:$PATH"
            FOUND_RBENV=1
            break
        fi
    done
fi

if [[ $FOUND_RBENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix rbenv 2>/dev/null); then
        if [[ -d $dir/bin ]]; then
            export PATH="$dir/bin:$PATH"
            FOUND_RBENV=1
        fi
    fi
fi

if [[ $FOUND_RBENV -eq 1 ]]; then
    eval "$(rbenv init --no-rehash - zsh)"

    alias rubies="rbenv versions"
    alias gemsets="rbenv gemset list"

    function current_ruby() {
        echo "$(rbenv version-name)"
    }

    function current_gemset() {
        echo "$(rbenv gemset active 2&>/dev/null | sed -e ":a" -e '$ s/\n/+/gp;N;b a' | head -n1)"
    }

    function gems() {
        local rbenv_path=$(rbenv prefix)
        gem list $@ | sed -E \
          -e "s/\([0-9a-z, \.]+( .+)?\)/$fg[blue]&$reset_color/g" \
          -e "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
          -e "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
          -e "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
    }

    function rbenv_prompt_info() {
        if [[ -n $(current_gemset) ]] ; then
            echo "$(current_ruby)@$(current_gemset)"
        else
            echo "$(current_ruby)"
        fi
    }
else
    alias rubies="ruby -v"
    function gemsets() { echo "not supported" }
    function current_ruby() { echo "not supported" }
    function current_gemset() { echo "not supported" }
    function gems() { echo "not supported" }
    function rbenv_prompt_info() { echo "system: $(ruby -v | cut -f-2 -d ' ')" }
fi

unset FOUND_RBENV rbenvdirs dir
