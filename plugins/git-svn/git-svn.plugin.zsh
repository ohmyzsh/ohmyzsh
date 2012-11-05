# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
alias gsd='git svn dcommit'

#
# git equivalent of svnversion
#
get_svnversion()
{
    local git_version=`git describe --always 2>/dev/null`
    local git_svnversion=`git svn find-rev $git_version 2>/dev/null`
    local svn_version
    LANG=C svn_version=`/usr/bin/svnversion`
    if [ "X$svn_version" == "Xexported" -o "X$svn_version" == "X" ]; then
        echo $git_svnversion
    else
        echo $svn_version
    fi
}
alias svnversion=get_svnversion

