
if ! [ -d "$ZSH/plugins/git-svn/git-svn-clone-externals" ] ;then
    git clone https://github.com/andrep/git-svn-clone-externals.git
fi
export PATH="$ZSH/plugins/git-svn/git-svn-clone-externals:$PATH"

function git_svn_update {
    (cd "$ZSH/plugins/git-svn/git-svn-clone-externals" && \
        git pull origin master)
}
