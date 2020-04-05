# Modern filesystems, e.g. BTRFS, APFS, implement copy-on-write (CoW) feature,
# which could perform instant (lightweight) copy.

__TEMP_1=`mktemp`
__TEMP_2=`mktemp`

if [[ "$OSTYPE" == darwin* ]]; then
    # APFS supports CoW, and macOS since 10.12 implements it via clonefile().
    # However, in rare cases, it will fail on cross-filesystem or non-CoW filesystem.
    # We try clonefile() first, then fall back to normal copyfile().
    if /bin/cp -c ${__TEMP_1} ${__TEMP_2} &>/dev/null; then
        cp () { /bin/cp -c "$@" 2>/dev/null || /bin/cp "$@" ; }
    fi
elif [[ "$OSTYPE" == linux-gnu ]]; then
    # --reflink=auto will fall back to a standard copy if fails on lightweight copy,
    # so it could always consider safe.
    if /bin/cp --reflink=auto ${__TEMP_1} ${__TEMP_2} &>/dev/null; then
        alias cp='/bin/cp --reflink=auto'
    fi
fi

rm -f ${__TEMP_1} ${__TEMP_1} &>/dev/null
unset __TEMP_1 __TEMP_2
