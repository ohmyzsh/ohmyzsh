# The default styles.
zstyle ':git-info:' action    'action:%s'       #  %s - Special action name (am, merge, rebase).
zstyle ':git-info:' added     'added:%a'        #  %a - Indicator to notify of added files.
zstyle ':git-info:' ahead     'ahead:%A'        #  %A - Indicator to notify of ahead branch.
zstyle ':git-info:' behind    'behind:%B'       #  %B - Indicator to notify of behind branch.
zstyle ':git-info:' branch    '%b'              #  %b - Branch name.
zstyle ':git-info:' clean     'clean'           #  %C - Indicator to notify of clean branch.
zstyle ':git-info:' commit    'commit:%c'       #  %c - SHA-1 hash.
zstyle ':git-info:' deleted   'deleted:%d'      #  %d - Indicator to notify of deleted files.
zstyle ':git-info:' dirty     'dirty'           #  %D - Indicator to notify of dirty branch.
zstyle ':git-info:' modified  'modified:%m'     #  %m - Indicator to notify of modified files.
zstyle ':git-info:' remote    '%R'              #  %R - Remote name.
zstyle ':git-info:' renamed   'renamed:%r'      #  %r - Indicator to notify of renamed files.
zstyle ':git-info:' stashed   'stashed:%S'      #  %S - Indicator to notify of stashed files.
zstyle ':git-info:' unmerged  'unmerged:%U'     #  %U - Indicator to notify of unmerged files.
zstyle ':git-info:' untracked 'untracked:%u'    #  %u - Indicator to notify of untracked files.
zstyle ':git-info:' prompt    ' git:(%b %D%C)'  #  Left prompt.
zstyle ':git-info:' rprompt   ''                #  Right prompt.
