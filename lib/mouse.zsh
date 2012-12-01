###########################################################################
# zsh mouse (and X clipboard) support v1.6
###########################################################################
#
# Copyright 2004-2011 Stephane Chazelas <stephane_chazelas@yahoo.fr>
#
# Permission to use, copy, modify, distribute, and sell this software and
# its documentation for any purpose is hereby granted without fee, provided
# that the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation.  No representations are made about the suitability of this
# software for any purpose.  It is provided "as is" without express or
# implied warranty.
###########################################################################
#
# QUICKSTART: jump to "how to use" below.
#
# currently supported:
#  - VT200 mouse tracking (at least xterm, gnome-terminal, rxvt)
#  - GPM on Linux little-endian systems such as i386 (at least)
#  - X clipboard handling if xsel(1) or xclip(1) is available (see
#    note below).
# 
# addionnaly, if you are using xterm and don't want to use the mouse
# tracking system, you can map some button click events so that they
# send \E[M<bt>^X[<y><x> where <bt> is the character 0x20 + (0, 1, 2)
# <x>,<y> are the coordinate of the mouse pointer. This is usually done
# by adding those lines to your resource file for XTerm (~/.Xdefaults
# for example):
#
# XTerm.VT100.translations:             #override\
#        Mod4 <Btn1Up>: ignore()\n\
#        Mod4 <Btn2Up>: ignore()\n\
#        Mod4 <Btn3Up>: ignore()\n\
#        Mod4 <Btn1Down>: string(0x1b) string("[M ") dired-button()\n\
#        Mod4 <Btn2Down>: string(0x1b) string("[M!") dired-button()\n\
#        Mod4 <Btn3Down>: string(0x1b) string("[M") string(0x22) dired-button()\n\
#        Mod4 <Btn4Down>,<Btn4Up>: string(0x10)\n\
#        Mod4 <Btn5Down>,<Btn5Up>: string(0xe)
#
# That maps the button click events with the modifier 4 (when you hold
# the <Super> Key [possibly Windows keys] under recent versions of
# XFree86). The last two lines are for an easy support of the mouse
# wheel (map the mouse wheel events to ^N and ^P)
#
# Remember that even if you use the mouse tracking, you can still have
# access to the normal xterm selection mechanism by holding the <Shift>
# key.
#
# Note about X selection.
#    By default, xterm uses the PRIMARY selection instead of CLIPBOARD
#    for copy-paste. You may prefer changing that if you want
#    <Shift-Insert> to insert the CLIPBOARD and a better communication
#    between xterm and clipboard based applications like mozilla.
#    A way to do that is to add those resources:
#    XTerm.VT100.translations:             #override\
#      Shift ~Ctrl <KeyPress> Insert:insert-selection(\
#        CLIPBOARD, CUT_BUFFER0, PRIMARY) \n\
#      Shift Ctrl <KeyPress> Insert:insert-selection(\
#        PRIMARY, CUT_BUFFER0, CLIPBOARD) \n\
#      ~Ctrl ~Meta<BtnUp>: select-end(PRIMARY,CUT_BUFFER0,CLIPBOARD)
#
#    and to run a clipboard manager application such as xclipboard
#    (whose invocation you may want to put in your X session startup
#    file). (<Shift-Ctrl-Insert> inserts the PRIMARY selection as does
#    the middle mouse button). (without xclipboard, the clipboard
#    content is lost whenever the text is no more selected).
#
# How to use:
#
# add to your ~/.zshrc:
#  . /path/to/this-file
#  zle-toggle-mouse
#
# and if you want to be able to toggle on/off the mouse support:
# bindkey -M emacs '\em' zle-toggle-mouse
# # <Esc>m to toggle the mouse in emacs mode
# bindkey -M vicmd M zle-toggle-mouse
# # M for vi (cmd) mode
#
# clicking on the button 1:
#   moves the cursor to the pointed location
# clicking on the button 2:
#   inserts zsh cutbuffer at pointed location. If $DISPLAY is set and
#   either the xsel(1) or xclip(1) command is available, then it's the
#   content of the X clipboard instead that is pasted (and stored into
#   zsh cutbuffer).
# clicking on the button 3:
#   stores the text between the cursor and the pointed localion
#   into zsh cutbuffer. Additionaly, if $DISPLAY is set and either the
#   xclip(1) or xsel(1) command is available, that text is put on the
#   clipboard.
#
# If xsel or xlip is available, and $DISPLAY is set (and you're in a
# xterm-like terminal (even though that feature is terminal
# independant)), all the keys (actually widgets) that deal with zsh
# cut buffer have been modified so that the X CLIPBOARD selection is
# used. So <Ctrl-U>, <Ctrl-W>... will put the killed region on the X
# clipboard. vi mode "p" or emacs "<Ctrl-Y>" will paste the X CLIPBOARD
# selection. Only the keys that delete one character are not affected
# (<Del>, <Backspace>, <x>). Additionnaly, the primary selection (what
# is mouse highlighted and that you paste with the middle button) is put
# on the clipboard (and so made available to zsh) when you press
# <Meta-Insert> or <Ctrl-Insert> or <Ctrl-X>X (emacs mode) or X (vicmd
# mode). (note that your terminal may already do that by default, also
# note that your terminal may paste the primary selection and not the
# clipboard on <Shift-Insert>, you may change that if you find it
# confusing (see above))
#
# for GPM, you may change the list of modifiers (Shift, Alt...) that
# need to be on for the event to be accepted (see below).
#
# kterm: same as for xterm, but replace XTerm with KTerm in the resource
# customization
# hanterm: same as for xterm, but replace XTerm with Hanterm in the
# resource customization.
# Eterm: the paste(clipboard) actions don't seem to work, future
# versions of mouse.zsh may include support for X cutbuffers or revert
# back to PRIMARY selection to provide a better support for Eterm.
# gnome-terminal: you may want to bind some keys to Edit->{copy,paste}
# multi-gnome-terminal: selection looks mostly bogus to me
# rxvt,aterm,[ckgt]aterm,mlterm,pterm: no support for clipboard.
# GNUstep terminal: no mouse support but support for clipboard via menu
# KDE x-terminal-emulator: works OK except mouse button3 that is mapped
# to the context menu. Use Ctrl-Insert to put the selection on the
# clipboard.
# dtterm: no mouse support but the selection works OK.
# 
# bugs:
#   - the GPM support was not much tested (was tested with gpm 1.19.6 on
#     a linux 2.6.9, AMD Athlon)
#   - mouse positionning doesn't work properly in "vared" if a prompt
#     was provided (vared -p <prompt>)
#
# Todo:
#   - write proper documentation
#   - customization through zstyles.
#
# Author:
#   Stephane Chazelas <Stephane_Chazelas@yahoo.fr>
#
# Changes:
#  v1.6 2011-09-15: added Copyright and License notice, no code change
#  v1.5 2005-03-12: bug fixes (GPM now works again), xclip prefered over
#       xsel as xsel is bogus.
#  v1.4 2005-03-01: <Ctrl-W><Ctrl-W> puts both words on the cut buffer
#       support for CUT_BUFFER0 via xprop.
#  v1.3 2005-02-28: support for more X terminals, tidy-up, separate
#       mouse support from clipboard support
#  v1.2 2005-02-24: support for vi-mode. X clipboard mirroring zsh cut buffer
#       when possible. Bug fixes.
#  v1.1 2005-02-20: support for X selection through xsel or xclip
#  v1.0 2004-11-18: initial release

