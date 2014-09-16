# Find python file
alias pyfind='find . -name "*.py"'

# Remove python compiled byte-code in either current directory or in a
# list of specified directories
function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
}

function pydoc-serve() {
# Serves offline python documentation
# Args:
#   python_doc_version: 2 or 3 (will fall back to other if necessary)
    which serve-doc >/dev/null
    if [ $? -ne 0 ]; then
        echo "This function (pydoc-serve) depends on the oh-my-zsh serve plugin." >&2
        return
    fi

    local version=$1

    # python2 prints --version to stderr, python3 to stdout
    local iv="$(python --version 2>&1 | cut -d' ' -f2 | tr '.' ' ')"
    [ $version -ne ${iv[1]} ] \
        && iv="$(python$version --version 2>&1 | cut -d' ' -f2 | tr '.' ' ')"
    # Try to make this local … bash/zsh are a bad joke.
    installed_version=(`echo $iv`)
    local v1=${installed_version[1]}
    local v2=${installed_version[2]}
    local v3=${installed_version[3]}

    local done=-1
    for suffix in "" "docs"; do
        if [ $done -ne 0 ]; then
            serve-doc "python$v1.$v2.$v3" || \
                serve-doc "python$v1.$v2" || \
                serve-doc "python$v1" || \
                serve-doc "python"
            done=$?
        fi
    done
}

function pydoc2-serve() {
    pydoc-serve 2
}
function pydoc3-serve() {
    pydoc-serve 3
}

# Grep among .py files
alias pygrep='grep --include="*.py"'

