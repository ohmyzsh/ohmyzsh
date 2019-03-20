#compdef swift
local context state state_descr line
typeset -A opt_args

_swift() {
    _arguments -C \
        '(- :)--help[prints the synopsis and a list of the most commonly used commands]: :->arg' \
        '(-): :->command' \
        '(-)*:: :->arg' && return

    case $state in
        (command)
            local tools
            tools=(
                'build:build sources into binary products'
                'run:build and run an executable product'
                'package:perform operations on Swift packages'
                'test:build and run tests'
            )
            _alternative \
                'tools:common:{_describe "tool" tools }' \
                'compiler: :_swift_compiler' && _ret=0
            ;;
        (arg)
            case ${words[1]} in
                (build)
                    _swift_build
                    ;;
                (run)
                    _swift_run
                    ;;
                (package)
                    _swift_package
                    ;;
                (test)
                    _swift_test
                    ;;
                (*)
                    _swift_compiler
                    ;;
            esac
            ;;
    esac
}

_swift_dependency() {
    local dependencies
    dependencies=( $(swift package completion-tool list-dependencies) )
    _describe '' dependencies
}

_swift_executable() {
    local executables
    executables=( $(swift package completion-tool list-executables) )
    _describe '' executables
}

# Generates completions for swift build
#
# In the final compdef file, set the following file header:
#
#     #compdef _swift_build
#     local context state state_descr line
#     typeset -A opt_args
_swift_build() {
    arguments=(
        "-Xcc[Pass flag through to all C compiler invocations]:Pass flag through to all C compiler invocations: "
        "-Xswiftc[Pass flag through to all Swift compiler invocations]:Pass flag through to all Swift compiler invocations: "
        "-Xlinker[Pass flag through to all linker invocations]:Pass flag through to all linker invocations: "
        "-Xcxx[Pass flag through to all C++ compiler invocations]:Pass flag through to all C++ compiler invocations: "
        "(--configuration -c)"{--configuration,-c}"[Build with configuration (debug|release) ]: :{_values '' 'debug[build with DEBUG configuration]' 'release[build with RELEASE configuration]'}"
        "--build-path[Specify build/cache directory ]:Specify build/cache directory :_files"
        "(--chdir -C)"{--chdir,-C}"[]: :_files"
        "--package-path[Change working directory before any other operation]:Change working directory before any other operation:_files"
        "--sanitize[Turn on runtime checks for erroneous behavior]: :{_values '' 'address[enable Address sanitizer]' 'thread[enable Thread sanitizer]'}"
        "--disable-prefetching[]"
        "--skip-update[Skip updating dependencies from their remote during a resolution]"
        "--disable-sandbox[Disable using the sandbox when executing subprocesses]"
        "--version[]"
        "--destination[]: :_files"
        "(--verbose -v)"{--verbose,-v}"[Increase verbosity of informational output]"
        "--no-static-swift-stdlib[Do not link Swift stdlib statically \[default\]]"
        "--static-swift-stdlib[Link Swift stdlib statically]"
        "--enable-build-manifest-caching[Enable llbuild manifest caching \[Experimental\]]"
        "--build-tests[Build both source and test targets]"
        "--product[Build the specified product]:Build the specified product: "
        "--target[Build the specified target]:Build the specified target: "
        "--show-bin-path[Print the binary output path]"
    )
    _arguments $arguments && return
}

# Generates completions for swift run
#
# In the final compdef file, set the following file header:
#
#     #compdef _swift_run
#     local context state state_descr line
#     typeset -A opt_args
_swift_run() {
    arguments=(
        ":The executable to run:_swift_executable"
        "-Xcc[Pass flag through to all C compiler invocations]:Pass flag through to all C compiler invocations: "
        "-Xswiftc[Pass flag through to all Swift compiler invocations]:Pass flag through to all Swift compiler invocations: "
        "-Xlinker[Pass flag through to all linker invocations]:Pass flag through to all linker invocations: "
        "-Xcxx[Pass flag through to all C++ compiler invocations]:Pass flag through to all C++ compiler invocations: "
        "(--configuration -c)"{--configuration,-c}"[Build with configuration (debug|release) ]: :{_values '' 'debug[build with DEBUG configuration]' 'release[build with RELEASE configuration]'}"
        "--build-path[Specify build/cache directory ]:Specify build/cache directory :_files"
        "(--chdir -C)"{--chdir,-C}"[]: :_files"
        "--package-path[Change working directory before any other operation]:Change working directory before any other operation:_files"
        "--sanitize[Turn on runtime checks for erroneous behavior]: :{_values '' 'address[enable Address sanitizer]' 'thread[enable Thread sanitizer]'}"
        "--disable-prefetching[]"
        "--skip-update[Skip updating dependencies from their remote during a resolution]"
        "--disable-sandbox[Disable using the sandbox when executing subprocesses]"
        "--version[]"
        "--destination[]: :_files"
        "(--verbose -v)"{--verbose,-v}"[Increase verbosity of informational output]"
        "--no-static-swift-stdlib[Do not link Swift stdlib statically \[default\]]"
        "--static-swift-stdlib[Link Swift stdlib statically]"
        "--enable-build-manifest-caching[Enable llbuild manifest caching \[Experimental\]]"
        "--skip-build[Skip building the executable product]"
    )
    _arguments $arguments && return
}

