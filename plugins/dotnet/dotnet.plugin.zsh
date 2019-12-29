# --------------------------------------------------------------------- #
# Aliases and Completions for .NET Core (https://dotnet.microsoft.com/) #
# Author: Shaun Tabone (https://github.com/xontab)                      #
# --------------------------------------------------------------------- #

# Helper function to cache and load completions
local cache_base_path="${ZSH_CACHE_DIR}/dotnet_"
_dotnet_cache_completion() {
    local cache="${cache_base_path}$(echo $1)_completion"
    if [[ ! -f $cache ]]; then
        $2 $cache
    fi

    [[ -f $cache ]] && cat $cache
}

_dotnet_cache_completion_cleanup() {
    local cache="${cache_base_path}$(echo $1)_completion"
    rm -f $cache
}

# --------------------------------------------------------------------- #
# dotnet new                                                            #
# ALIAS: dn                                                             #
# --------------------------------------------------------------------- #
_dotnet_new_completion() {
    if [ $commands[dotnet] ]; then
        dotnet new -l | tail -n +21 | sed 's/  \+/:/g' | cut -d : -f 2 >$1
    fi
}

_dotnet_new_completion_cached() {
    _dotnet_cache_completion 'new' _dotnet_new_completion
}

_dotnet_cache_completion_cleanup 'new'

alias dn='dotnet new'

# --------------------------------------------------------------------- #
# dotnet                                                                #
# --------------------------------------------------------------------- #
_dotnet() {
    if [ $CURRENT -eq 2 ]; then
        _arguments \
            '--diagnostics[Enable diagnostic output.]' \
            '--help[Show command line help.]' \
            '--info[Display .NET Core information.]' \
            '--list-runtimes[Display the installed runtimes.]' \
            '--list-sdks[Display the installed SDKs.]' \
            '--version[Display .NET Core SDK version in use.]'

        _values \
            'add[Add a package or reference to a .NET project.]' \
            'build[Build a .NET project.]' \
            'build-server[Interact with servers started by a build.]' \
            'clean[Clean build outputs of a .NET project.]' \
            'help[Show command line help.]' \
            'list[List project references of a .NET project.]' \
            'msbuild[Run Microsoft Build Engine (MSBuild) commands.]' \
            'new[Create a new .NET project or file.]' \
            'nuget[Provides additional NuGet commands.]' \
            'pack[Create a NuGet package.]' \
            'publish[Publish a .NET project for deployment.]' \
            'remove[Remove a package or reference from a .NET project.]' \
            'restore[Restore dependencies specified in a .NET project.]' \
            'run[Build and run a .NET project output.]' \
            'sln[Modify Visual Studio solution files.]' \
            'store[Store the specified assemblies in the runtime package store.]' \
            'test[Run unit tests using the test runner specified in a .NET project.]' \
            'tool[Install or manage tools that extend the .NET experience.]' \
            'vstest[Run Microsoft Test Engine (VSTest) commands.]' \
            'dev-certs[Create and manage development certificates.]' \
            'fsi[Start F# Interactive / execute F# scripts.]' \
            'sql-cache[SQL Server cache command-line tools.]' \
            'user-secrets[Manage development user secrets.]' \
            'watch[Start a file watcher that runs a command when files change.]'
        return
    fi

    if [ $CURRENT -eq 3 ]; then
        case ${words[2]} in
        "new")
            compadd -X ".NET Installed Templates" $(_dotnet_new_completion_cached)
            return
            ;;
        "sln")
            _values \
                'add[Add one or more projects to a solution file.]' \
                'list[List all projects in a solution file.]' \
                'remove[Remove one or more projects from a solution file.]'
            return
            ;;
        "nuget")
            _values \
                'delete[Deletes a package from the server.]' \
                'locals[Clears or lists local NuGet resources such as http requests cache, packages folder, plugin operations cache  or machine-wide global packages folder.]' \
                'push[Pushes a package to the server and publishes it.]'
            return
            ;;
        esac
    fi

    _arguments '*::arguments: _normal'
}

compdef _dotnet dotnet

# --------------------------------------------------------------------- #
# Other Aliases                                                         #
# --------------------------------------------------------------------- #
alias dr='dotnet run'
alias dt='dotnet test'
alias ds='dotnet sln'
alias da='dotnet add'
alias dp='dotnet pack'
alias dng='dotnet nuget'
