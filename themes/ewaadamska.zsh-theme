GetRandomPet () {

        pets=(
		'\U1F422'
		'\U1F41D' 
		'\U1F9AD'
		'\U1FABF'
		'\U1F989'
		'\U1F9A5'
		'\U1F9A7'
)

        RANDOM=$$$(date +%s)
        echo -e ${pets[1+ $RANDOM % ${#pets[@]} ]}
}



PROMPT_PET=$(GetRandomPet)



PROMPT="%(?:%{$fg_bold[green]%}➜ $PROMPT_PET :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