# Generates completions for swift package
#
# In the final compdef file, set the following file header:
#
#     #compdef _swift_package
#     local context state state_descr line
#     typeset -A opt_args
_swift_package() {
    arguments=(
        "-Xcc[Pass flag through to all C compiler invocations]:Pass flag through to all C compiler invocations: "
        "-Xswiftc[Pass flag through to all Swift compiler invocations]:Pass flag through to all Swift compiler invocations: "
        "-Xlinker[Pass flag through to all linker invocations]:Pass flag through to all linker invocations: "
        "-Xcxx[Pass flag through to all C++ compiler invocations]:Pass flag through to all C++ compiler invocations: "
        "(--configuration -c)"{--configuration,-c}"[Build with configuration (debug|release) ]: :{_values '' 'debug[build with DEBUG configuration]' 'release[build with RELEASE configuration]'}"
        "--build-path[Specify build/cache directory ]:Specify build/cache directory :_files"
        "(--chdir -C)"{--chdir,-C}"[]: :_files"
        "--package-path[Change working directory before any other operation]:Change working directory before any other operation:_files"
        "--sanitize[Turn on runtime checks for erroneous behavior]: :{_values '' 'address[enable Address sanitizer]' 'thread[enable Thread sanitizer]'}"
        "--disable-prefetching[]"
        "--skip-update[Skip updating dependencies from their remote during a resolution]"
        "--disable-sandbox[Disable using the sandbox when executing subprocesses]"
        "--version[]"
        "--destination[]: :_files"
        "(--verbose -v)"{--verbose,-v}"[Increase verbosity of informational output]"
        "--no-static-swift-stdlib[Do not link Swift stdlib statically \[default\]]"
        "--static-swift-stdlib[Link Swift stdlib statically]"
        "--enable-build-manifest-caching[Enable llbuild manifest caching \[Experimental\]]"
        '(-): :->command'
        '(-)*:: :->arg'
    )
    _arguments $arguments && return
    case $state in
        (command)
            local modes
            modes=(
                'edit:Put a package in editable mode'
                'clean:Delete build artifacts'
                'init:Initialize a new package'
                'dump-package:Print parsed Package.swift as JSON'
                'describe:Describe the current package'
                'unedit:Remove a package from editable mode'
                'update:Update package dependencies'
                'completion-tool:Completion tool (for shell completions)'
                'tools-version:Manipulate tools version of the current package'
                'reset:Reset the complete cache/build directory'
                'resolve:Resolve package dependencies'
                'generate-xcodeproj:Generates an Xcode project'
                'fetch:'
                'show-dependencies:Print the resolved dependency graph'
            )
            _describe "mode" modes
            ;;
        (arg)
            case ${words[1]} in
                (edit)
                    _swift_package_edit
                    ;;
                (clean)
                    _swift_package_clean
                    ;;
                (init)
                    _swift_package_init
                    ;;
                (dump-package)
                    _swift_package_dump-package
                    ;;
                (describe)
                    _swift_package_describe
                    ;;
                (unedit)
                    _swift_package_unedit
                    ;;
                (update)
                    _swift_package_update
                    ;;
                (completion-tool)
                    _swift_package_completion-tool
                    ;;
                (tools-version)
                    _swift_package_tools-version
                    ;;
                (reset)
                    _swift_package_reset
                    ;;
                (resolve)
                    _swift_package_resolve
                    ;;
                (generate-xcodeproj)
                    _swift_package_generate-xcodeproj
                    ;;
                (fetch)
                    _swift_package_fetch
                    ;;
                (show-dependencies)
                    _swift_package_show-dependencies
                    ;;
            esac
            ;;
    esac
}

_swift_package_edit() {
    arguments=(
        ":The name of the package to edit:_swift_dependency"
        "--revision[The revision to edit]:The revision to edit: "
        "--branch[The branch to create]:The branch to create: "
        "--path[Create or use the checkout at this path]:Create or use the checkout at this path:_files"
    )
    _arguments $arguments && return
}

_swift_package_clean() {
    arguments=(
    )
    _arguments $arguments && return
}

_swift_package_init() {
    arguments=(
        "--type[empty|library|executable|system-module]: :{_values '' 'empty[generates an empty project]' 'library[generates project for a dynamic library]' 'executable[generates a project for a cli executable]' 'system-module[generates a project for a system module]'}"
    )
    _arguments $arguments && return
}

_swift_package_dump-package() {
    arguments=(
    )
    _arguments $arguments && return
}

