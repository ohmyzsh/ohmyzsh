# Sublime Text 2 Aliases

if [[ "$OSTYPE" == 'linux-gnu' ]]; then
    local _sublime_linux_paths > /dev/null 2>&1
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
    local _sublime_darwin_paths > /dev/null 2>&1
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

elif  [[ "$OSTYPE" == cygwin ]]; then
    local cygprogfiles=""
    cygprogfiles=$(cygpath "$PROGRAMFILES")
    local cygprogfiles_x86=""
    cygprogfiles_x86=$(cmd /c "echo %ProgramFiles(x86)%")
    cygprogfiles_x86=${cygprogfiles_x86/[\\r\\n]//}
    cygprogfiles_x86=$(cygpath "$cygprogfiles_x86")
    local _sublime_cygwin_paths > /dev/null 2>&1
    _sublime_cygwin_paths=(
        "$cygprogfiles/Sublime Text 2/sublime_text.exe"
        "$cygprogfiles/Sublime Text 3/sublime_text.exe"
        "$cygprogfiles_x86/Sublime Text 2/sublime_text.exe"
        "$cygprogfiles_x86/Sublime Text 3/sublime_text.exe"
    )

    IFS=$'\n'
    for _sublime_path in $_sublime_cygwin_paths; do
        if [[ -a $_sublime_path ]]; then
            subl() { "$_sublime_path" $(cygpath -aw $*) }
            alias st=subl
            break
        fi
    done
fi

alias stt='st .'
