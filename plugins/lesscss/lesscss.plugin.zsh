# basics taken from here:
# http://www.ravelrumba.com/blog/watch-compile-less-command-line/comment-page-1/#comment-2464
# Requires watchr: https://github.com/mynyml/watchr

watchless () {
    compressed=0
    compile=""
    
    while getopts ":xc:h" option
    do
      case $option in
        x ) compressed=1 ;;
        c ) compile=$OPTARG ;;
        h ) _watchless_usage; return ;;
      esac
    done
    
    if [ $compressed -eq 1 ]; then
        x=' -x'
    else
        x=''
    fi
    
    if [ -n "$compile" ]; then
        if [ ! -e $compile ]; then
            echo "\033[337;41m\n$compile doesn't exist!\n\033[0m"
            return
        fi
        
        name=$(echo $compile | cut -d . -f 1)
        
        watchr -e 'watch(".*\.less$") { |f| system("lessc '$name'.less > '$name'.css'$x' && echo \"'$name'.less > '$name'.css\" ") }'
    else
        watchr -e 'watch(".*\.less$") { |f| system("lessc #{f[0]} > $(echo #{f[0]} | cut -d\. -f1).css'$x' && echo \"#{f[0]} > $(echo #{f[0]} | cut -d\. -f1).css\" ") }'
    fi
}

_watchless_usage () {
    echo "Usage: watchless [options]"
    echo
    echo "Options"
    echo "  -x   Compiles less files into minified css files"
    echo "  -c   Watch all files but compile only the one given here"
    echo "  -h   Get this help message"
    return
}
