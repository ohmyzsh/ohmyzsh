_enumerateGrailsScripts() {
    # Default directoryies
    directories=($GRAILS_HOME/scripts ~/.grails/scripts ./scripts)

    # Check all of the plugins directories, if they exist
    if [ -d plugins ]
    then
        directories+=(plugins/*/scripts)
    fi
    
    # Enumerate all of the Groovy files
    files=()
    for dir in $directories;
    do
        if [ -d $dir ]
        then
            files+=($dir/[^_]*.groovy)
        fi
    done
    
    # Don't try to basename ()
    if [ ${#files} -eq 0 ];
    then
        return
    fi
    
    # - Strip the path
    # - Remove all scripts with a leading '_'
    # - PackagePlugin_.groovy -> PackagePlugin
    # - PackagePlugin         -> Package-Plugin
    # - Package-Plugin        -> package-plugin
    basename $files                             \
        | sed -E  -e 's/^_?([^_]+)_?.groovy/\1/'\
                  -e 's/([a-z])([A-Z])/\1-\2/g' \
        | tr "[:upper:]" "[:lower:]"            \
        | sort                                  \
        | uniq
}
 
_grails() {
    if (( CURRENT == 2 )); then
        scripts=( $(_enumerateGrailsScripts) )
        
        if [ ${#scripts} -ne 0 ];
        then
            _multi_parts / scripts
            return
        fi
    fi
    
    _files
}
 
compdef _grails grails
