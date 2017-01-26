#compdef geeknote
# --------------- ------------------------------------------------------------
#           Name : _geeknote
#       Synopsis : zsh completion for geeknote
#         Author : Ján Koščo <3k.stanley@gmail.com>
#       HomePage : http://www.geeknote.me
#        Version : 0.1
#            Tag : [ shell, zsh, completion, evernote ]
#      Copyright : © 2014 by Ján Koščo,
#                  Released under current GPL license.
# --------------- ------------------------------------------------------------

local -a _1st_arguments
_1st_arguments=(
  'login'
  'logout'
  'settings'
  'create'
  'edit'
  'find'
  'show'
  'remove'
  'notebook-list'
  'notebook-create'
  'notebook-edit'
  'tag-list'
  'tag-create'
  'tag-edit'
  'tag-remove'
  'gnsync'
  'user'
)

_arguments '*:: :->command'

if (( CURRENT == 1 )); then
  _describe -t commands "geeknote command" _1st_arguments
  return
fi

local -a _command_args
case "$words[1]" in
  user)
    _command_args=(
      '(--full)--full' \
    )
    ;;
  logout)
    _command_args=(
      '(--force)--force' \
    )
    ;;
  settings)
    _command_args=(
      '(--editor)--editor' \
    )
    ;;
  create)
    _command_args=(
      '(-t|--title)'{-t,--title}'[note title]' \
      '(-c|--content)'{-c,--content}'[note content]' \
      '(-tg|--tags)'{-tg,--tags}'[one tag or the list of tags which will be added to the note]' \
      '(-nb|--notebook)'{-nb,--notebook}'[name of notebook where to save note]' \
    )
    ;;
  edit)
    _command_args=(
      '(-n|--note)'{-n,--note}'[name or ID from the previous search of a note to edit]' \
      '(-t|--title)'{-t,--title}'[note title]' \
      '(-c|--content)'{-c,--content}'[note content]' \
      '(-tg|--tags)'{-tg,--tags}'[one tag or the list of tags which will be added to the note]' \
      '(-nb|--notebook)'{-nb,--notebook}'[name of notebook where to save note]' \
    )
    ;;
  remove)
    _command_args=(
      '(-n|--note)'{-n,--note}'[name or ID from the previous search of a note to edit]' \
      '(--force)--force' \
    )
    ;;
  show)
    _command_args=(
      '(-n|--note)'{-n,--note}'[name or ID from the previous search of a note to edit]' \
    )
    ;;
  find)
    _command_args=(
      '(-s|--search)'{-s,--search}'[text to search]' \
      '(-tg|--tags)'{-tg,--tags}'[notes with which tag/tags to search]' \
      '(-nb|--notebook)'{-nb,--notebook}'[in which notebook search the note]' \
      '(-d|--date)'{-d,--date}'[date in format dd.mm.yyyy or date range dd.mm.yyyy-dd.mm.yyyy]' \
      '(-cn|--count)'{-cn,--count}'[how many notes show in the result list]' \
      '(-uo|--url-only)'{-uo,--url-only}'[add direct url of each note in results to Evernote web-version]' \
      '(-ee|--exact-entry)'{-ee,--exact-entry}'[search for exact entry of the request]' \
      '(-cs|--content-search)'{-cs,--content-search}'[search by content, not by title]' \
    )
    ;;
  notebook-create)
    _command_args=(
      '(-t|--title)'{-t,--title}'[notebook title]' \
    )
    ;;
  notebook-edit)
    _command_args=(
      '(-nb|--notebook)'{-nb,--notebook}'[name of notebook to rename]' \
      '(-t|--title)'{-t,--title}'[new notebook title]' \
    )
    ;;
  notebook-remove)
    _command_args=(
      '(-nb|--notebook)'{-nb,--notebook}'[name of notebook to remove]' \
      '(--force)--force' \
    )
    ;;
  tag-create)
    _command_args=(
      '(-t|--title)'{-t,--title}'[title of tag]' \
    )
    ;;
  tag-edit)
    _command_args=(
      '(-tgn|--tagname)'{-tgn,--tagname}'[tag to edit]' \
      '(-t|--title)'{-t,--title}'[new tag name]' \
    )
    ;;
  tag-remove)
    _command_args=(
      '(-tgn|--tagname)'{-tgn,--tagname}'[tag to remove]' \
      '(--force)--force' \
    )
    ;;
  esac

_arguments \
  $_command_args \
  &&  return 0
