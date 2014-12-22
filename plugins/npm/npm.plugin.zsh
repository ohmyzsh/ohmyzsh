if [ Cygwin = "$(uname -o 2>/dev/null)" ]; then
    return
fi
eval "$(npm completion 2>/dev/null)"
