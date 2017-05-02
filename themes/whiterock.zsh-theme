# whiterock ZSH theme
# created 2012.06.15

# right prompt mode
# available mode : git, dir, git-dir
rp_mode='git-dir' 

# color definition
# first one is for normal user, while the other is for root user
if [ `id -u` -ne 0 ]; then
   lp_color1='yellow'
   lp_color2='blue'
   rp_frame=$lp_color2
   rp_git=$lp_color1
   rp_dir='white' 
else
   lp_color1='red'
   lp_color2='yellow'
   rp_frame=$lp_color2
   rp_git=$lp_color1
   rp_dir='white' 
fi

# left prompt
PROMPT=" %{$fg[$lp_color1]%}»%{$fg[$lp_color2]%}»%{$fg[$lp_color1]%}» %{$reset_color%}"

#right prompt
case $rp_mode in
   git)
      ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[$rp_frame]%}[%{$fg[$rp_git]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[$rp_frame]%}]%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="*"
      ZSH_THEME_GIT_PROMPT_CLEAN=""
      RPROMPT='$(git_prompt_info)%{$reset_color%}';;
   dir)
      RPROMPT='%{$fg[$rp_frame]%}[%{$fg[$rp_dir]%}%.%{$fg[$rp_frame]%}]%{$reset_color%}';;
   git-dir)
      ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[$rp_git]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[$rp_frame]%}|"
      ZSH_THEME_GIT_PROMPT_DIRTY="*"
      ZSH_THEME_GIT_PROMPT_CLEAN=""
      RPROMPT='%{$fg[$rp_frame]%}[$(git_prompt_info)%{$fg[$rp_dir]%}%.%{$fg[$rp_frame]%}]%{$reset_color%}';;
   *)
      RPROMPT='';;
esac   

# ps2 definition
PS2=$' %{$fg[$lp_color2]%}»%{$reset_color%} '
