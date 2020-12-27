# Sublime Text aliases

alias st=subl
alias stt='subl .'

# Define sst only if sudo exists
(( $+commands[sudo] )) && alias sst='sudo subl'

alias stp=find_project
alias stn=create_project


# Search for the Sublime Text command if not found
(( $+commands[subl] )) || {
  declare -a _sublime_paths

  if [[ "$OSTYPE" == linux* ]]; then
    if [[ "$(uname -r)" = *icrosoft* ]]; then
      _sublime_paths=(
        "$(wslpath -u 'C:\Program Files\Sublime Text 3\subl.exe' 2>/dev/null)"
        "$(wslpath -u 'C:\Program Files\Sublime Text 2\subl.exe' 2>/dev/null)"
      )
    else
      _sublime_paths=(
        "$HOME/bin/sublime_text"
        "/opt/sublime_text/sublime_text"
        "/opt/sublime_text_3/sublime_text"
        "/usr/bin/sublime_text"
        "/usr/local/bin/sublime_text"
        "/usr/bin/subl"
        "/usr/bin/subl3"
        "/snap/bin/subl"
        "/snap/bin/sublime-text.subl"
      )
    fi
  elif [[ "$OSTYPE" = darwin* ]]; then
    _sublime_paths=(
      "/usr/local/bin/subl"
      "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
      "/Applications/Sublime Text 4.app/Contents/SharedSupport/bin/subl"
      "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
      "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
      "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
      "$HOME/Applications/Sublime Text 4.app/Contents/SharedSupport/bin/subl"
      "$HOME/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
      "$HOME/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
    )
  elif [[ "$OSTYPE" = cygwin ]]; then
    _sublime_paths=(
      "$(cygpath "$ProgramW6432/Sublime Text 2")/subl.exe"
      "$(cygpath "$ProgramW6432/Sublime Text 3")/subl.exe"
    )
  elif [[ "$OSTYPE" = msys ]]; then
    _sublime_paths=(
      "/c/Program Files/Sublime Text 2/subl.exe"
      "/c/Program Files/Sublime Text 3/subl.exe"
    )
  fi

  for _sublime_path in $_sublime_paths; do
    if [[ -a $_sublime_path ]]; then
      alias subl="'$_sublime_path'"
      (( $+commands[sudo] )) && alias sst="sudo '$_sublime_path'"
      break
    fi
  done

  unset _sublime_paths _sublime_path
}

function find_project() {
  local PROJECT_ROOT="${PWD}"
  local FINAL_DEST="."

  while [[ $PROJECT_ROOT != "/" && ! -d "$PROJECT_ROOT/.git" ]]; do
    PROJECT_ROOT=$(dirname $PROJECT_ROOT)
  done

  if [[ $PROJECT_ROOT != "/" ]]; then
    local PROJECT_NAME="${PROJECT_ROOT##*/}"

    local SUBL_DIR=$PROJECT_ROOT
    while [[ $SUBL_DIR != "/" && ! -f "$SUBL_DIR/$PROJECT_NAME.sublime-project" ]]; do
      SUBL_DIR=$(dirname $SUBL_DIR)
    done

    if [[ $SUBL_DIR != "/" ]]; then
      FINAL_DEST="$SUBL_DIR/$PROJECT_NAME.sublime-project"
    else
      FINAL_DEST=$PROJECT_ROOT
    fi
  fi

  subl $FINAL_DEST
}

function create_project() {
  local _target=$1

  if [[ "${_target}" == "" ]]; then
    _target=$(pwd);
  elif [[ ! -d ${_target} ]]; then
    echo "${_target} is not a valid directory"
    return 1
  fi

  local _sublime_project_file=$_target/$(basename $_target).sublime-project

  if [[ ! -f $_sublime_project_file ]]; then
    touch $_sublime_project_file

    echo -e "{"                         >> $_sublime_project_file
    echo -e "\t\"folders\":"            >> $_sublime_project_file
    echo -e "\t\t[{"                    >> $_sublime_project_file
    echo -e "\t\t\t\"path\": \".\","    >> $_sublime_project_file
    echo -e "\t\t\t\"file_exclude_patterns\": []" >> $_sublime_project_file
    echo -e "\t\t}]"                    >> $_sublime_project_file
    echo -e "}"                         >> $_sublime_project_file

    echo -e "New Sublime Text project created:\n\t${_sublime_project_file}"
  fi
}
