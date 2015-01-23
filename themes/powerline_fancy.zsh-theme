# FreeAgent puts the powerline style in zsh !
#
_wd() {
  echo $(pwd | perl -pe "
   BEGIN {
      binmode STDIN,  ':encoding(UTF-8)';
      binmode STDOUT, ':encoding(UTF-8)';
   }; \
        s|/home/developer/repos/github.com|__GITHUB|g; \
        s|/home/developer/repos/bitbucket.org|__BITBUCKET|g; \
        s|/media/ahmed/OS|__WINDOZ|g;\
        s|^$HOME/Dropbox|__DROPBOX|g;\
        s|/var/www|__WWW|g;\
        s|^$HOME|__HOME|g;\
        s|/([^/])[^/]*(?=/)|/\$1|g") | \
    sed \
        -e "s/__GITHUB/ /g" \
        -e "s/__BITBUCKET/ /g" \
        -e "s/__WINDOZ/ /g" \
        -e "s/__DROPBOX/ /g" \
        -e "s/__WWW/ /g" \
        -e "s/__HOME/ /g" \
        -e "0,/^\//s// \//g" \
        -e "s/\///g"
}

if [ "$POWERLINE_DATE_FORMAT" = "" ]; then
  POWERLINE_DATE_FORMAT=%D{%Y-%m-%d}
fi

if [ "$POWERLINE_RIGHT_B" = "" ]; then
  POWERLINE_RIGHT_B=%D{%H:%M:%S}
elif [ "$POWERLINE_RIGHT_B" = "none" ]; then
  POWERLINE_RIGHT_B=""
fi

if [ "$POWERLINE_RIGHT_A" = "mixed" ]; then
  POWERLINE_RIGHT_A=%(?."$POWERLINE_DATE_FORMAT".%F{red}✘ %?)
elif [ "$POWERLINE_RIGHT_A" = "exit-status" ]; then
  POWERLINE_RIGHT_A=%(?.%F{green}✔ %?.%F{red}✘ %?)
elif [ "$POWERLINE_RIGHT_A" = "date" ]; then
  POWERLINE_RIGHT_A="$POWERLINE_DATE_FORMAT"
fi
POWERLINE_RIGHT_A="A"
POWERLINE_RIGHT_B="B"

if [ "$POWERLINE_HIDE_USER_NAME" = "" ] && [ "$POWERLINE_HIDE_HOST_NAME" = "" ]; then
    POWERLINE_USER_NAME=""
elif [ "$POWERLINE_HIDE_USER_NAME" != "" ] && [ "$POWERLINE_HIDE_HOST_NAME" = "" ]; then
    POWERLINE_USER_NAME=""
elif [ "$POWERLINE_HIDE_USER_NAME" = "" ] && [ "$POWERLINE_HIDE_HOST_NAME" != "" ]; then
    POWERLINE_USER_NAME=""
else
    POWERLINE_USER_NAME=""
fi

if [ "$POWERLINE_FULL_CURRENT_PATH" = "" ]; then
  POWERLINE_CURRENT_PATH='$(_wd)'
fi

if [ "$POWERLINE_GIT_CLEAN" = "" ]; then
  POWERLINE_GIT_CLEAN="✔"
fi

if [ "$POWERLINE_GIT_DIRTY" = "" ]; then
  POWERLINE_GIT_DIRTY="✘"
fi

if [ "$POWERLINE_GIT_ADDED" = "" ]; then
  POWERLINE_GIT_ADDED="%F{green}✚%F{black}"
fi

if [ "$POWERLINE_GIT_MODIFIED" = "" ]; then
  POWERLINE_GIT_MODIFIED="%F{blue}✹%F{black}"
fi

if [ "$POWERLINE_GIT_DELETED" = "" ]; then
  POWERLINE_GIT_DELETED="%F{red}✖%F{black}"
fi

if [ "$POWERLINE_GIT_UNTRACKED" = "" ]; then
  POWERLINE_GIT_UNTRACKED="%F{yellow}✭%F{black}"
fi

if [ "$POWERLINE_GIT_RENAMED" = "" ]; then
  POWERLINE_GIT_RENAMED="➜"
fi

if [ "$POWERLINE_GIT_UNMERGED" = "" ]; then
  POWERLINE_GIT_UNMERGED="═"
fi

# \ue0a0 
# \uf09b 
#
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $POWERLINE_GIT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN=" $POWERLINE_GIT_CLEAN"

ZSH_THEME_GIT_PROMPT_ADDED=" $POWERLINE_GIT_ADDED"
ZSH_THEME_GIT_PROMPT_MODIFIED=" $POWERLINE_GIT_MODIFIED"
ZSH_THEME_GIT_PROMPT_DELETED=" $POWERLINE_GIT_DELETED"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" $POWERLINE_GIT_UNTRACKED"
ZSH_THEME_GIT_PROMPT_RENAMED=" $POWERLINE_GIT_RENAMED"
ZSH_THEME_GIT_PROMPT_UNMERGED=" $POWERLINE_GIT_UNMERGED"
ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"

# if [ "$(git_prompt_info)" = "" ]; then
   # POWERLINE_GIT_INFO_LEFT=""
   # POWERLINE_GIT_INFO_RIGHT=""
# else
    if [ "$POWERLINE_SHOW_GIT_ON_RIGHT" = "" ]; then
        if [ "$POWERLINE_HIDE_GIT_PROMPT_STATUS" = "" ]; then
            POWERLINE_GIT_INFO_LEFT=" %F{blue}%K{white}"$''"%F{white}%F{black}%K{white}"$'$(git_prompt_info)$(git_prompt_status)%F{white}'
        else
            POWERLINE_GIT_INFO_LEFT=" %F{blue}%K{white}"$''"%F{white}%F{black}%K{white}"$'$(git_prompt_info)%F{white}'
        fi
        POWERLINE_GIT_INFO_RIGHT=""
    else
        POWERLINE_GIT_INFO_LEFT=""
        POWERLINE_GIT_INFO_RIGHT="%F{white}"$'\ue0b2'"%F{black}%K{white}"$'$(git_prompt_info)'" %K{white}"
    fi
# fi

if [ $(id -u) -eq 0 ]; then
    POWERLINE_SEC1_BG=%K{red}
    POWERLINE_SEC1_FG=%F{red}
else
    POWERLINE_SEC1_BG=%K{green}
    POWERLINE_SEC1_FG=%F{green}
fi
POWERLINE_SEC1_TXT=%F{black}
if [ "$POWERLINE_DETECT_SSH" != "" ]; then
  if [ -n "$SSH_CLIENT" ]; then
    POWERLINE_SEC1_BG=%K{red}
    POWERLINE_SEC1_FG=%F{red}
    POWERLINE_SEC1_TXT=%F{white}
  fi
fi
PROMPT="$POWERLINE_SEC1_BG$POWERLINE_SEC1_TXT$POWERLINE_USER_NAME %k%f$POWERLINE_SEC1_FG%K{blue}"$''"%k%f%F{white}%K{blue} "$POWERLINE_CURRENT_PATH"%F{blue}"$POWERLINE_GIT_INFO_LEFT" %k"$''"%f "

if [ "$POWERLINE_NO_BLANK_LINE" = "" ]; then
    PROMPT="
"$PROMPT
fi

if [ "$POWERLINE_DISABLE_RPROMPT" = "" ]; then
    if [ "$POWERLINE_RIGHT_A" = "" ]; then
        RPROMPT="$POWERLINE_GIT_INFO_RIGHT%F{yellow}"$''"%k%F%K $POWERLINE_RIGHT_B %f%k"
    elif [ "$POWERLINE_RIGHT_B" = "" ]; then
        RPROMPT="$POWERLINE_GIT_INFO_RIGHT%F{yellow}"$''"%k%F%K $POWERLINE_RIGHT_A %f%k"
    else
        RPROMPT="$POWERLINE_GIT_INFO_RIGHT%F{red}"$''"%k%F%K $POWERLINE_RIGHT_B %f%F{red}"$''"%f%k%K%F $POWERLINE_RIGHT_A %f%k"
    fi
fi

POWERLINE_GIT_INFO_RIGHT='$(git_prompt_short_sha)'
RPROMPT="%F{green}$POWERLINE_GIT_INFO_RIGHT"
