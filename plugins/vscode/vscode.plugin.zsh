alias vscode='code'

#
# If the code command is called without an argument, launch VS Code
# If code is passed a directory, cd to it and open it in VS Code
# If code is passed a file, open it in VS code
#
function code {
    if [[ $# = 0 ]]
    then
        open_command -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open_command -a "Visual Studio Code" "$argPath"
    fi
}
