
_godoc () {

  typeset -A opt_args
  local context state line
  local pkgdir usrpkgdir

  pkgdir="$GOROOT/src/pkg"
  usrpkgdir="$GOPATH/src"
  godoctmpl=$ZSH/plugins/godoc/templates

  _arguments -s -S \
    "-goroot+[Go root directory]::(/usr/lib/go)" \
    "-html[print HTML in command-line mode]" \
    "-http+[HTTP service address (e.g., :6060)]" \
    "-index[enable search index]" \
    "-index_files+[glob pattern specifying index files;if not empty, the index is read from these files in sorted order]" \
    "-index_throttle+[index throttle value; 0.0 = no time allocated, 1.0 = full throttle]::(0.75 0.0 1.0)" \
    "-maxresults+[maximum number of full text search results shown]::(10000)" \
    "-path+[additional package directories (colon-separated)]" \
    "-q[arguments are considered search queries]" \
    "-server+[webserver address for command line searches]" \
    "-src[print (exported) source in command-line mode]" \
    "-tabwidth+[tab width]::(4)" \
    "-templates+[directory containing alternate template files]" \
    "-testdir+[Go root subdirectory - for testing only (faster startups)]" \
    "-timestamps[show timestamps with directory listings]" \
    "-url+[print HTML for named URL]" \
    "-v[verbose mode]" \
    "-write_index[write index to a file; the file name must be specified with -index_files]" \
    "1:package:->pkgs" \
    "*:package contents:->pkg_content"

  case $state in
    (pkgs)
      _path_files -W "$pkgdir" -/
      _path_files -W "$usrpkgdir" -/
      return 0
    ;;
    (pkg_content)
      godoc_completions=$(godoc -templates "$godoctmpl" $words[-2] 2> /dev/null) 
      if [ $? -eq 0 ]; then
         compadd "$@" $(echo "$godoc_completions")
      fi
      return 0
    ;;
  esac
}

compdef _godoc godoc