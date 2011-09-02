# ------------------------------------------------------------------------
# Mantas Zimnickas oh-my-zsh theme
# based on juanghurtado theme
# ------------------------------------------------------------------------

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

RETURN_CODE="%(?..%{$YELLOW%}%? ↵%{$RESET_COLOR%})"

PROMPT='
< %{$GREEN_BOLD%}%n@%M%{$RESET_COLOR%} : %{$YELLOW%}%/%{$RESET_COLOR%} > ${RETURN_CODE}
%{$GREEN_BOLD%}>%{$RESET_COLOR%} '
