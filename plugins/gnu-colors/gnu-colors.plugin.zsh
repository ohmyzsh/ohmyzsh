if type dircolors &> /dev/null; then
    eval `dircolors ~/.dir_colors`
fi

# Temporary workaround for tab completion LS_COLORS; Issue #1563
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
