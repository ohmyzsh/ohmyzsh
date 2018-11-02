#####ALIASES#######
#DIRS
alias cdhome="cd ~/"
#DEV
alias gdiff="git difftool -y --no-symlinks"
alias gdiffdir="git difftool -d -y --no symlinks"
alias vs="vstudio"
alias vc="vcode"


####FUNCTIONS#######
function test()
{
    echo $(pwd -P)/$1 | sed 's_/mnt/d_D:_'
    echo $(pwd -P)/$1 | sed 's_/mnt/\([:alpha:]\)_\1:_'
    echo $(pwd -P)/$1 | sed -r 's_/mnt/([[:alpha:]])_\u\1:_'
}

function bc() {
    /mnt/c/Program\ Files/Beyond\ Compare\ 4/BCompare.exe `echo $1 | sed 's_/mnt/d_D:_'` `echo $2 | sed 's_/mnt/d_D:_'`
}

function vstudio()
{
    (/mnt/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2017/Community/Common7/IDE/devenv.exe `echo $(pwd -P)/$1 | sed -r 's_/mnt/([[:alpha:]])_\u\1:_'` >/dev/null 2>&1 &)
}

function vcode()
{
    (/mnt/c/Users/Nino/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe `echo $(pwd -P)/$1 | sed -r 's_/mnt/([[:alpha:]])_\u\1:_'` >/dev/null 2>&1 &)
}
