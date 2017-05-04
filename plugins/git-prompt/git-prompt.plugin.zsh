# ZSH Git Prompt Plugin from:
# http://github.com/olivierverdier/zsh-git-prompt

__GIT_PROMPT_DIR="${0:A:h}"

## Hook function definitions
function chpwd_update_git_vars() {
    update_current_git_vars
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

chpwd_functions+=(chpwd_update_git_vars)
precmd_functions+=(precmd_update_git_vars)
preexec_functions+=(preexec_update_git_vars)


## Function definitions

function get_tagname_or_hash() {
    local log_string
    local refs ref
    local ret_hash ret_tag
    log_string="$(git log -1 --decorate=full --format="%h%d" 2> /dev/null)"
    if [[ "$log_string" == *' ('*')' ]]; then
        ret_hash="${log_string%% (*)}"
        refs="${(M)log_string%% (*)}"
        refs="${refs# \(}"
        refs="${refs%\)}"
        for ref in ${(s:, :)refs}; do
            if [[ "$ref" == 'refs/tags/'* ]]; then # git 1.7.x
                ret_tag="${ref#refs/tags/}"
            elif [[ "$ref" == 'tag: refs/tags/'* ]]; then # git 2.1.x
                ret_tag="${ref#tag: refs/tags/}"
            fi
            if [[ "$ret_tag" != "" ]]; then
                TAG_OR_HASH="tags/$ret_tag"
                return
            fi
        done
        TAG_OR_HASH="$ret_hash"
    fi
}

function update_current_git_vars() {
    local branch branch_description branch_parts
    local ahead=0 behind=0
    local staged=0 conflict=0 changed=0 untracked=0
    local status_string status_line
    local divergence div

    __CURRENT_GIT_STATUS=0
    status_string="$(git status --branch --porcelain -z 2> /dev/null)"
    if [[ $? -ne 0 ]]; then
        # not a git repository
        return
    fi
    __CURRENT_GIT_STATUS=1

    for status_line in ${(0)status_string}; do
        if [[ "${status_line:0:2}" == '##' ]]; then
            branch_description="${status_line:2}"
            if [[ "$branch_description" == *'Initial commit on '* ]]; then
                branch="${branch_description/#*'Initial commit on '/}"
            elif [[ "$branch_description" == *'no branch'* ]]; then
                get_tagname_or_hash
                branch="$TAG_OR_HASH"
            elif [[ "$branch_description" != *'...'* ]]; then
                branch="${branch_description# }"
            else
                # local and remote branch info
                branch_parts=(${(s:...:)branch_description})
                branch="${branch_parts[1]# }"
                if [[ $#branch_parts -ne 1 ]]; then
                    # ahead or behind
                    divergence="${(M)branch_parts[2]%\[*\]}"
                    divergence="${divergence#\[}"
                    divergence="${divergence%\]}"
                    for div in ${(s:, :)divergence}; do
                        if [[ "$div" == 'ahead '* ]]; then
                            ahead="${div#ahead }"
                        elif [[ "$div" == 'behind '* ]]; then
                            behind="${div#behind }"
                        fi
                    done
                fi
            fi
        elif [[ "${status_line:0:2}" == '??' ]]; then
            untracked=$((untracked + 1))
        else
            if [[ "${status_line:1:1}" == 'M' ]]; then
                changed=$((changed + 1))
            elif [[ "${status_line:0:1}" == 'U' ]]; then
                conflict=$((conflict + 1))
            elif [[ "${status_line:0:1}" != ' ' ]]; then
                staged=$((staged + 1))
            fi
        fi
    done
    GIT_BRANCH="$branch"
    GIT_AHEAD="$ahead"
    GIT_BEHIND="$behind"
    GIT_STAGED="$staged"
    GIT_CONFLICTS="$conflict"
    GIT_CHANGED="$changed"
    GIT_UNTRACKED="$untracked"
}

git_super_status() {
    precmd_update_git_vars
    if [ "$__CURRENT_GIT_STATUS" -eq 1 ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      fi
      STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo "$STATUS"
    fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

# Set the prompt.
RPROMPT='$(git_super_status)'
