#
# Defines Git information display styles.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# %s - Special action name (am, merge, rebase).
zstyle ':omz:plugin:git:prompt' action 'action:%s'

# %a - Indicator to notify of added files.
zstyle ':omz:plugin:git:prompt' added 'added:%a'

# %A - Indicator to notify of ahead branch.
zstyle ':omz:plugin:git:prompt' ahead 'ahead:%A'

# %B - Indicator to notify of behind branch.
zstyle ':omz:plugin:git:prompt' behind 'behind:%B'

# %b - Branch name.
zstyle ':omz:plugin:git:prompt' branch '%b'

# %C - Indicator to notify of clean branch.
zstyle ':omz:plugin:git:prompt' clean 'clean'

# %c - SHA-1 hash.
zstyle ':omz:plugin:git:prompt' commit 'commit:%c'

# %d - Indicator to notify of deleted files.
zstyle ':omz:plugin:git:prompt' deleted 'deleted:%d'

# %D - Indicator to notify of dirty files.
zstyle ':omz:plugin:git:prompt' dirty 'dirty:%D'

# %m - Indicator to notify of modified files.
zstyle ':omz:plugin:git:prompt' modified 'modified:%m'

# %R - Remote name.
zstyle ':omz:plugin:git:prompt' remote '%R'

# %r - Indicator to notify of renamed files.
zstyle ':omz:plugin:git:prompt' renamed 'renamed:%r'

# %S - Indicator to notify of stashed files.
zstyle ':omz:plugin:git:prompt' stashed 'stashed:%S'

# %U - Indicator to notify of unmerged files.
zstyle ':omz:plugin:git:prompt' unmerged 'unmerged:%U'

# %u - Indicator to notify of untracked files.
zstyle ':omz:plugin:git:prompt' untracked 'untracked:%u'

# Left prompt.
zstyle ':omz:plugin:git:prompt' prompt ' git:(%b %D%C)'

# Right prompt.
zstyle ':omz:plugin:git:prompt' rprompt ''

# Ignore submodule.
zstyle ':omz:plugin:git:prompt:ignore' submodule 'no'

# Ignore submodule when it is 'dirty', 'untracked', 'all', or 'none'.
zstyle ':omz:plugin:git:prompt:ignore:submodule' when 'all'

