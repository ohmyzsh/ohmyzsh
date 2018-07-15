# Sublime Text Aliases

() {

if [[ "$OSTYPE" == linux* ]]; then
    local _sublime_linux_paths
    _sublime_linux_paths=(
        "$HOME/bin/sublime_text"
        "/opt/sublime_text/sublime_text"
        "/opt/sublime_text_3/sublime_text"
        "/usr/bin/sublime_text"
        "/usr/local/bin/sublime_text"
        "/usr/bin/subl"
        "/opt/sublime_text_3/sublime_text"
        "/usr/bin/subl3"
    )
    for _sublime_path in $_sublime_linux_paths; do
        if [[ -a $_sublime_path ]]; then
            st_run() { $_sublime_path $@ >/dev/null 2>&1 &| }
            st_run_sudo() {sudo $_sublime_path $@ >/dev/null 2>&1}
            alias sst=st_run_sudo
            alias st=st_run
            break
        fi
    done
elif  [[ "$OSTYPE" = darwin* ]]; then
    local _sublime_darwin_paths
    _sublime_darwin_paths=(
        "/usr/local/bin/subl"
        "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
        "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
        "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
        "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
        "$HOME/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
        "$HOME/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
    )
    for _sublime_path in $_sublime_darwin_paths; do
        if [[ -a $_sublime_path ]]; then
            subl () { "$_sublime_path" $* }
            alias st=subl
            break
        fi
    done
elif [[ "$OSTYPE" = 'cygwin' ]]; then
    local sublime_cygwin_paths
    sublime_cygwin_paths=(
        "$(cygpath $ProgramW6432/Sublime\ Text\ 2)/sublime_text.exe"
        "$(cygpath $ProgramW6432/Sublime\ Text\ 3)/sublime_text.exe"
    )
    for _sublime_path in $_sublime_cygwin_paths; do
        if [[ -a $_sublime_path ]]; then
            subl () { "$_sublime_path" $* }
            alias st=subl
            break
        fi
    done
fi

}

alias stt='st .'

find_project()
{
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

    st $FINAL_DEST
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

alias stp=find_project
alias stn=create_project
