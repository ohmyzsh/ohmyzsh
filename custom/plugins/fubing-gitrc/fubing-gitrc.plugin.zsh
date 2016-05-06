

#查询我的提交 git log --author=weiw@1mxian.com
# git log --pretty="%h - %cd - %an - %s" --author=weiw --since="2015-10-01"  --before="2016-02-01" --no-merges

function traversal {
    for path in "operating" "api" "x" "group" "rbac" "scm" "finance" 
    do
        cd ~/Code/1mxian/school/$path
       #echo
        echo -e "--------------------------------------------------------------------------------------------------------  \033[02;31m$*\033[0m"
        local branch_name=$(getgitbranch)
        local last_commit=$(glo -1)
       #echo -e "\033[02;32m$PWD\033[0m on [ \033[36m$branch_name\033[0m \033[2;33m$(echo $last_commit | cut -d ' ' -f 1)\033[0m $(echo $last_commit | cut -d ' ' -f 2-) ]"
        echo -e "\033[02;32m$PWD\033[0m on [ \033[36m$branch_name\033[0m \033[2;33m$(echo $last_commit | cut -d ' ' -f 1)\033[0m ]"
       #echo
        $*
    done
   #echo
    echo -e "\033[02;31m========================================================================================================\033[0m"
    echo -e "\033[02;33mdone\033[0m"
}
function stay {
    local original_path="$(pwd)"
    $*
    cd $original_path
}
function all {
    stay traversal "$*"
}

# 输出分割线
function separation {
    #echo -e "-\033[02;31m-\033[02;32m-\033[02;33m-\033[02;34m-\033[02;35m-\033[02;36m-\033[0m-"
    echo -e "-\033[02;31m-\033[0m-\033[02;31m-\033[0m-\033[02;31m-\033[0m-\033[02;31m-\033[0m-\033[02;31m-\033[0m-"
}

# 列出 本地版本库和远程版本库里 所有的含有关键词参数的分支名称
function gitb {
    local branch_name_keyword=$1
    if [[ -z $branch_name_keyword ]]
    then
        echo -e "self-error: \033[02;31m missing argument branch_name_keyword \033[0m"
        return 0
    fi
    echo "git branch -a | grep -Ei \"$branch_name_keyword\""
    echo
    git branch -a | grep -Ei "$branch_name_keyword"
}
function allgitb {
    all gitb "$*"
}

function getgitbranch {
   #echo $(git branch 2> /dev/null | grep \* | cut -d " " -f 2 | grep -Ei ".*")
    current_branch
}

# 查看当前分支的分支名称
function giton {
    local branch_name=$(getgitbranch)
    local last_commit=$(git log --abbrev-commit --pretty=oneline -1)
   #echo -e "on [ \033[36m$branch_name\033[0m \033[2;33m$(echo $last_commit | cut -d ' ' -f 1)\033[0m $(echo $last_commit | cut -d ' ' -f 2-) ]"
    echo -e "on [ \033[36m$branch_name\033[0m \033[2;33m$(echo $last_commit | cut -d ' ' -f 1)\033[0m ]"
}
function allgiton {
    all giton "$*"
}

# 切换到 本地版本库里的某分支
function gitco {
    local new_branch_name=$1
    if [[ -z $new_branch_name ]]
    then
        echo -e "self-error: \033[02;31m missing argument new_branch_name \033[0m"
        return 0
    fi
    echo "git checkout $new_branch_name 2>/dev/null >/dev/null"
    echo
    git checkout $new_branch_name 2>/dev/null >/dev/null
    local branch_name=$(getgitbranch)
    if [[ $new_branch_name != $branch_name ]]
    then
        echo -e "\033[02;31m $branch_name \033[0m"
        return 0
    fi
    giton
}
function allgitco {
    all gitco "$*"
}

# GIT-LOG-EXAMPLES
# git log --author=weiw@1mxian.com
# git log --pretty="%h - %cd - %an - %s" --author=weiw --since="2015-10-01"  --before="2016-02-01" --no-merges
# git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
function gitlg {
    echo "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen[%ci]%Creset' --abbrev-commit --date=relative"
    echo
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen[%ci]%Creset' --abbrev-commit --date=relative
}
function allgitlg {
    all gitlg "$*"
}

# 拉取远程版本库的所有分支到本地版本库
function gitf {
    echo "git fetch origin -p"
    echo
    git fetch origin -p
}
function allgitf {
    all gitf "$*"
}

# 合并 远程版本库里的某分支 到 本地版本库里的当前分支
function gitmg {
    local branch_name=$(getgitbranch)
    local source_origin_branch_name=$1
    if [[ -z $source_origin_branch_name ]]
    then
        source_origin_branch_name="$branch_name"
    fi
    echo "git fetch origin $source_origin_branch_name"
    echo
    git fetch origin $source_origin_branch_name
    separation
    gitco $branch_name
    separation
    echo "git merge FETCH_HEAD"
    echo
    git merge FETCH_HEAD
}
function allgitmg {
    all gitmg "$*"
}

# 合并 远程版本库里的同名分支 到 本地版本库里的当前分支
function gitpl {
    local branch_name=$(getgitbranch)
    echo "git pull origin $branch_name"
    echo
    git pull origin $branch_name
}
function allgitpl {
    all gitpl "$*"
}

