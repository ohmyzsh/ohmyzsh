#compdef cpanm

##
# cpanminus Z Shell completion script
##
#
# Current supported cpanm version: 1.4000 (Tue Mar  8 01:00:49 PST 2011)
#
# The latest code is always located at:
#   https://github.com/rshhh/cpanminus/blob/master/etc/_cpanm
#

local arguments curcontext="$curcontext"
typeset -A opt_args


arguments=(

# Commands
#  '(--install -i)'{--install,-i}'[Installs the modules]'
  '(- :)--self-upgrade[Upgrades itself]'
  '(- :)--info[Displays distribution info on CPAN]'
  '(--installdeps)--installdeps[Only install dependencies]'
  '(--look)--look[Download/unpack the distribution and then open the directory with your shell]'
  '(- :)'{--help,-h}'[Displays help information]'
  '(- :)'{--version,-V}'[Displays software version]'

# Options
  {--force,-f}'[Force install]'
  {--notest,-n}'[Do not run unit tests]'
  {--sudo,-S}'[sudo to run install commands]'
  '(-v --verbose --quiet -q)'{--verbose,-v}'[Turns on chatty output]'
  '(-q --quiet --verbose -v)'{--quiet,-q}'[Turns off all output]'
  {--local-lib,-l}'[Specify the install base to install modules]'
  {--local-lib-contained,-L}'[Specify the install base to install all non-core modules]'
  '--mirror[Specify the base URL for the mirror (e.g. http://cpan.cpantesters.org/)]:URLs:_urls'
  '--mirror-only[Use the mirror\''s index file instead of the CPAN Meta DB]'
  '--prompt[Prompt when configure/build/test fails]'
  '--reinstall[Reinstall the distribution even if you already have the latest version installed]'
  '--interactive[Turn on interactive configure]'

  '--scandeps[Scan the depencencies of given modules and output the tree in a text format]'
  '--format[Specify what format to display the scanned dependency tree]:scandeps format:(tree json yaml dists)'

  '--save-dists[Specify the optional directory path to copy downloaded tarballs]'
#  '--uninst-shadows[Uninstalls the shadow files of the distribution that you\''re installing]'

  '--auto-cleanup[Number of days that cpanm\''s work directories expire in. Defaults to 7]'
  '(--no-man-pages)--man-pages[Generates man pages for executables (man1) and libraries (man3)]'
  '(--man-pages)--no-man-pages[Do not generate man pages]'


  # Note: Normally with "--lwp", "--wget" and "--curl" options set to true (which is the default) cpanm tries LWP,
  #            Wget, cURL and HTTP::Tiny (in that order) and uses the first one available.
  # (So that the exclusions are not enabled here for the completion)
  '(--lwp)--lwp[Use LWP module to download stuff]'
  '(--wget)--wget[Use GNU Wget (if available) to download stuff]'
  '(--curl)--curl[Use cURL (if available) to download stuff]'

# Other completions
  '*:Local directory or archive:_files -/ -g "*.(tar.gz|tgz|tar.bz2|zip)(-.)"'
  #  '*::args: _normal' # this looks for default files (any files)
)
_arguments -s $arguments \
  && return 0

return 1
