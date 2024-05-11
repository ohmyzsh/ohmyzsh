# vim:ft=zsh ts=2 sw=2 sts=2
#
# jijeesh Theme - https://github.com/jijeesh/kubectl-aliases/blob/master/README.md
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

function toon {
  local os_type="$(uname -s)"
  case "${os_type}" in
    "Darwin") echo -n "🍎" ;; # macOS
    "Linux") echo -n "🐧" ;; # Linux (Ubuntu)
    *) echo -n "♔" ;; # Default emoji for unknown OS
  esac
}


function k8sSymbol {
  echo -n " ☸ "
}
function gitSymbol {
  echo -n " \uE0A0 "
}

function kubect_prompt_info() {
  local kubectl_prompt="$(kubectl config current-context)"
  local kgnc_prompt="$(kubectl config view --minify --output 'jsonpath={..namespace}')"
  #  prompt_segment blue yellow 
  echo -n "${ZSH_THEME_KUBECTL_PROMPT_PREFIX}${kgnc_prompt}${ZSH_THEME_KUBECTL_PROMPT_SUFFIX}"
}

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n %{$reset_color%}'
    local user_symbol='$'
fi

if [ -d ~/.kube ]; then
local k8s_symbol='%{$fg_bold[blue]%}$(k8sSymbol) $(kubect_prompt_info) %{$reset_color%}'
fi
local current_dir='%{$fg_bold[red]%}$(toon)%  %{$terminfo[bold]$fg_bold[yellow]%}%~ %{$reset_color%}'
local git_branch='$(git_prompt_info)'



PROMPT="╭─${user_host}${k8s_symbol}${git_branch}
${current_dir}
╰─%B${user_symbol}%b "
RPROMPT="%B${return_code}%b"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[red]%}$(gitSymbol)%{$reset_color%}%{$fg_bold[red]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

