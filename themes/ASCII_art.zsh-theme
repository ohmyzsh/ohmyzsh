# An ASCII art theme

# color vars
local my_gray=$FG[237]
local my_orange=$FG[214]

# Faces "%" is needed to escape ")"
local -a happy_faces
happy_faces=('⎝(◕u◕%)⎠' '⎝( OωO%)⎠' '(^u^%)' 'ヽ(●´∀`●%)ﾉ' '(ﾉ>ω<%)ﾉ' '(｡◕∀◕｡%)' 'ヽ(✿ﾟ▽ﾟ%)ノ' '(ﾉ◕ヮ◕%)ﾉ*:･ﾟ✧' '٩(๑•̀ω•́๑%)۶' '(๑ ^ ₃•๑%)' '(｡◕∀◕｡%)' '(๑•̀ㅂ•́%)و✧' '٩(๑•̀ω•́๑%)۶' '(▰˘◡˘▰%)' 'ヽ(●´ε｀●%)ノ' '(ゝ∀･%)⌒☆' '(◍•ᴗ•◍%)ゝ' '✧*｡٩(ˊᗜˋ*%)و✧*｡' '(⁎⁍̴̛ᴗ⁍̴̛⁎%)‼' '< (￣︶￣%)>' '(๑ ^ ₃•๑%)' '(๑╹◡╹๑%)')
local -a sad_faces
sad_faces=('_(:3 」∠ %)_' '_(:3 ⌒ﾞ%)_' 'ლ(́◕◞౪◟◕‵ლ%)' '╮(╯_╰%)╭' '┐(´д`%)┌' 'ლ(´•д• ̀ლ' '(〒︿〒%)' 'ヾ(;ﾟ;Д;ﾟ;%)ﾉﾞ' '(╥﹏╥%)' '(;´༎ຶД༎ຶ`%)' '(ノ=Д=%)ノ┻━┻')

local face_color="%(?:%{$fg[magenta]%}:%{$fg[cyan]%})"

# primary prompt
PROMPT='$(git_prompt_info)${face_color}%(?:$happy_faces[$((RANDOM % $#happy_faces+1))]:$sad_faces[$((RANDOM %$#sad_faces+1))])$my_orange» %{$reset_color%}'

RPROMPT='$FG[032]%~'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[032]%}git:(%{$FG[105]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[032]%}) %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[032]%})"
