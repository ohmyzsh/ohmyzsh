# The 'ls' family
# ------------------------------------------------------------------------------
[[ "$DISABLE_COLOR" != 'true' ]] && {
  [[ -x "${commands[gdircolors]}" ]] && use_color_gnu='true' || use_color_bsd='true'
}

[[ "$use_color_gnu" == 'true' && -e "$HOME/.dir_colors" ]] && eval $(gdircolors $HOME/.dir_colors)
[[ "$use_color_bsd" == 'true' ]] && export CLICOLOR=1
[[ "$use_color_bsd" == 'true' ]] && export LSCOLORS="exfxcxdxbxegedabagacad"

# add colors for filetype recognition
[[ "$use_color_gnu" == 'true' ]] && alias ls='ls -hF --group-directories-first --color=auto'
[[ "$use_color_bsd" == 'true' ]] && alias ls='ls -G -F'

alias la='ls -Ahl'           # show hidden files
alias lx='ls -lhXB'          # sort by extension
alias lk='ls -lhSr'          # sort by size, biggest last
alias lc='ls -lhtcr'         # sort by and show change time, most recent last
alias lu='ls -lhtur'         # sort by and show access time, most recent last
alias lt='ls -lhtr'          # sort by date, most recent last
alias lm='ls -ahl | more'    # pipe through 'more'
alias lr='ls -lhR'           # recursive ls
alias l='ls -lha'
alias ll='ls -lh'

# General
# ------------------------------------------------------------------------------
alias rm='nocorrect rm -i'
alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
alias ln='nocorrect ln -i'
alias mkdir='nocorrect mkdir -p'
alias du='du -kh'
alias df='df -kh'
alias e="$EDITOR"
alias get='curl -C - -O'
alias q='exit'
alias ssh='ssh -X'
alias h='history'
alias j='jobs -l'
alias f='fg'
alias gr='grep -r'
alias type='type -a'
alias print-path='echo -e ${PATH//:/\\n}'
alias print-libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias lsbom='lsbom -f -l -s -pf'
alias t="$HOME/.local/bin/t --task-dir ~/.tasks --list todo.txt --delete-if-empty"

if [[ -x "${commands[htop]}" ]]; then
  alias top=htop
else
  alias topm='top -o vsize'
  alias topc='top -o cpu'
fi

[[ "$DISABLE_COLOR" != 'true' ]] && {
  [[ -x "${commands[colordiff]}" ]] && alias diff='colordiff'
  [[ -x "${commands[colormake]}" ]] && alias make='colormake'
}

# Screen
# ------------------------------------------------------------------------------
[[ "$TERM" == 'xterm-color'  && -e "$HOME/.screenrc" ]] && screenrc="-c '$HOME/.screenrc'"
[[ "$TERM" == 'xterm-256color' && -e "$HOME/.screenrc256" ]] && screenrc="-c '$HOME/.screenrc256'"
alias screen="screen $screenrc"
alias sl="screen $screenrc -list"
alias sr="screen $screenrc -a -A -U -D -R"
alias S="screen $screenrc -U -S"

# TMUX
# ------------------------------------------------------------------------------
[[ "$TERM" == 'xterm-color' && -e "$HOME/.tmux.conf" ]] && tmuxconf="-f '$HOME/.tmux.conf'"
[[ "$TERM" == 'xterm-256color' && -e "$HOME/.tmux256.conf" ]] && tmuxconf="-f '$HOME/.tmux256.conf'"
alias tmux="tmux $tmuxconf"
alias tls="tmux list-sessions"
