# maxme theme
# preview:

# features:
# path is autoshortened to ~30 characters
# displays git status (if applicable in current folder)

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="white"; fi

# prompt
PROMPT='%{$fg[$NCOLOR]%}%B%m%b%{$reset_color%}:%{$fg[green]%}%30<...<%~%<<%{$reset_color%}%(!.#.$) '
RPROMPT='$(git_prompt_info)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"

# LS colors, made with http://geoff.greer.fm/lscolors/
export LS_COLORS="no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=00;35;33;00:cd=40;33;00:or=40;31;00:ex=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.deb=00;31:*.rpm=00;31:*.jpg=00;35:*.png=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.png=00;35:*.mpg=00;35:*.avi=00;35:*.fli=00;35:*.gl=00;35:*.dl=00;35:"
