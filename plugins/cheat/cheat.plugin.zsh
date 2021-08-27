#functions
cheat(){
    if command -v curl &> /dev/null
    then
        curl cheat.sh/$1
        return 0
    fi
    
    if command -v wget &> /dev/null
    then
        wget -O - cheat.sh/$1
        return 0 
    fi

    if command -v w3m &> /dev/null
    then
        w3m -dump cheat.sh/$1
        return 0
    fi

    if command -v lynx &> /dev/null
    then
        lynx -dump cheat.sh/$1
        return 0
    fi
    
    echo "cheat requires curl, wget, w3m or lynx"
    return 127
}