_swift_package_describe() {
    arguments=(
        "--type[json|text]: :{_values '' 'text[describe using text format]' 'json[describe using JSON format]'}"
    )
    _arguments $arguments && return
}

_swift_package_unedit() {
    arguments=(
        ":The name of the package to unedit:_swift_dependency"
        "--force[Unedit the package even if it has uncommited and unpushed changes.]"
    )
    _arguments $arguments && return
}

_swift_package_update() {
    arguments=(
    )
    _arguments $arguments && return
}

_swift_package_completion-tool() {
    arguments=(
        ": :{_values '' 'generate-bash-script[generate Bash completion script]' 'generate-zsh-script[generate Bash completion script]' 'list-dependencies[list all dependencies' names]' 'list-executables[list all executables' names]'}"
    )
    _arguments $arguments && return
}

_swift_package_tools-version() {
    arguments=(
        "--set[Set tools version of package to the given value]:Set tools version of package to the given value: "
        "--set-current[Set tools version of package to the current tools version in use]"
    )
    _arguments $arguments && return
}

_swift_package_reset() {
    arguments=(
    )
    _arguments $arguments && return
}

_swift_package_resolve() {
    arguments=(
        ":The name of the package to resolve:_swift_dependency"
        "--version[The version to resolve at]:The version to resolve at: "
        "--branch[The branch to resolve at]:The branch to resolve at: "
        "--revision[The revision to resolve at]:The revision to resolve at: "
    )
    _arguments $arguments && return
}

_swift_package_generate-xcodeproj() {
    arguments=(
        "--xcconfig-overrides[Path to xcconfig file]:Path to xcconfig file:_files"
        "--enable-code-coverage[Enable code coverage in the generated project]"
        "--output[Path where the Xcode project should be generated]:Path where the Xcode project should be generated:_files"
        "--legacy-scheme-generator[Use the legacy scheme generator]"
        "--watch[Watch for changes to the Package manifest to regenerate the Xcode project]"
    )
    _arguments $arguments && return
}

_swift_package_fetch() {
    arguments=(
    )
    _arguments $arguments && return
}

_swift_package_show-dependencies() {
    arguments=(
        "--format[text|dot|json|flatlist]: :{_values '' 'text[list dependencies using text format]' 'dot[list dependencies using dot format]' 'json[list dependencies using JSON format]'}"
    )
    _arguments $arguments && return
}

# Generates completions for swift test
#
# In the final compdef file, set the following file header:
#
#     #compdef _swift_test
#     local context state state_descr line
#     typeset -A opt_args
_swift_test() {
    arguments=(
        "-Xcc[Pass flag through to all C compiler invocations]:Pass flag through to all C compiler invocations: "
        "-Xswiftc[Pass flag through to all Swift compiler invocations]:Pass flag through to all Swift compiler invocations: "
        "-Xlinker[Pass flag through to all linker invocations]:Pass flag through to all linker invocations: "
        "-Xcxx[Pass flag through to all C++ compiler invocations]:Pass flag through to all C++ compiler invocations: "
        "(--configuration -c)"{--configuration,-c}"[Build with configuration (debug|release) ]: :{_values '' 'debug[build with DEBUG configuration]' 'release[build with RELEASE configuration]'}"
        "--build-path[Specify build/cache directory ]:Specify build/cache directory :_files"
        "(--chdir -C)"{--chdir,-C}"[]: :_files"
        "--package-path[Change working directory before any other operation]:Change working directory before any other operation:_files"
        "--sanitize[Turn on runtime checks for erroneous behavior]: :{_values '' 'address[enable Address sanitizer]' 'thread[enable Thread sanitizer]'}"
        "--disable-prefetching[]"
        "--skip-update[Skip updating dependencies from their remote during a resolution]"
        "--disable-sandbox[Disable using the sandbox when executing subprocesses]"
        "--version[]"
        "--destination[]: :_files"
        "(--verbose -v)"{--verbose,-v}"[Increase verbosity of informational output]"
        "--no-static-swift-stdlib[Do not link Swift stdlib statically \[default\]]"
        "--static-swift-stdlib[Link Swift stdlib statically]"
        "--enable-build-manifest-caching[Enable llbuild manifest caching \[Experimental\]]"
        "--skip-build[Skip building the test target]"
        "(--list-tests -l)"{--list-tests,-l}"[Lists test methods in specifier format]"
        "--generate-linuxmain[Generate LinuxMain.swift entries for the package]"
        "--parallel[Run the tests in parallel.]"
        "(--specifier -s)"{--specifier,-s}"[]: : "
        "--xunit-output[]: :_files"
        "--filter[Run test cases matching regular expression, Format: <test-target>.<test-case> or <test-target>.<test-case>/<test>]:Run test cases matching regular expression, Format: <test-target>.<test-case> or <test-target>.<test-case>/<test>: "
    )
    _arguments $arguments && return
}

_swift_compiler() {
}

_swift
