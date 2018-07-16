#####CONFIGURATIONS#######
DEFAULT_USER="raven"
eval `dircolors ~/dircolors`
#####EXPORTS#######
export PATH=$HOME/bin:/usr/local/bin:$PATH
export TMPDIR='/mnt/c/Users/Nino/AppData/Local/Temp'
export EDITOR='nano'
#####ALIASES#######
alias gdiff="git difftool -y --no-symlinks"
alias gdiffdir="git difftool -d -y --no symlinks"
####FUNCTIONS#######
function bc() {
    "/mnt/c/Program Files/Beyond Compare 4/BCompare.exe" "`echo $1 | sed 's_/mnt/c_C:_'`" "`echo $2 | sed 's_/mnt/c_C:_'`"
}
function test()
{
    echo $(pwd)/$1
}
