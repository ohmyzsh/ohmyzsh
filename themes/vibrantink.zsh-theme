###
# 
# #theme    vibrantink
#
# #author   Ben Demaree
# #purpose  Flexible, fully-featured theme for the working coder
# #colors   Vibrant Ink
# 
# #org      crunchdev
# #contact  ben@crunchdev.com
#
# #credits  Based on the gnzh theme at its core
#               https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/gnzh.zsh-theme
#           Influences from Steve Losh
#               http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
#           Help from compendium of zsh themes
#               https://github.com/robbyrussell/oh-my-zsh/tree/master/themes
###

# Prefereces for your convenience
local remote_session_postfix='✈'
local local_session_postfix='⌂'
local first_line_prefix='#'
local second_line_prefix='↳'
local return_line_prefix='↵'
local env_prefix='‹'
local env_suffix='›'
local vcs_dirty='✘'
local vcs_separator='/'
local git='★'
local mercurial='☿'
local venv='▣'
local rvm='♦'

# Load some modules
autoload -U colors zsh/terminfo
colors
setopt prompt_subst

# Colors from Jo Vermeulen's Vibrant Ink adaptation for vim
# Therefore the colors are attributable to Justin Palmer
#
# http://www.vim.org/scripts/script.php?script_id=1794
eval sunset_orange='$FG[202]'   # keyword, define, statement
eval candy_purple='$FG[098]'    # comment
eval light_yellow='$FG[228]'    # constant
eval golden_yellow='$FG[220]'   # function, include
eval electric_green='$FG[082]'  # string
eval dark_grey='$FG[235]'       # cursorline
eval ruby_red='$FG[124]'        # guess what language this is for?

# Standard 16 terminal color definitions
for color in red green yellow blue magenta cyan white; do
    eval $color='%{$fg[${color}]%}'; done

# Dem effects
local reset=$FX[reset]
local bold=$FX[bold]
local italic=$FX[italic]
local uline=$FX[underline]

# Check the UID to determine the user level
if [[ $UID -ge 100 ]]; then
    eval user='$sunset_orange%n$reset'
elif [[ $UID -eq 0 ]]; then
    eval user='$red%n$reset'
else
    eval user='$white%n$reset'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    eval host='$bold$candy_purple%M$remote_session_postfix$reset'     # aye, SSH
else
    eval host='$bold$candy_purple%M$local_session_postfix$reset'      # nay, local
fi

# Ruby Ruby Ruby Ruby!
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
    rvm_ruby='$ruby_red$env_prefix$rvm $(rvm-prompt i v g s)$env_suffix$reset '
else
    if which rbenv &> /dev/null; then
        rvm_ruby='$ruby_red$env_prefix$rvm $(rbenv version | sed -e "s/ (set.*$//")$env_suffix$reset '
    fi
fi

#Variables...assemble!
local pre_prompt_upper='$bold$first_line_prefix$reset'
local pre_prompt_lower='$bold$cyan $second_line_prefix$reset'
local return_code='%(?..%{$red%}%? $return_line_prefix$reset)'
local user_host='$bold$user$bold$light_yellow@$reset$host'
local current_dir='$bold$yellow${PWD/#$HOME/~}$reset'
local git_branch='$(git_prompt_info)$reset'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $vcs_dirty"
ZSH_THEME_GIT_PROMPT_SUFFIX="$env_suffix$reset"

add-zsh-hook precmd build_prompt
build_prompt () {
    # This is a great place to put variables that may change based on working dir
    # or environment changes
    
    # Oh yeah, we got Python
    [ $VIRTUAL_ENV ] && {
        venv_name=$(basename "$VIRTUAL_ENV")
        local venv_status='$electric_green$env_prefix$venv $venv_name$env_suffix$reset '
    }

    # Grab the name of the current git repository, if we're in one
    [ $(git status &>/dev/null) $? -eq "0" ] && {
        git_name=$(git rev-parse --show-toplevel)
        git_repo=$(basename ${git_name})$vcs_separator
        local git_status="$electric_green$env_prefix$git $git_repo$git_branch"
    }
    
    # We can also do some basic mercurial stuff
    # We're not going to show outgoing or incoming; they're just too slow
    # Adapted from http://blog.interlinked.org/tutorials/zsh_mercurial_notifier.html
    [ $(hg root &>/dev/null) $? -eq "0" ] && {
        hg_name=$(basename "$(hg root)")
        hg_branch=$(hg branch)
        [ "`hg status`" != "" ] && hg_dirty=" "$vcs_dirty || hg_dirty=''
        hg_repo=$hg_name$vcs_separator$hg_branch
        local hg_status='$electric_green$env_prefix$mercurial $hg_repo$hg_dirty$env_suffix$reset '
    }

    # Actual prompt construction
    PROMPT=" ${pre_prompt_upper} ${user_host} ${current_dir} ${venv_status}${rvm_ruby}${git_status}${hg_status}
${pre_prompt_lower} "
    RPS1="${return_code}"
}
