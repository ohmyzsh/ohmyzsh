# The 'ls' family
# ------------------------------------------------------------------------------
if [[ "$DISABLE_COLOR" != 'true' ]]; then
  if (( ${+commands[dircolors]} )); then
    dircolors="${commands[dircolors]}"
  fi
  if (( ${+commands[gdircolors]} )); then
    dircolors="${commands[gdircolors]}"
  fi
  if [[ -x "$dircolors" ]] && [[ -e "$HOME/.dir_colors" ]]; then
    eval $("$dircolors" "$HOME/.dir_colors")
    alias ls='ls -hF --group-directories-first --color=auto'
  else
    export CLICOLOR=1
    export LSCOLORS="exfxcxdxbxegedabagacad"
    if [[ "`uname`" = Linux ]]; then
        alias ls='ls -G -F --color=auto'
    else
        alias ls='ls -G -F'
    fi
  fi
fi

alias ll='ls -lh'            # Show human readable.
alias l='ls -lha'            # Show hidden files.
alias la='ls -lhA'           # Show hidden files.
alias lx='ls -lhXB'          # Sort by extension.
alias lk='ls -lhSr'          # Sort by size, biggest last.
alias lc='ls -lhtcr'         # Sort by and show change time, most recent lasa.
alias lu='ls -lhtur'         # Sort by and show access time, most recent last.
alias lt='ls -lhtr'          # Sort by date, most recent last.
alias lm='ls -lha | more'    # Pipe through 'more'.
alias lr='ls -lhR'           # Recursive ls.

# General
# ------------------------------------------------------------------------------
alias rm='nocorrect rm -i'
alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
alias ln='nocorrect ln -i'
alias mkdir='nocorrect mkdir -p'
alias du='du -kh'
alias df='df -kh'
alias pu='pushd'
alias po='popd'
alias _='sudo'
alias e="$EDITOR"
alias history='fc -l 1'
alias get='curl -C - -O'
alias q='exit'
alias ssh='ssh -X'
alias h='history'
alias j='jobs -l'
alias f='fg'
alias gr='grep -r'
alias afind='ack -il'
alias type='type -a'
# alias ssh='ssh -X'
alias print-path='echo -e ${PATH//:/\\n}'
alias t="t --task-dir ~/.tasks --list todo.txt --delete-if-empty"

alias z='vim -o ~/.zshenv ~/.oh-my-zsh/lib/aliases.zsh ~/.zshrc'
alias zs='source ~/.zshrc'

if [[ "$EDITOR" = vi* ]]; then
  alias v.='vim .'
  alias v='vim ~/.vimrc'
  alias VS='vim -S Session.vim'
fi

if [[ -x "${commands[htop]}" ]]; then
  alias top=htop
else
  alias topm='top -o vsize'
  alias topc='top -o cpu'
fi

if [[ "$DISABLE_COLOR" != 'true' ]]; then
  if [[ -x "${commands[colordiff]}" ]]; then
    alias diff='colordiff'
  fi

  if [[ -x "${commands[colormake]}" ]]; then
    alias make='colormake'
  fi
fi

# Terminal Multiplexer
# ------------------------------------------------------------------------------
local screenrc tmuxconf
if [[ "$TERM" == 'xterm-color' ]]; then
  if [[ -e "$HOME/.screenrc" ]]; then
    screenrc="-c '$HOME/.screenrc'"
  fi
  if [[ -e "$HOME/.tmux.conf" ]]; then
    tmuxconf="-f '$HOME/.tmux.conf'"
  fi
fi

if [[ "$TERM" == 'xterm-256color' ]]; then
  if [[ -e "$HOME/.screenrc256" ]]; then
    screenrc="-c '$HOME/.screenrc256'"
  fi
  if [[ -e "$HOME/.tmux256.conf" ]]; then
    tmuxconf="-f '$HOME/.tmux256.conf'"
  fi
fi

alias screen="screen $screenrc"
alias sl="screen $screenrc -list"
alias sr="screen $screenrc -a -A -U -D -R"
alias S="screen $screenrc -U -S"

alias tmux="tmux $tmuxconf"
alias tls="tmux list-sessions"

