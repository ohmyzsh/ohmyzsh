# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user='%{$fg[green]%}%n%{$reset_color%}'
local user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

local git_branch='$(git_prompt_info)%{$reset_color%}'
local hg_info='$(hg_prompt_info)'
local android_info='$(android_prompt_info)'

PROMPT="╭─${user} ${current_dir} ${android_info}${git_branch}${hg_info}
╰─%B$%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_HG_PROMPT_PREFIX=$ZSH_THEME_GIT_PROMPT_PREFIX
ZSH_THEME_HG_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX

ZSH_THEME_ANDROID_PROMPT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_ANDROID_PROMPT_SUFFIX="› %{$reset_color%}"