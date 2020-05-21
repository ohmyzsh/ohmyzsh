#compdef manage.py

typeset -ga managepy_base_args
managepy_base_args=(
  "(- *)"{-h,--help}"[Show this help message and exit.]"
  {"(-v)--verbosity=","(--verbosity)-v"}"[verbosity level; 0=minimal output, 1=normal output, 2=verbose output, 3=very verbose output.]:verbosity:((0\:minimal 1\:normal 2\:verbose 3\:very-verbose))"
  "--settings=[the Python path to a settings module.The Python path to a settings module, e.g. 'myproject.settings.main'. If this isn't provided, the DJANGO_SETTINGS_MODULE environment variable will be used.]:settings_module"
  "--pythonpath=[a directory to add to the Python path.]:directory:_directories"
  "--traceback[print traceback on exception.]"
  "--no-color[Don't colorize the command output.]"
  "--force-color[Force colorization of the command output.]"
)

typeset -ga managepy_db_arg
managepy_db_arg=(
  '--database=[Nominates a database. Defaults to the "default" database.]:database'
)

typeset -ga managepy_noinput_arg
managepy_noinput_arg=(
  '--noinput[Tells Django to NOT prompt the user for input of any kind.]'
)

typeset -ga managepy_start_args
managepy_start_args=(
    "--template=[The path or URL to load the template from.]:directory:_directories" \
    {-e,--extension=}"[The file extension(s) to render (default: 'py'). Separate multiple extensions with commas, or use -e multiple times.]" \
    {-n,--name=}"[The file name(s) to render. Separate multiple file names with commas, or use -n multiple times.]::_files"
)

_managepy_applabels() {
  local line
  local -a apps
  _call_program help-command \
    "./manage.py shell -c \\
        \"import sys; from django.apps import apps;\\
          [sys.stdout.write(app.label + '\n') for app in apps.get_app_configs()]\"" \
    | while read -A line; do apps=($line $apps) done
  _values 'Applications' $apps && ret=0
}

_managepy_usernames() {
  local line
  local -a names
  _call_program help-command \
    "./manage.py shell -c \\
        \"import sys; from django.contrib.auth import get_user_model;\\
        User = get_user_model();\\
        [sys.stdout.write(username + '\n') for username in User.objects.values_list(User.USERNAME_FIELD, flat=True)]\"" \
    | while read -A line; do names=($line $names) done
  _values 'Usernames' $names && ret=0
}

_managepy_apps_with_migrations() {
  local -a apps

  for app in $(./manage.py showmigrations 2>&1 >/dev/null | awk '!/^ / {print}')
  do
    apps+=($app)
  done

  _values 'Apps' $apps && ret=0
}

_managepy_migrations() {
  local -a migrations
  migrations=('zero')
  for migration in $(./manage.py showmigrations 2>&1 >/dev/null | \
    awk -v drop=1 -v app=$words[2] '!/^ / {if ($0 == app) { drop=0 } else { drop=1 }} /^ / {if (!drop) {sub(/^ \[.\] /, ""); print}}')
  do
    migrations+=($migration)
  done
  _values 'Migrations' $migrations && ret=0
}