# 撤销当前分支的最近一次提交的改动
function gitrv {
    echo "git checkout -f"
    echo
    git checkout -f
}
function allgitrv {
    all gitrv "$*"
}

# 查看当前分支的改动(简讯信息)
function gitst {
    echo "git status --porcelain"
    echo
    local result="$(git status --porcelain)"
    echo "$result" | grep -E "^\s*(M)"
    #echo
    echo "$result" | grep -E "^\s*(A|R|D)"
    #echo
    echo "$result" | grep -E "^\s*U"
    echo "$result" | grep -E "^\s*\?"
    #echo
    echo "$result" | grep -vE "^\s*(M|A|R|D|U|\?)" | grep -vE "^\s*$"
}
function allgitst {
    all gitst "$*"
}

# 检查当前分支的改动里的 php 文件的语法错误
function gitphp {
    echo "gitst | grep php$ | grep -vE \"^\s*(D)\" | sed -E 's/^ +//g' | cut -d \" \" -f 2 | xargs -n 1 php -l"
    echo
    gitst | grep php$ | grep -vE "^\s*(D)" | sed -E 's/^ +//g' | cut -d " " -f 2 | xargs -n 1 php -l
}
function allgitphp {
    all gitphp "$*"
}

# 查看当前分支的改动里所有文件的修改详情
function gitdi {
    echo "git diff -w"
    echo
    git diff -w
}
function allgitdi {
    all gitdi "$*"
}

# 提交当前分支的所有改动 到 本地版本库
function gitac {
    local commit_description="$*"
    if [[ -z $commit_description ]]
    then
        echo -e "self-error: \033[02;31m missing argument commit_description \033[0m"
        return 0
    fi
    echo "git commit -a -m \"$*\""
    echo
    git commit -a -m "$*"
}
function allgitac {
    all gitac "$*"
}

# 推送 本地版本库的当前分支 到 远程版本库的同名分支
function gitps {
    local branch_name=$(getgitbranch)
    if [[ -n $(git status | grep -E "diverged|behind") ]]
    then
        echo -e "\033[02;31mbreak off\n=========\033[0m"
        git status
        return 0
    fi
    echo "git fetch origin $branch_name"
    echo
    git fetch origin $branch_name
    echo "git push origin $branch_name"
    echo
    git push origin $branch_name
}
function allgitps {
    all gitps "$*"
}

# 删除 远程版本库的某分支
function gitdelorigin {
    local branch_name=$1
    if [[ -z $branch_name ]]
    then
        echo -e "self-error: \033[02;31m missing argument branch_name \033[0m"
        return 0
    fi
    echo "git push origin --delete $branch_name"
    echo
    git push origin --delete $branch_name
}
function allgitdelorigin {
    all gitdelorigin "$*"
}

# 删除 本地版本库的某分支
function gitdel {
    local branch_name=$1
    if [[ -z $branch_name ]]
    then
        echo -e "self-error: \033[02;31m missing argument branch_name \033[0m"
        return 0
    fi
    echo "git branch -D $branch_name"
    echo
    git branch -D $branch_name
}
function allgitdel {
    all gitdel "$*"
}

# 检测 远程版本库的当前分支 从 production分支出来 之后的改动
function gitdp {
    local options="$*"
    local branch_name=$(getgitbranch)
    if [[ -z $branch_name ]]
    then
        echo -e "self-error: \033[02;31m missing argument branch_name \033[0m"
        return 0
    fi
    echo "git diff $options origin/production...origin/$branch_name"
    echo
    git diff $options origin/production...origin/$branch_name
}
function allgitdp {
    all gitdp "$*"
}


# 初始化 自有的 test 分支
function initmyct {
    gitco production
    gitdel myct
    git push origin --delete myct
    git checkout -b myct origin/test
    gitps
}

# 初始化 自有的 staging 分支
function initmycs {
    gitco production
    gitdel mycs
    git push origin --delete mycs
    git checkout -b mycs origin/staging
    gitps
}

# 使用 composer 重建类索引
function reindex {
    echo -e '\033[02;31mplease keeping Operating latest\033[0m'
    composer dumpautoload -o
}

# 检查当前目录及子目录下的php脚本是否有语法错误
function checkphp {
    find ./ | grep php$ | xargs -n 1 php -l | grep -v 'No syntax errors'
}


# -------------------------------------------------------------------------------------------------

function _completes_all {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(cat ~/.fubing-gitrc | grep -Ei "^function " | grep -vEi "^function (all|_)" | sed -E 's/function ([^\(]*)\(\)/\1/g')
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

function _completes_get_local_branch {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(git branch | sed -E 's/\*/ /g' | sed -E 's/ +/ /g' | cut -d ' ' -f 2)
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

function _completes_get_remote_branch {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(git branch -r | grep -v 'HEAD' | sed -E 's/origin\///g')
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

#complete -F _completes_all all
#complete -F _completes_get_local_branch gitco allgitco gitdel allgitdel
#complete -F _completes_get_remote_branch gitb allgitb gitdp allgitdp gitmg allgitmg gitdelorigin allgitdelorigin