# UTILITY FUNCTIONS

zle-error() {
  local IFS=" "
  if [[ -n $WIDGET ]]; then
    # error message if zle active
    zle -M -- "$*"
  else
    # on stderr otherwise
    print -ru2 -- "$*"
  fi
}

# SELECTION/CLIPBOARD FUNCTIONS

set-x-clipboard() { return 0; }
get-x-clipboard() { return 1; }

# find a command to read from/write to the X selections
if whence xclip > /dev/null 2>&1; then
  x_selection_tool="xclip -sel p"
  x_clipboard_tool="xclip -sel c"
elif whence xsel > /dev/null 2>&1; then
  x_selection_tool="xsel -p"
  x_clipboard_tool="xsel -b"
else
  x_clipboard_tool=
  x_selection_tool=
fi
if [[ -n $x_clipboard_tool && $ZSH_X_COPY_PASTING -gt 0 ]]; then
  eval '
    get-x-clipboard() {
      (( $+DISPLAY )) || return 1
      local r
      r=$('$x_clipboard_tool' -o < /dev/null 2> /dev/null && print .)
      r=${r%.}
      if [[ -n $r && $r != $CUTBUFFER ]]; then
	killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
	CUTBUFFER=$r
      fi
    }
    set-x-clipboard() {
      (( ! $+DISPLAY )) ||
	print -rn -- "$1" | '$x_clipboard_tool' -i 2> /dev/null
    }
    push-x-cut_buffer0() {
      # retrieve the CUT_BUFFER0 property via xprop and store it on the
      # CLIPBOARD selection
      (( $+DISPLAY )) || return 1
      local r
      r=$(xprop -root -notype 8s \$0 CUT_BUFFER0 2> /dev/null) || return 1
      r=${r#CUT_BUFFER0\"}
      r=${r%\"}
      r=${r//\'\''/\\\'\''}
      eval print -rn -- \$\'\''$r\'\'' | '$x_clipboard_tool' -i 2> /dev/null
    }
    push-x-selection() {
      # puts the PRIMARY selection onto the CLIPBOARD
      # failing that call push-x-cut_buffer0
      (( $+DISPLAY )) || return 1
      local r
      if r=$('$x_selection_tool' -o < /dev/null 2> /dev/null && print .) &&
	r=${r%?} &&
	[[ -n $r ]]; then
	print -rn -- $r | '$x_clipboard_tool' -i 2> /dev/null
      else
	push-x-cut_buffer0
      fi
    }
  '
  # redefine the copying widgets so that they update the clipboard.
  for w in copy-region-as-kill vi-delete vi-yank vi-change vi-change-whole-line vi-change-eol; do
    eval '
      '$w'() {
	zle .'$w'
	set-x-clipboard $CUTBUFFER
      }
      zle -N '$w
  done

  # that's a bit more complicated for those ones as we have to
  # re-implement the special behavior that does that if you call several
  # of those widgets in sequence, the text on the clipboard is the
  # whole text cut, not just the text cut by the latest widget.
  for w in ${widgets[(I).*kill-*]}; do
    if [[ $w = *backward* ]]; then
      e='$CUTBUFFER$scb'
    else
      e='$scb$CUTBUFFER'
    fi
    eval '
      '${w#.}'() {
	local scb=$CUTBUFFER
	local slw=$LASTWIDGET
	local sbl=${#BUFFER}

	zle '$w'
	(( $sbl == $#BUFFER )) && return
	if [[ $slw = (.|)(backward-|)kill-* ]]; then
	  killring=("${(@)killring[2,-1]}")
	  CUTBUFFER='$e'
	fi
	set-x-clipboard $CUTBUFFER
      }
      zle -N '${w#.}
  done
  
  zle -N push-x-selection
  zle -N push-x-cut_buffer0

  # put the current selection on the clipboard upon <Ctrl-Insert>
  # <Meta-Insert> <Ctrl-X>X or X:
  if (( $+terminfo[kSI] )); then
    bindkey -M emacs "$terminfo[kSI]" push-x-selection
    bindkey -M viins "$terminfo[kSI]" push-x-selection
    bindkey -M vicmd "$terminfo[kSI]" push-x-selection
  fi
  if (( $+terminfo[kich1] )); then
    # <Meta-Insert> according to terminfo
    bindkey -M emacs "\e$terminfo[kich1]" push-x-selection
    bindkey -M viins "\e$terminfo[kich1]" push-x-selection
    bindkey -M vicmd "\e$terminfo[kich1]" push-x-selection
  fi
  # hardcode ^[[2;3~ which is sent by <Meta-Insert> on xterm
  bindkey -M emacs '\e[2;3~' push-x-selection
  bindkey -M viins '\e[2;3~' push-x-selection
  bindkey -M vicmd '\e[2;3~' push-x-selection
  # hardcode ^[^[[2;5~ which is sent by <Meta-Insert> on some terminals
  bindkey -M emacs '\e\e[2~' push-x-selection
  bindkey -M viins '\e\e[2~' push-x-selection
  bindkey -M vicmd '\e\e[2~' push-x-selection

  # hardcode ^[[2;5~ which is sent by <Ctrl-Insert> on xterm
  # some terminals have already such a feature builtin (gnome/KDE
  # terminals), others have no distinguishable character sequence sent
  # by <Ctrl-Insert>
  bindkey -M emacs '\e[2;5~' push-x-selection
  bindkey -M viins '\e[2;5~' push-x-selection
  bindkey -M vicmd '\e[2;5~' push-x-selection

  # same for rxvt:
  bindkey -M emacs '\e[2^' push-x-selection
  bindkey -M viins '\e[2^' push-x-selection
  bindkey -M vicmd '\e[2^' push-x-selection

  # for terminals without an insert key:
  bindkey -M vicmd X push-x-selection
  bindkey -M emacs '^XX' push-x-selection

  # the convoluted stuff below is to work around two problems:
  #  1- we can't just redefine the widgets as then yank-pop would
  #  stop working
  #  2- we can't just rebind the keys to <Ctrl-Insert><other-key> as
  #  then we'll loose the numeric argument
  propagate-numeric() {
    # next key (\e[0-dum) is mapped to <Ctrl-Insert>, plus the
    # targeted widget with NUMERIC restored.
    case $KEYMAP in
      vicmd)
	bindkey -M vicmd -s '\e[0-dum' $'\e[1-dum'$NUMERIC${KEYS/x/};;
      *)
	bindkey -M $KEYMAP -s '\e[0-dum' $'\e[1-dum'${NUMERIC//(#m)?/$'\e'$MATCH}${KEYS/x/};;
    esac
  }
  zle -N get-x-clipboard
  zle -N propagate-numeric
  bindkey -M emacs '\e[1-dum' get-x-clipboard
  bindkey -M vicmd '\e[1-dum' get-x-clipboard
  bindkey -M emacs '\e[2-dum' yank
  bindkey -M emacs '\e[2-xdum' propagate-numeric
  bindkey -M emacs -s '^Y' $'\e[2-xdum\e[0-dum'
  bindkey -M vicmd '\e[3-dum' vi-put-before
  bindkey -M vicmd '\e[3-xdum' propagate-numeric
  bindkey -M vicmd -s 'P' $'\e[3-xdum\e[0-dum'
  bindkey -M vicmd '\e[4-dum' vi-put-after
  bindkey -M vicmd '\e[4-xdum' propagate-numeric
  bindkey -M vicmd -s 'p' $'\e[4-xdum\e[0-dum'
fi


# MOUSE FUNCTIONS

zle-update-mouse-driver() {
  # default is no mouse support
  [[ -n $ZLE_USE_MOUSE ]] && zle-error 'Sorry: mouse not supported'
  ZLE_USE_MOUSE=
}


if [[ $TERM = *[xeEk]term* ||
      $TERM = *mlterm* ||
      $TERM = *rxvt* ||
      $TERM = *screen* ||
      ($TERM = *linux* && -S /dev/gpmctl)
   ]]; then

  set-status() { return $1; }

  handle-mouse-event() {
    emulate -L zsh
    local bt=$1

    case $bt in
      3)
	return 0;; # Process on press, discard release
	# mlterm sends 3 on mouse-wheel-up but also on every button
	# release, so it's unusable
      64)
	# eterm, rxvt, gnome/KDE terminal mouse wheel
	zle up-line-or-history
	return;;
      4|65)
	# mlterm or eterm, rxvt, gnome/KDE terminal mouse wheel
	zle down-line-or-history
	return;;
    esac
    local mx=$2 my=$3 last_status=$4
    local cx cy i
    setopt extendedglob

    print -n '\e[6n' # query cursor position

    local match mbegin mend buf=

    while read -k i && buf+=$i && [[ $buf != *\[([0-9]##)\;[0-9]##R ]]; do :; done
    # read response from terminal.
    # note that we may also get a mouse tracking btn-release event,
    # which would then be discarded.

    [[ $buf = (#b)*\[([0-9]##)\;[0-9]##R ]] || return
    cy=$match[1] # we don't need cx

    local cur_prompt

    # trying to guess the current prompt
    case $CONTEXT in
      (vared)
        if [[ $0 = zcalc ]]; then
	  cur_prompt=${ZCALCPROMPT-'%1v> '}
	  setopt nopromptsubst nopromptbang promptpercent
	  # (ZCALCPROMPT is expanded with (%))
	fi;;
	# if vared is passed a prompt, we're lost
      (select)
        cur_prompt=$PS3;;
      (cont)
	cur_prompt=$PS2;;
      (start)
	cur_prompt=$PS1;;
    esac

    # if promptsubst, then we need first to do the expansions (to
    # be able to remove the visual effects) and disable further
    # expansions
    [[ -o promptsubst ]] && cur_prompt=${${(e)cur_prompt}//(#b)([\\\$\`])/\\$match}

    # restore the exit status in case $PS<n> relies on it
    set-status $last_status

    # remove the visual effects and do the prompt expansion
    cur_prompt=${(S%%)cur_prompt//(#b)(%([BSUbsu]|{*%})|(%[^BSUbsu{}]))/$match[3]}

    # we're now looping over the whole editing buffer (plus the last
    # line of the prompt) to compute the (x,y) position of each char. We
    # store the characters i for which x(i) <= mx < x(i+1) for every
    # value of y in the pos array. We also get the Y(CURSOR), so that at
    # the end, we're able to say which pos element is the right one
    
    local -a pos # array holding the possible positions of
		 # the mouse pointer
    local -i n x=0 y=1 cursor=$((${#cur_prompt}+$CURSOR+1))
    local Y

    buf=$cur_prompt$BUFFER
    for ((i=1; i<=$#buf; i++)); do
      (( i == cursor )) && Y=$y
      n=0
      case $buf[i] in
	($'\n') # newline
	  : ${pos[y]=$i}
	  (( y++, x=0 ));;
	($'\t') # tab advance til next tab stop
	  (( x = x/8*8+8 ));;
	([$'\0'-$'\037'$'\200'-$'\237'])
	  # characters like ^M
	  n=2;;
	(*)
	  n=1;;
      esac
      while
	(( x >= mx )) && : ${pos[y]=$i}
	(( x >= COLUMNS )) && (( x=0, y++ ))
	(( n > 0 ))
      do
	(( x++, n-- ))
      done
    done
    : ${pos[y]=$i} ${Y:=$y}

    local mouse_CURSOR
    if ((my + Y - cy > y)); then
      mouse_CURSOR=$#BUFFER
    elif ((my + Y - cy < 1)); then
      mouse_CURSOR=0
    else
      mouse_CURSOR=$(($pos[my + Y - cy] - ${#cur_prompt} - 1))
    fi

    case $bt in
      (0)
	# Button 1.  Move cursor.
	CURSOR=$mouse_CURSOR
      ;;

      (1)
	# Button 2.  Insert selection at mouse cursor postion.
	get-x-clipboard
	BUFFER=$BUFFER[1,mouse_CURSOR]$CUTBUFFER$BUFFER[mouse_CURSOR+1,-1]
	(( CURSOR = $mouse_CURSOR + $#CUTBUFFER ))
      ;;

      (2)
	# Button 3.  Copy from cursor to mouse to cutbuffer.
	killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
	if (( mouse_CURSOR < CURSOR )); then
	  CUTBUFFER=$BUFFER[mouse_CURSOR+1,CURSOR+1]
	else
	  CUTBUFFER=$BUFFER[CURSOR+1,mouse_CURSOR+1]
	fi
	set-x-clipboard $CUTBUFFER
      ;;
    esac
  }
  
  zle -N handle-mouse-event

  handle-xterm-mouse-event() {
    local last_status=$?
    emulate -L zsh
    local bt mx my
    
    # either xterm mouse tracking or bound xterm event
    # read the event from the terminal
    read -k bt # mouse button, x, y reported after \e[M
    bt=$((#bt & 0x47))
    read -k mx
    read -k my
    if [[ $mx = $'\030' ]]; then
      # assume event is \E[M<btn>dired-button()(^X\EG<x><y>)
      read -k mx
      read -k mx
      read -k my
      (( my = #my - 31 ))
      (( mx = #mx - 31 ))
    else
      # that's a VT200 mouse tracking event
      (( my = #my - 32 ))
      (( mx = #mx - 32 ))
    fi
    handle-mouse-event $bt $mx $my $last_status
  }

  zle -N handle-xterm-mouse-event

  if [[ $TERM = *linux* && -S /dev/gpmctl ]]; then
    # GPM mouse support
    if zmodload -i zsh/net/socket; then

      zle-update-mouse-driver() {
	if [[ -n $ZLE_USE_MOUSE ]]; then
	  if (( ! $+ZSH_GPM_FD )); then
	    if zsocket -d 9 /dev/gpmctl; then
	      ZSH_GPM_FD=$REPLY
	      # gpm initialisation:
	      # request single click events with given modifiers
	      local -A modifiers
	      modifiers=(
	        none        0
		shift       1
		altgr       2
		ctrl        4
		alt         8
		left-shift  16
		right-shift 32
		left-ctrl   64
		right-ctrl  128
		caps-shift  256
	      )
	      local min max
	      # modifiers that need to be on
	      min=$((modifiers[none]))
	      # modifiers that may be on
	      max=$min

	      # send 16 bytes:
	      #   1-2: LE short: requested events (btn down = 0x0004)
	      #   3-4: LE short: event passed through (~GPM_HARD=0xFEFF)
	      #   5-6: LE short: min modifiers
	      #   7-8: LE short: max modifiers
	      #  9-12: LE int: pid
	      # 13-16: LE int: virtual console number

	      print -u$ZSH_GPM_FD -n "\4\0\377\376\\$(([##8]min&255
	      ))\\$(([##8]min>>8))\\$(([##8]max&255))\\$(([##8]max>>8
	      ))\\$(([##8]$$&255))\\$(([##8]$$>>8&255))\\$((
	      [##8]$$>>16&255))\\$(( [##8]$$>>24))\\$((
	      [##8]${TTY#/dev/tty}))\0\0\0"
	      zle -F $ZSH_GPM_FD handle-gpm-mouse-event
            else
	      zle-error 'Error: unable to connect to GPM'
	      ZLE_USE_MOUSE=
	    fi
	  fi
	else
	  # ZLE_USE_MOUSE disabled, close GPM connection
	  if (( $+ZSH_GPM_FD )); then
	    eval "exec $ZSH_GPM_FD>&-"
	    # what if $ZSH_GPM_FD > 9 ?
	    zle -F $ZSH_GPM_FD # remove the handler
	    unset ZSH_GPM_FD
	  fi
	fi
      }

      handle-gpm-mouse-event() {
	local last_status=$?
	local event i
	if read -u$1 -k28 event; then
	  local buttons x y
	  (( buttons = ##$event[1] ))
	  (( x = ##$event[9] + ##$event[10] << 8 ))
	  (( y = ##$event[11] + ##$event[12] << 8 ))
	  zle handle-mouse-event $(( (5 - (buttons & -buttons)) / 2 )) $x $y $last_status
	  zle -R # redraw buffer
	else
	  zle -M 'Error: connection to GPM lost'
	  ZLE_USE_MOUSE=
	  zle-update-mouse-driver
	fi
      }
    fi 
  else
    # xterm-like mouse support
    zmodload -i zsh/parameter # needed for $functions

    zle-update-mouse-driver() {
      if [[ -n $WIDGET ]]; then
	if [[ -n $ZLE_USE_MOUSE ]]; then
	  print -n '\e[?1000h'
	else
	  print -n '\e[?1000l'
	fi
      fi
    }

    if [[ $functions[precmd] != *ZLE_USE_MOUSE* ]]; then
      functions[precmd]+='
      [[ -n $ZLE_USE_MOUSE ]] && print -n '\''\e[?1000h'\'
    fi
    if [[ $functions[preexec] != *ZLE_USE_MOUSE* ]]; then
      functions[preexec]+='
      [[ -n $ZLE_USE_MOUSE ]] && print -n '\''\e[?1000l'\'
    fi

    bindkey -M emacs '\e[M' handle-xterm-mouse-event
    bindkey -M viins '\e[M' handle-xterm-mouse-event
    bindkey -M vicmd '\e[M' handle-xterm-mouse-event

    if [[ $TERM = *Eterm* ]]; then
      # Eterm sends \e[5Mxxxxx on drag events, be want to discard them
      discard-mouse-drag() {
        local junk
        read -k5 junk
      }
      zle -N discard-mouse-drag
      bindkey -M emacs '\e[5M' discard-mouse-drag
      bindkey -M viins '\e[5M' discard-mouse-drag
      bindkey -M vicmd '\e[5M' discard-mouse-drag
    fi
  fi

fi

zle-toggle-mouse() {
  # If no prefix, toggle state.
  # If positive prefix, turn on.
  # If zero or negative prefix, turn off.

  # Allow this to be used as a normal function, too.
  if [[ -n $1 ]]; then
    local PREFIX=$1
  fi
  if (( $+PREFIX )); then
    if (( PREFIX > 0 )); then
      ZLE_USE_MOUSE=1
    else
      ZLE_USE_MOUSE=
    fi
  else
    if [[ -n $ZLE_USE_MOUSE ]]; then
      ZLE_USE_MOUSE=
    else
      ZLE_USE_MOUSE=1
    fi
  fi
  zle-update-mouse-driver
}
zle -N zle-toggle-mouse
