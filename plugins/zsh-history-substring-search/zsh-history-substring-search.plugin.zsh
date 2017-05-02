#!/usr/bin/env zsh 
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2011 Guido van Steen 
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the FIZSH nor the names of its contributors may be used to endorse or
#    promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*- 
# vim: ft=zsh sw=2 ts=2 et 
# 
# This script can also be used as the widget zsh-history-substring-search-forward 
# 
# original version by Peter Stephenson (2009) 
# He called his version "history-substring-search-backward" 
# http://www.zsh.org/mla/users/2009/msg00818.html 
# 
# modifications by Guido van Steen (2009-2011) 
# written as a part of the Friendly Interactive ZSHell (fizsh) 
# http://sourceforge.net/projects/fizsh/ 
# 
# /etc/fizsh/zsh-history-substring-search-backward 
# 

F_ordinary_highlight="bg=magenta,fg=white,bold" 
F_out_of_matches_highlight="bg=red,fg=white,bold" 
F_max_buffer_size=250000

zsh-history-substring-search-backward() { 

  emulate -L zsh 

  setopt extendedglob 

  zmodload -i zsh/parameter 

  F_zsh_highlighting_available=0 
  (( $+functions[_zsh_highlight-zle-buffer] )) && F_zsh_highlighting_available=1 
  # check if _zsh_highlight-zle-buffer is available  
  # so that calls to this function will not fail. 

  if [[ ! (  ( ${WIDGET/backward/forward} = ${LASTWIDGET/backward/forward}) || 
    ( ${WIDGET/forward/backward} = ${LASTWIDGET/forward/backward}) ) ]]; then 
    # set the type of highlighting 
    F_search=${BUFFER//(#m)[\][()\\*?#<>~^]/\\$MATCH} 
	echo $WIDGET >> /tmp/ok2
    # $BUFFER contains the text that is in the command-line currently. 
    # we put an extra "\\" before meta characters such as "\(" and "\)", 
    # so that they become "\\\|" and "\\\(" 
    F_search4later=${BUFFER} 
    # for the purpose of highlighting we will also keep a version without 
    # doubly-escaped meta characters  
    F_matches=(${(kon)history[(R)*${F_search}*]}) 
    # find all occurrences of the pattern *${seach}* within the history file 
    # (k) turns it an array of line numbers. (on) seems to remove duplicates. 
    # (on) are default options. they can be turned off by (ON). 
    F_number_of_matches=${#F_matches} 
    let "F_number_of_matches_plus_one = $F_number_of_matches + 1" 
    # define the range of value that $F_match_number can take: 
    # [0, $F_number_of_matches_plus_one] 
    let "F_number_of_matches_minus_one = $F_number_of_matches - 1" 
    # handy for later 
    let "F_match_number = $F_number_of_matches_plus_one" 
    # initial value of $F_match_number, which can initially only be decreased by 
    # ${WIDGET/forward/backward} 
  fi 

  if [[ $WIDGET = *backward* ]]; then # we have pressed arrow-up 
    if [[ ($F_match_number -ge 2 && $F_match_number -le $F_number_of_matches_plus_one) ]]; then 
      let "F_match_number = $F_match_number - 1" 
      F_command_to_be_retrieved=$(fc -ln $F_matches[$F_match_number] $F_matches[$F_match_number]) 
      F_command_to_be_retrieved=${F_command_to_be_retrieved//\\"n"/$'\n'}
      F_command_to_be_retrieved=${F_command_to_be_retrieved//\\"t"/$'\t'}
      # expand newlines and tabs in multi-line commands 
      BUFFER=$F_command_to_be_retrieved 
      if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
        _zsh_highlight-zle-buffer 
      fi 
      if [[ $F_search4later != "" ]]; then # F_search string was not empty: highlight it 
        : ${(S)BUFFER##(#m)($F_search4later##)} 
        # among other things the following expression yields a variable $MEND, 
        # which indicates the end position of the first occurrence of $F_search in 
        # $BUFFER  
        let "F_my_mbegin = $MEND - $#F_search4later" 
        region_highlight=("$F_my_mbegin $MEND $F_ordinary_highlight") 
      fi 
    else 
      if [[ ($F_match_number -eq 1) ]]; then 
      # we will move out of the F_matches  
        let "F_match_number = $F_match_number - 1" 
        F_old_buffer_backward=$BUFFER 
        BUFFER=$F_search4later 
        if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
          _zsh_highlight-zle-buffer 
        fi 
        if [[ $F_search4later != "" ]]; then 
          : ${(S)BUFFER##(#m)($F_search4later##)} 
          let "F_my_mbegin = $MEND - $#F_search4later" 
          region_highlight=("$F_my_mbegin $MEND $F_out_of_matches_highlight") 
          # this is slightly more informative than highlighting 
          # that fish performs 
        fi 
      else 
        if [[ ($F_match_number -eq $F_number_of_matches_plus_one ) ]]; then 
        # we will move back to the F_matches 
          let "F_match_number = $F_match_number - 1" 
          BUFFER=$F_old_buffer_forward 
          if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
            _zsh_highlight-zle-buffer 
          fi 
          if [[ $F_search4later != "" ]]; then 
            : ${(S)BUFFER##(#m)($F_search4later##)} 
            let "F_my_mbegin = $MEND - $#F_search4later" 
            region_highlight=("$F_my_mbegin $MEND $F_ordinary_highlight")         
          fi 
        fi 
      fi 
    fi 
  else # arrow-down 
    if [[ ($F_match_number -eq $F_number_of_matches_plus_one ) ]]; then 
      let "F_match_number = $F_match_number" 
      F_old_buffer_forward=$BUFFER 
      BUFFER=$F_search4later 
      if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
        _zsh_highlight-zle-buffer 
      fi 
      if [[ $F_search4later != "" ]]; then 
        : ${(S)BUFFER##(#m)($F_search4later##)} 
        let "F_my_mbegin = $MEND - $#F_search4later" 
        region_highlight=("$F_my_mbegin $MEND $F_out_of_matches_highlight") 
      fi 
    elif [[ ($F_match_number -ge 0 && $F_match_number -le $F_number_of_matches_minus_one) ]]; then 
      let "F_match_number = $F_match_number + 1" 
      F_command_to_be_retrieved=$(fc -ln $F_matches[$F_match_number] $F_matches[$F_match_number]) 
      F_command_to_be_retrieved=${F_command_to_be_retrieved//\\"n"/$'\n'}
      F_command_to_be_retrieved=${F_command_to_be_retrieved//\\"t"/$'\t'}
      BUFFER=$F_command_to_be_retrieved 
      if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
        _zsh_highlight-zle-buffer 
      fi 
      if [[ $F_search4later != "" ]]; then 
        : ${(S)BUFFER##(#m)($F_search4later##)} 
        let "F_my_mbegin = $MEND - $#F_search4later" 
        region_highlight=("$F_my_mbegin $MEND $F_ordinary_highlight") 
      fi 
    else 
      if [[ ($F_match_number -eq $F_number_of_matches ) ]]; then 
        let "F_match_number = $F_match_number + 1" 
        F_old_buffer_forward=$BUFFER 
        BUFFER=$F_search4later 
        if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
          _zsh_highlight-zle-buffer 
        fi 
        if [[ $F_search4later != "" ]]; then 
          : ${(S)BUFFER##(#m)($F_search4later##)} 
          let "F_my_mbegin = $MEND - $#F_search4later" 
          region_highlight=("$F_my_mbegin $MEND $F_out_of_matches_highlight") 
        fi 
      else 
        if [[ ($F_match_number -eq 0 ) ]]; then 
          let "F_match_number = $F_match_number + 1" 
          BUFFER=$F_old_buffer_backward 
          if [[ ((( $F_zsh_highlighting_available == 1 ) && ( $+BUFFER < $F_max_buffer_size) )) ]]; then 
            _zsh_highlight-zle-buffer 
          fi 
          if [[ $F_search4later != "" ]]; then 
            : ${(S)BUFFER##(#m)($F_search4later##)} 
            let "F_my_mbegin = $MEND - $#F_search4later" 
            region_highlight=("$F_my_mbegin $MEND $F_ordinary_highlight") 
          fi 
        fi 
      fi 
    fi 
  fi 
  CURSOR=${#BUFFER} 
  #"zle .end-of-line" does not move CURSOR to the final end of line in multi-line buffers. 

  # for debugging purposes: 
  # zle -R "mn: "$F_match_number" m#: "${#F_matches} 
  # read -k -t 200 && zle -U $REPLY 
} 

zle -N zsh-history-substring-search-forward zsh-history-substring-search-backward 
zle -N zsh-history-substring-search-backward 
bindkey '\e[A' zsh-history-substring-search-backward 
bindkey '\e[B' zsh-history-substring-search-forward 


