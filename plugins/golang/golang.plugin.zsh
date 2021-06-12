# install in /etc/zsh/zshrc or your personal .zshrc

# gc
prefixes=(5 6 8)
for p in $prefixes; do
	compctl -g "*.${p}" ${p}l
	compctl -g "*.go" ${p}g
done

# standard go tools
compctl -g "*.go" gofmt

# gccgo
compctl -g "*.go" gccgo

# go tool
__go_tool_complete() {
  typeset -a commands build_flags
  commands+=(
    'build[compile packages and dependencies]'
    'clean[remove object files]'
    'doc[run godoc on package sources]'
    'env[print Go environment information]'
    'fix[run go tool fix on packages]'
    'fmt[run gofmt on package sources]'
    'generate[generate Go files by processing source]'
    'get[download and install packages and dependencies]'
    'help[display help]'
    'install[compile and install packages and dependencies]'
    'list[list packages]'
    'mod[modules maintenance]'
    'run[compile and run Go program]'
    'test[test packages]'
    'tool[run specified go tool]'
    'version[print Go version]'
    'vet[run go tool vet on packages]'
  )
  if (( CURRENT == 2 )); then
    # explain go commands
    _values 'go tool commands' ${commands[@]}
    return
  fi
  build_flags=(
    '-a[force reinstallation of packages that are already up to date]'
    '-n[print the commands but do not run them]'
    '-p[number of parallel builds]:number'
    '-race[enable data race detection]'
    '-x[print the commands]'
    '-work[print temporary directory name and keep it]'
    '-ccflags[flags for 5c/6c/8c]:flags'
    '-gcflags[flags for 5g/6g/8g]:flags'
    '-ldflags[flags for 5l/6l/8l]:flags'
    '-gccgoflags[flags for gccgo]:flags'
    '-compiler[name of compiler to use]:name'
    '-installsuffix[suffix to add to package directory]:suffix'
    '-tags[list of build tags to consider satisfied]:tags'
  )
  __go_packages() {
      local gopaths
      declare -a gopaths
      gopaths=("${(s/:/)$(go env GOPATH)}")
      gopaths+=("$(go env GOROOT)")
      for p in $gopaths; do
        _path_files -W "$p/src" -/
      done
  }
  __go_identifiers() {
      compadd $(godoc -templates $ZSH/plugins/golang/templates ${words[-2]} 2> /dev/null)
  }
  case ${words[2]} in
  doc)
    _arguments -s -w \
      "-c[symbol matching honors case (paths not affected)]" \
      "-cmd[show symbols with package docs even if package is a command]" \
      "-u[show unexported symbols as well as exported]" \
      "2:importpaths:__go_packages" \
      ":next identifiers:__go_identifiers"
      ;;
  clean)
    _arguments -s -w \
      "-i[remove the corresponding installed archive or binary (what 'go install' would create)]" \
      "-n[print the remove commands it would execute, but not run them]" \
      "-r[apply recursively to all the dependencies of the packages named by the import paths]" \
      "-x[print remove commands as it executes them]" \
      "*:importpaths:__go_packages"
      ;;
  fix|fmt|vet)
      _alternative ':importpaths:__go_packages' ':files:_path_files -g "*.go"'
      ;;
  install)
      _arguments -s -w : ${build_flags[@]} \
        "-v[show package names]" \
        '*:importpaths:__go_packages'
      ;;
  get)
      _arguments -s -w : \
        ${build_flags[@]}
      ;;
  build)
      _arguments -s -w : \
        ${build_flags[@]} \
        "-v[show package names]" \
        "-o[output file]:file:_files" \
        "*:args:{ _alternative ':importpaths:__go_packages' ':files:_path_files -g \"*.go\"' }"
      ;;
  test)
      _arguments -s -w : \
        ${build_flags[@]} \
        "-c[do not run, compile the test binary]" \
        "-i[do not run, install dependencies]" \
        "-v[print test output]" \
        "-x[print the commands]" \
        "-short[use short mode]" \
        "-parallel[number of parallel tests]:number" \
        "-cpu[values of GOMAXPROCS to use]:number list" \
        "-run[run tests and examples matching regexp]:regexp" \
        "-bench[run benchmarks matching regexp]:regexp" \
        "-benchmem[print memory allocation stats]" \
        "-benchtime[run each benchmark until taking this long]:duration" \
        "-blockprofile[write goroutine blocking profile to file]:file" \
        "-blockprofilerate[set sampling rate of goroutine blocking profile]:number" \
        "-timeout[kill test after that duration]:duration" \
        "-cpuprofile[write CPU profile to file]:file:_files" \
        "-memprofile[write heap profile to file]:file:_files" \
        "-memprofilerate[set heap profiling rate]:number" \
        "*:args:{ _alternative ':importpaths:__go_packages' ':files:_path_files -g \"*.go\"' }"
      ;;
  list)
      _arguments -s -w : \
        "-f[alternative format for the list]:format" \
        "-json[print data in json format]" \
        "-compiled[set CompiledGoFiles to the Go source files presented to the compiler]" \
        "-deps[iterate over not just the named packages but also all their dependencies]" \
        "-e[change the handling of erroneous packages]" \
        "-export[set the Export field to the name of a file containing up-to-date export information for the given package]" \
        "-find[identify the named packages but not resolve their dependencies]" \
        "-test[report not only the named packages but also their test binaries]" \
        "-m[list modules instead of packages]" \
        "-u[adds information about available upgrades]" \
        "-versions[set the Module's Versions field to a list of all known versions of that module]:number" \
        "*:importpaths:__go_packages"
      ;;
  mod)
      typeset -a mod_commands
      mod_commands+=(
        'download[download modules to local cache]'
        'edit[edit go.mod from tools or scripts]'
        'graph[print module requirement graph]'
        'init[initialize new module in current directory]'
        'tidy[add missing and remove unused modules]'
        'vendor[make vendored copy of dependencies]'
        'verify[verify dependencies have expected content]'
        'why[explain why packages or modules are needed]'
      )
      if (( CURRENT == 3 )); then
          _values 'go mod commands' ${mod_commands[@]} "help[display help]"
          return
      fi
      case ${words[3]} in
      help)
        _values 'go mod commands' ${mod_commands[@]}
        ;;
      download)
        _arguments -s -w : \
          "-json[print a sequence of JSON objects standard output]" \
          "*:flags"
        ;;
      edit)
        _arguments -s -w : \
          "-fmt[reformat the go.mod file]" \
          "-module[change the module's path]" \
          "-replace[=old{@v}=new{@v} add a replacement of the given module path and version pair]:name" \
          "-dropreplace[=old{@v}=new{@v} drop a replacement of the given module path and version pair]:name" \
          "-go[={version} set the expected Go language version]:number" \
          "-print[print the final go.mod in its text format]" \
          "-json[print the final go.mod file in JSON format]" \
          "*:flags"
        ;;
      graph)
        ;;
      init)   
        ;;
      tidy)
        _arguments -s -w : \
          "-v[print information about removed modules]" \
          "*:flags"
        ;;
      vendor)
        _arguments -s -w : \
          "-v[print the names of vendored]" \
          "*:flags"
        ;;
      verify)
        ;;
      why)
        _arguments -s -w : \
          "-m[treats the arguments as a list of modules and finds a path to any package in each of the modules]" \
          "-vendor[exclude tests of dependencies]" \
          "*:importpaths:__go_packages"
        ;;
      esac
      ;;
  help)
      _values "${commands[@]}" \
        'environment[show Go environment variables available]' \
        'gopath[GOPATH environment variable]' \
        'packages[description of package lists]' \
        'remote[remote import path syntax]' \
        'testflag[description of testing flags]' \
        'testfunc[description of testing functions]'
      ;;
  run)
      _arguments -s -w : \
          ${build_flags[@]} \
          '*:file:_files -g "*.go"'
      ;;
  tool)
      if (( CURRENT == 3 )); then
          _values "go tool" $(go tool)
          return
      fi
      case ${words[3]} in
      [568]g)
          _arguments -s -w : \
              '-I[search for packages in DIR]:includes:_path_files -/' \
              '-L[show full path in file:line prints]' \
              '-S[print the assembly language]' \
              '-V[print the compiler version]' \
              '-e[no limit on number of errors printed]' \
              '-h[panic on an error]' \
              '-l[disable inlining]' \
              '-m[print optimization decisions]' \
              '-o[file specify output file]:file' \
              '-p[assumed import path for this code]:importpath' \
              '-u[disable package unsafe]' \
              "*:file:_files -g '*.go'"
          ;;
      [568]l)
          local O=${words[3]%l}
          _arguments -s -w : \
              '-o[file specify output file]:file' \
              '-L[search for packages in DIR]:includes:_path_files -/' \
              "*:file:_files -g '*.[ao$O]'"
          ;;
      dist)
          _values "dist tool" banner bootstrap clean env install version
          ;;
      *)
          # use files by default
          _files
          ;;
      esac
      ;;
  esac
}

compdef __go_tool_complete go

# aliases: go<~>
alias gob='go build'
alias goc='go clean'
alias god='go doc'
alias gof='go fmt'
alias gofa='go fmt ./...'
alias gog='go get'
alias goi='go install'
alias gol='go list'
alias gom='go mod'
alias gop='cd $GOPATH'
alias gopb='cd $GOPATH/bin'
alias gops='cd $GOPATH/src'
alias gor='go run'
alias got='go test'
alias gov='go vet'
