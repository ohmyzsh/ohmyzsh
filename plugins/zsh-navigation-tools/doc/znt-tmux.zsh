#!/usr/bin/env zsh

# Copyright (c) 2016, Zsolt Lengyel
# Modifications copyright (c) 2016, Sebastian Gniazdowski

#
# This script opens a new, temporary tmux pane and runs n-history. When
# a selection is made, the result (history entry) is pasted back into
# original tmux pane, and the temporary pane is closed. This allows to
# use local history on remote machines.
#
# To use, put this line to your ~/.tmux.conf. The tool is invoked with:
# Ctrl+b h
#
# bind h run-shell -b "$ZNT_REPO_DIR/doc/znt-tmux.zsh"
#

# get and save the current active tmux pane id
active_pane=$(tmux display -p -F ':#{session_id}:#I:#P:#{pane_active}:#{window_active}:#{session_attached}' )
a_active_pane=("${(@s/:/)active_pane}")

active_session=${a_active_pane[2]//$}
active_window=$a_active_pane[3]
active_pane=$a_active_pane[4]

# set variables for upcoming window
tmux setenv -t $active_session:$active_window.$active_pane "ZNT_TMUX_MODE" 1
tmux setenv -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_SESSION" "$active_session"
tmux setenv -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_WINDOW" "$active_window"
tmux setenv -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_PANE" "$active_pane"

# create a new window in the active session and call it znt-hist
tmux new-window -t $active_session: -n znt-hist

# unset the variables, so only above single window has them
tmux setenv -u -t $active_session:$active_window.$active_pane "ZNT_TMUX_MODE"
tmux setenv -u -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_SESSION"
tmux setenv -u -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_WINDOW"
tmux setenv -u -t $active_session:$active_window.$active_pane "ZNT_TMUX_ORIGIN_PANE"

# znt's session id
znt_active_pane=$(tmux display -p -F ':#{session_id}:#I:#P:#{pane_active}:#{window_active}:#{session_attached}' )
znt_a_active_pane=("${(@s/:/)znt_active_pane}")

znt_active_session=${znt_a_active_pane[2]//$}
znt_active_window=$znt_a_active_pane[3]
znt_active_pane=$znt_a_active_pane[4]

# call znt
tmux send -t "$znt_active_session:$znt_active_window.$znt_active_pane" n-history ENTER
