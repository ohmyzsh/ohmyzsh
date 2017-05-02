# Completion for bem command
# Автодополнение для команды bem
eval "$(bem completion 2> /dev/null)"

# If we have bem in our project run them, otherwise run global bem
# Если у нас есть установленный bem в папке с проектом, то запустим его
# иначе - глобальный bem
whichBem() {
    bemPath="$1/node_modules/.bin/bem"
    if [ -f ${bemPath} ]
    then
        echo ${bemPath}
    else
        if [ $1='/' ]
        then
            echo $(which bem)
        else
            parent=$(dirname $1)

            echo $(whichBem $parent)
        fi
    fi
}

bem() {
    bemCmd=$(whichBem $PWD)
    if [ -f ${bemCmd} ]
    then
        bemCmd="${bemCmd} $@"
        eval ${bemCmd}
    fi
}

