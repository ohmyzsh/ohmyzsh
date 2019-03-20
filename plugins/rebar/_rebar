#compdef rebar

local curcontext=$curcontext state ret=1
typeset -ga _rebar_global_opts

_rebar_global_opts=(
  '(--help -h)'{--help,-h}'[Show the program options]'
  '(--commands -c)'{--commands,-c}'[Show available commands]'
  '(--version -V)'{--version,-V}'[Show version information]'
  '(-vvv -vv -v)'--verbose+'[Verbosity level. Default: 0]:verbosity level:(0 1 2 3)'
  '(-vvv)-v[Slightly more verbose output]'
  '(-vvv)-vv[More verbose output]'
  '(-v -vv)-vvv[Most verbose output]'
  '(--force -f)'{--force,-f}'[Force]'
  '-D+[Define compiler macro]'
  '(--jobs -j)'{--jobs+,-j+}'[Number of concurrent workers a command may use. Default: 3]:workers:(1 2 3 4 5 6 7 8 9)'
  '(--config -C)'{--config,-C}'[Rebar config file to use]:files:_files'
  '(--profile -p)'{--profile,-p}'[Profile this run of rebar]'
  '(--keep-going -k)'{--keep-going,-k}'[Keep running after a command fails]'
)

_rebar () {
  _arguments -C $_rebar_global_opts \
    '*::command and variable:->cmd_and_var' \
    && return

  case $state in
    cmd_and_var)
      _values -S = 'variables' \
        'clean[Clean]' \
        'compile[Compile sources]' \
        'create[Create skel based on template and vars]' \
        'create-app[Create simple app skel]' \
        'create-node[Create simple node skel]' \
        'list-template[List avaiavle templates]' \
        'doc[Generate Erlang program documentation]' \
        'check-deps[Display to be fetched dependencies]' \
        'get-deps[Fetch dependencies]' \
        'update-deps[Update fetched dependencies]' \
        'delete-deps[Delete fetched dependencies]' \
        'list-deps[List dependencies]' \
        'generate[Build release with reltool]' \
        'overlay[Run reltool overlays only]' \
        'generate-appups[Generate appup files]' \
        'generate-upgrade[Build an upgrade package]' \
        'eunit[Run eunit tests]' \
        'ct[Run common_test suites]' \
        'qc[Test QuickCheck properties]' \
        'xref[Run cross reference analysis]' \
        'help[Show the program options]' \
        'version[Show version information]' \
        'apps[Application names to process]:' \
        'case[Common Test case]:' \
        'dump_spec[Dump reltool spec]:' \
        'jobs[Number of workers]::workers:(0 1 2 3 4 5 6 7 8 9)' \
        'suites[Common Test suites]::suite name:_path_files -W "(src test)" -g "*.erl(:r)"' \
        'verbose[Verbosity level]::verbosity level:(0 1 2 3)' \
        'appid[Application id]:' \
        'previous_release[Previous release path]:' \
        'nodeid[Node id]:' \
        'root_dir[Reltool config root directory]::directory:_files -/' \
        'skip_deps[Skip deps]::flag:(true false)' \
        'skip_apps[Application names to not process]::flag:(true false)' \
        'template[Template name]:' \
        'template_dir[Template directory]::directory:_files -/' \
        && ret=0
      ;;
  esac
}

_rebar

# Local variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: sw=2 ts=2 et filetype=sh
