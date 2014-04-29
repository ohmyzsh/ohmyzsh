function _npm_brew_paths() {
    local old_eglob=$(setopt | grep '^extendedglob$')
    [ -z ${old_eglob} ] && setopt extendedglob
    echo /usr/local/lib/node_modules/^npm/bin
    [ -z ${old_eglob} ] && setopt noextendedglob
}

# add /usr/local/lib/node_modules/^npm/bin to PATH
for p in `_npm_brew_paths`;
    [ -d $p ] && path=($p $path)
unset _npm_brew_paths
