##############################################################################
# zmoji: A fun oh_my_zsh theme with an OSX emoji character in your prompt
#
# Requires the zmoji, moonphase, battery, and emoji-clock plugins
#
# Open this link in Safari to see a master list:
# http://www.grumdrig.com/emoji-list/
#
# You can specify the emoji you want to setting the ICON environment variable
# otherwise a random one will be chosen for each shell.
#
# 2014-02-28 - version 1.0 released
##############################################################################

# This array stores emoji for each hour of the day
ICONLIST=(
  ALIEN_MONSTER                 # 1 am
  IMP                           # 2 am
  JAPANESE_GOBLIN               # 3 am
  SKULL                         # 4 am
  EXTRATERRESTRIAL_ALIEN        # 5 am
  SUN_WITH_FACE                 # 6 am
  COOKING                       # 7 am
  HOT_BEVERAGE                  # 8 am
  PERSONAL_COMPUTER             # 9 am
  FLOPPY_DISK                  # 10 am
  SEE-NO-EVIL_MONKEY           # 11 am
  HEAR-NO-EVIL_MONKEY          # 12 pm
  SPEAK-NO-EVIL_MONKEY         #  1 pm
  DIZZY_SYMBOL                 #  2 pm
  SAILBOAT                     #  3 pm
  SURFER                       #  4 pm
  BEER_MUG                     #  5 pm
  CURRY_AND_RICE               #  6 pm
  COCKTAIL_GLASS               #  7 pm
  MAN_AND_WOMAN_HOLDING_HANDS  #  8 pm
  DANCER                       #  9 pm
  WOMAN_WITH_BUNNY_EARS        # 10 pm
  KISS                         # 11 pm
  SMILING_FACE_WITH_HORNS      # 12 am
)

autoload -U colors && colors

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

function setprompt {
  # Here we let the user choose an emoji, or pick a random one.
  if (($EMOJI_KEYS[(Ie)$ICON])); then
    # Use this prompt if you want to set your ICON manually
    # PROMPT='[%{$fg[yellow]%}%2~%{$reset_color%}]$EMOJI[$ICON]  %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'

    # What time is it?  Adventure Time!
    AT_PROMPT='%{$bg[white]$fg[blue]%}|(%{$fg[black]%}•◡•%{$fg[blue]%})|%{$reset_color%} %{$fg[yellow]$bg[white]%}(%{$fg[black]%}❍ %{$fg[yellow]%}ᴥ %{$fg[black]%}❍ %{$fg[yellow]%}ʋ)%{$reset_color%} [%{$fg[green]%}%2~%{$reset_color%}] $EMOJI[$ICON]  %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'
    PROMPT='%{$reset_color%}[%{$fg[green]%}%2~%{$reset_color%}] $EMOJI[$ICON]  %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'

    # Use this prompt if you want your ICON to change every hour
    # PROMPT='[%{$fg[yellow]%}%2~%{$reset_color%}]%(0T.$EMOJI[$ICONLIST[24]].%(1T.$EMOJI[$ICONLIST[1]].%(2T.$EMOJI[$ICONLIST[2]].%(3T.$EMOJI[$ICONLIST[3]].%(4T.$EMOJI[$ICONLIST[4]].%(5T.$EMOJI[$ICONLIST[5]].%(6T.$EMOJI[$ICONLIST[6]].%(7T.$EMOJI[$ICONLIST[7]].%(8T.$EMOJI[$ICONLIST[8]].%(9T.$EMOJI[$ICONLIST[9]].%(10T.$EMOJI[$ICONLIST[10]].%(11T.$EMOJI[$ICONLIST[11]].%(12T.$EMOJI[$ICONLIST[12]].%(13T.$EMOJI[$ICONLIST[13]].%(14T.$EMOJI[$ICONLIST[14]].%(15T.$EMOJI[$ICONLIST[15]].%(16T.$EMOJI[$ICONLIST[16]].%(17T.$EMOJI[$ICONLIST[17]].%(18T.$EMOJI[$ICONLIST[18]].%(19T.$EMOJI[$ICONLIST[19]].%(20T.$EMOJI[$ICONLIST[20]].%(21T.$EMOJI[$ICONLIST[21]].%(22T.$EMOJI[$ICONLIST[22]].%(23T.$EMOJI[$ICONLIST[23]].\$))))))))))))))))))))))))  %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'

    # This includes exit status, battery monitor, clock, and moon phase
    # RPROMPT='$(vi_mode_prompt_info) %{$fg_bold[red]%}%(0?..[%?])%{$reset_color%}$(battery_level_gauge) %T %(17T.$EMOJI[BEER_MUG].$(emoji-clock))  $(printmoon)'
    # RPROMPT='$(vi_mode_prompt_info) %{$fg_bold[red]%}%(0?..[%?])%{$reset_color%}$(battery_level_gauge) $(printmoon)'
    # And the same without the battery gauge
    # RPROMPT='$(vi_mode_prompt_info) %{$fg_bold[red]%}%(0?..[%?])     '
  fi
}

setprompt
