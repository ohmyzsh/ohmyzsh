#compdef volta

autoload -U is-at-least

_volta() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-v[Prints the current version of Volta]' \
'--version[Prints the current version of Volta]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
":: :_volta_commands" \
"*::: :->Volta" \
&& ret=0
    case $state in
    (Volta)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:volta-command-$line[1]:"
        case $line[1] in
            (fetch)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':tool[@version] -- Tools to fetch, like `node`, `yarn@latest` or `your-package@^14.4.3`.:_files' \
&& ret=0
;;
(install)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':tool[@version] -- Tools to install, like `node`, `yarn@latest` or `your-package@^14.4.3`.:_files' \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':tool -- The tool to uninstall, e.g. `node`, `npm`, `yarn`, or <package>:_files' \
&& ret=0
;;
(pin)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':tool[@version] -- Tools to pin, like `node@lts` or `yarn@^1.14`.:_files' \
&& ret=0
;;
(ls)
_arguments "${_arguments_options[@]}" \
'--format=[Specify the output format]: :(human plain)' \
'(-d --default)-c[Show the currently-active tool(s)]' \
'(-d --default)--current[Show the currently-active tool(s)]' \
'(-c --current)-d[Show your default tool(s).]' \
'(-c --current)--default[Show your default tool(s).]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'::tool -- The tool to lookup - `all`, `node`, `yarn`, or the name of a package or binary.:_files' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
'--format=[Specify the output format]: :(human plain)' \
'(-d --default)-c[Show the currently-active tool(s)]' \
'(-d --default)--current[Show the currently-active tool(s)]' \
'(-c --current)-d[Show your default tool(s).]' \
'(-c --current)--default[Show your default tool(s).]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'::tool -- The tool to lookup - `all`, `node`, `yarn`, or the name of a package or binary.:_files' \
&& ret=0
;;
(completions)
_arguments "${_arguments_options[@]}" \
'-o+[File to write generated completions to]' \
'--output=[File to write generated completions to]' \
'-f[Write over an existing file, if any.]' \
'--force[Write over an existing file, if any.]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':shell -- Shell to generate completions for:(zsh bash fish powershell elvish)' \
&& ret=0
;;
(which)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':binary -- The binary to find, e.g. `node` or `npm`:_files' \
&& ret=0
;;
(use)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'::anything:_files' \
&& ret=0
;;
(setup)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
&& ret=0
;;
(run)
_arguments "${_arguments_options[@]}" \
'--node=[Set the custom Node version]' \
'(--bundled-npm)--npm=[Set the custom npm version]' \
'(--no-yarn)--yarn=[Set the custom Yarn version]' \
'*--env=[Set an environment variable (can be used multiple times)]' \
'(--npm)--bundled-npm[Forces npm to be the version bundled with Node]' \
'(--yarn)--no-yarn[Disables Yarn]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
':command -- The command to run:_files' \
'::args -- Arguments to pass to the command:_files' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'--verbose[Enables verbose diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
&& ret=0
;;
        esac
    ;;
esac
}

(( $+functions[_volta_commands] )) ||
_volta_commands() {
    local commands; commands=(
        "fetch:Fetches a tool to the local machine" \
"install:Installs a tool in your toolchain" \
"uninstall:Uninstalls a tool from your toolchain" \
"pin:Pins your project's runtime or package manager" \
"list:Displays the current toolchain" \
"completions:Generates Volta completions" \
"which:Locates the actual binary that will be called by Volta" \
"use:" \
"setup:Enables Volta for the current user / shell" \
"run:Run a command with custom Node, npm, and/or Yarn versions" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'volta commands' commands "$@"
}
(( $+functions[_volta__completions_commands] )) ||
_volta__completions_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta completions commands' commands "$@"
}
(( $+functions[_volta__fetch_commands] )) ||
_volta__fetch_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta fetch commands' commands "$@"
}
(( $+functions[_volta__help_commands] )) ||
_volta__help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta help commands' commands "$@"
}
(( $+functions[_volta__install_commands] )) ||
_volta__install_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta install commands' commands "$@"
}
(( $+functions[_volta__list_commands] )) ||
_volta__list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta list commands' commands "$@"
}
(( $+functions[_ls_commands] )) ||
_ls_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'ls commands' commands "$@"
}
(( $+functions[_volta__ls_commands] )) ||
_volta__ls_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta ls commands' commands "$@"
}
(( $+functions[_volta__pin_commands] )) ||
_volta__pin_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta pin commands' commands "$@"
}
(( $+functions[_volta__run_commands] )) ||
_volta__run_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta run commands' commands "$@"
}
(( $+functions[_volta__setup_commands] )) ||
_volta__setup_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta setup commands' commands "$@"
}
(( $+functions[_volta__uninstall_commands] )) ||
_volta__uninstall_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta uninstall commands' commands "$@"
}
(( $+functions[_volta__use_commands] )) ||
_volta__use_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta use commands' commands "$@"
}
(( $+functions[_volta__which_commands] )) ||
_volta__which_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'volta which commands' commands "$@"
}

_volta "$@"