_managepy_complete_changepassword() {
  _arguments -s : \
    '*::username:_managepy_usernames' \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_check() {
  _arguments -s : \
    "*::appname:_managepy_applabels" \
    "--tag=[Run only checks labeled with given tag.]:tags" \
    "--list-tags[List available tags.]" \
    "--deploy[Check deployment settings.]" \
    "--fail-level=[Message level that will cause the command to exit with a non-zero status. Default is ERROR]:level:(CRITICAL ERROR WARNING INFO DEBUG)" \
    $managepy_base_args && ret=0
}

_managepy_complete_collectstatic(){
  _arguments -s : \
    "--link[Create a symbolic link to each file instead of copying.]" \
    "--no-post-process[Do NOT post process collected files.]" \
    {-i,--ignore=}"[Ignore files or directories matching this glob-style pattern. Use multiple times to ignore more.]" \
    "--dry-run[Do everything except modify the filesystem.]" \
    "--clear[Clear the existing files using the storage before trying to copy or link the original file.]" \
    "--link[Create a symbolic link to each file instead of copying.]" \
    "--no-default-ignore[Do not ignore the common private glob-style patterns 'CVS', '.*' and '*~'.]" \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_compilemessages(){
  _arguments -s : \
    {-l,--locale=}"[Locale(s) to process (e.g. de_AT). Default is to process all. Can be used multiple times.]" \
    {-x,--exclude=}"[Locales to exclude. Default is none. Can be used multiple times.]" \
    {-f,--use-fuzzy}"[Use fuzzy translations.]" \
    $managepy_base_args && ret=0
}

_managepy_complete_createcachetable(){
  _arguments -s : \
    "--dry-run[Does not create the table, just prints the SQL that would be run.]" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_createsuperuser(){
  _arguments -s : \
    "--username=[Specifies the login for the superuser.]:username" \
    $managepy_db_arg \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_dbshell(){
  _arguments -s : \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_diffsettings(){
  _arguments -s : \
    "--all[Display all settings, regardless of their value.]" \
    "--default=[The settings module to compare the current settings against. Leave empty to compare against Django's default settings.]:default" \
    "--output=-[Selects the output format. 'hash' mode displays each changed setting, with the settings that don't appear in the defaults followed by ###. 'unified' mode prefixes the default setting with a minus sign, followed by the changed setting prefixed with a plus sign.]::output:(hash unified)" \
    $managepy_base_args && ret=0
}

_managepy_complete_dumpdata(){
  _arguments -s : \
    "*::appname:_managepy_applabels" \
    "--format=-[Specifies the output serialization format for fixtures.]:format:(json yaml xml)" \
    "--indent=-[Specifies the indent level to use when pretty-printing output.]:indent:int" \
    {-e,--exclude=}"[An app_label or app_label.ModelName to exclude (use multiple --exclude to exclude multiple apps/models).]" \
    "--natural-foreign[Use natural foreign keys if they are available.]" \
    "--natural-primary[Use natural primary keys if they are available.]" \
    {"(-a)--all","(--all)-a"}"[Use Django's base manager to dump all models stored in the database.]" \
    "--pks=[Only dump objects with given primary keys.]:primary_keys" \
    {"(-o)--output=","(--output)-o"}"[Specifies file to which the output is written.]:output"
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_findstatic() {
  _arguments -s : \
    "--first[Only return the first match for each static file.]" \
    $managepy_base_args && ret=0
}

_managepy_complete_flush(){
  _arguments -s : \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_help(){
  _arguments -s : \
    "*:command:_managepy_commands" \
    $managepy_base_args && ret=0
}

_managepy_complete_inspectdb(){
  _arguments -s : \
    "--include-partitions[Also output models for partition tables.]" \
    "--include-views[Also output models for database views.]" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_loaddata(){
  _arguments -s : \
    "--app=[Only look for fixtures in the specified app.]:appname:_managepy_applabels" \
    {"(-i)--ignorenonexistent","(--ignorenoneexistent)-i"}"[Ignores entries in the serialized data for fields that do not currently exist on the model.]" \
    {-e,--exclude=}"[An app_label or app_label.ModelName to exclude. Can be used multiple times.]" \
    "--format=[An app_label or app_label.ModelName to exclude. Can be used multiple times.]:format" \
    "*::file:_files" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_makemessages(){
  _arguments -s : \
    {-l,--locale=}"[Creates or updates the message files for the given locale(s) (e.g. pt_BR).]" \
    {-x,--exclude=}"[Locales to exclude. Default is none. Can be used multiple times]" \
    {"(-d)--domain=","(--domain)-d"}"[The domain of the message files (default: 'django').]:domain" \
    {"(-a)--all","(--all)-a"}"[Updates the message files for all existing locales.]" \
    {-e,--extension=}"[The file extension(s) to examine (default: 'html,txt', or 'js' if the domain is 'djangojs').]" \
    {"(-s)--symlinks","(--symlinks)-s"}"[Follows symlinks to directories when examining source code and templates for translation strings.]" \
    {-i,--ignore=}"[Ignore files or directories matching this glob-style pattern. Use multiple times to ignore more.]" \
    "--no-default-ignore[Don't ignore the common glob-style patterns 'CVS', '.*', '*~' and '*.pyc'.]" \
    "--no-wrap[Don't break long message lines into several lines.]" \
    "--no-location[Don't write '#: filename:line' lines.]" \
    "--no-obsolete[Remove obsolete message strings.]" \
    "--keep-pot[Keep .pot file after making messages.]" \
    "--add-location=-[Controls '#: filename:line' lines. If the option is 'full' (the default if not given), the lines include both file name and line number. If it's 'file', the line number is omitted. If it's 'never', the lines are suppressed (same as --no-location). --add-location requires gettext 0.19 or newer.]::location:(full file never)" \
    $managepy_base_args && ret=0
}

_managepy_complete_makemigrations(){
  _arguments -s : \
    "*::appname:_managepy_applabels" \
    "--dry-run[Just show what migrations would be made]" \
    "--merge[Enable fixing of migration conflicts.]" \
    "--empty[Create an empty migration.]" \
    "--check[Exit with a non-zero status if model changes are missing migrations.]" \
    "--no-header[Do not add header comments to new migration file(s).]" \
    {"(-n)--name","(--name)-n"}"[Use this name for migration file(s).]" \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_migrate() {
  _arguments -s : \
    "1::appname:_managepy_apps_with_migrations" \
    "2::migration:_managepy_migrations" \
    "(1 2)--fake[Mark migrations as run without actually running them.]" \
    "(1 2)--fake-initial[Detect if tables already exist and fake-apply initial migrations if so. Make sure that the current database schema matches your initial migration before using this flag. Django will only check for an existing table name.]" \
    "(1 2)--plan[Shows a list of the migration actions that will be performed.]" \
    "(1 2)--run-syncdb[Creates tables for apps without migrations.]" \
    $managepy_db_arg \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_runserver(){
  _arguments -s : \
    {"(-6)--ipv6","(--ipv6)-6"}"[Tells Django to use an IPv6 address.]" \
    "--nothreading[Tells Django to NOT use threading.]" \
    "--noreload[Tells Django to NOT use the auto-reloader.]" \
    "--nostatic[Tells Django to NOT automatically serve static files at STATIC_URL.]" \
    "--insecure[Allows serving static files even if DEBUG is False.]" \
    $managepy_base_args && ret=0
}

_managepy_complete_sendtestemail() {
  _arguments -s : \
    "--managers[Send a test email to the addresses specified in settings.MANAGERS.]" \
    "--admins[Send a test email to the addresses specified in settings.ADMINS.]" \
    $managepy_base_args && ret=0
}

_managepy_complete_shell() {
  _arguments -s : \
    "--no-startup[When using plain Python, ignore the PYTHONSTARTUP environment variable and ~/.pythonrc.py script.]" \
    {"(-i)--interface=","(--interface)-i"}"[Specify an interactive interpreter interface. Available options: 'ipython', 'bpython', and 'python']::interface:(ipython bpython python)" \
    "--command=[Instead of opening an interactive shell, run a command as Django and exit.]:command" \
    $managepy_base_args && ret=0
}

_managepy_complete_showmigrations() {
  _arguments -s : \
    "*::appname:_managepy_applabels" \
    {"(-l)--list","(--list)-l"}"[Shows a list of all migrations and which are applied.]" \
    {"(-p)--plan","(--plan)-p"}"[Shows all migrations in the order they will be applied. With a verbosity level of 2 or above all direct migration dependencies and reverse dependencies (run_before) will be included.]" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_sqlflush(){
  _arguments -s : \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_sqlmigrate(){
  _arguments -s : \
    "1::appname:_managepy_apps_with_migrations" \
    "2::migration:_managepy_migrations" \
    "--backwards[Create SQL to unapply the migration, rather than to apply it.]" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_sqlsequencereset(){
  _arguments -s : \
    "*::appname:_managepy_applabels" \
    $managepy_db_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_squashmigrations(){
  _arguments -s : \
    "1::appname:_managepy_apps_with_migrations" \
    "--no-optimize[Do not try to optimize the squashed operations.]" \
    "--no-header[Do not add a header comment to the new squashed migration.]" \
    "--squashed-name=[Sets the name of the new squashed migration.]:name" \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_startapp(){
  _arguments -s : \
    $managepy_start_args \
    $managepy_base_args && ret=0
}

_managepy_complete_test() {
  _arguments -s : \
    "--failfast[Tells Django to stop running the test suite after first failed test.]" \
    "--testrunner=[Tells Django to use specified test runner class instead of the one specified by the TEST_RUNNER setting.]:runner" \
    "--liveserver=[Overrides the default address where the live server (used with LiveServerTestCase) is expected to run from. The default value is localhost:8081.]:server" \
    {"(-t)--top-level-directory=","(--top-level-directory)-t"}"[Top level of project for unittest discovery.]:directory:_directories" \
    {"(-p)--pattern=","(--pattern)-p"}"[The test matching pattern. Defaults to test*.py.]:pattern" \
    {"(-k)--keepdb","(--keepdb)-k"}"[Preserves the test DB between runs.]" \
    {"(-r)--reverse","(--reverse)-r"}"[Reverses test cases order.]" \
    "--debug-mode[Sets settings.DEBUG to True.]" \
    {"(-d)--debug-sql","(--debug-sql)-d"}"[Prints logged SQL queries on failure.]" \
    "--parallel[Run tests using up to N parallel processes.]" \
    "--tag=[Run only tests with the specified tag. Can be used multiple times.]" \
    "--exclude-tag=[Do not run tests with the specified tag. Can be used multiple times.]" \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_complete_testserver(){
  _arguments -s : \
    {"(-6)--ipv6","(--ipv6)-6"}"[Tells Django to use an IPv6 address.]" \
    "--addrport=[Port number or ipaddr:port to run the server on.]:addrport" \
    '*::file:_files' \
    $managepy_noinput_arg \
    $managepy_base_args && ret=0
}

_managepy_commands() {
  local -a commands

  for cmd in $(./manage.py --help 2>&1 >/dev/null | \
               awk -v drop=1 '{ if (!drop && $0 && substr($0,1,1) !~ /\[/) {sub(/^[ \t]+/, ""); print} } /^Available subcommands/ { drop=0 }')
  do
    commands+=($cmd)
  done

  _describe -t commands 'manage.py command' commands && ret=0
}

_managepy() {
  local curcontext=$curcontext state ret=1

  typeset -A opt_args
  _arguments \
    "(- 1 *)--version[Show program's version number and exit]" \
    "1: :->command" \
    "*:: :->args" && ret=0

  case $state in
    command)
      _managepy_commands
      ;;
    args)
      curcontext="${curcontext%:*:*}:managepy-$words[1]:"
      _call_function ret _managepy_complete_$words[1]
      ;;
  esac
}

compdef _managepy manage.py
