#compdef setup.py
# ------------------------------------------------------------------------------
# Copyright (C) 2015 by Hideo Hattori <hhatto.jp@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for setup.py (http://docs.python.org/distutils/).
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Hideo Hattori (https://github.com/hhatto)
#
# ------------------------------------------------------------------------------

_setup.py() {
  typeset -A opt_args
  local context state line

  _arguments -s -S \
    "--verbose[run verbosely (default)]" \
    "-v[run verbosely (default)]" \
    "--quiet[run quietly (turns verbosity off)]" \
    "-q[run quietly (turns verbosity off)]" \
    "--dry-run[don't actually do anything]" \
    "-n[don't actually do anything]" \
    "--help[show detailed help message]" \
    "-h[show detailed help message]" \
    "--no-user-cfg[ignore pydistutils.cfg in your home directory]" \
    "--command-packages=[list of packages that provide distutils commands]" \
    "--help-commands[list all available commands]" \
    "--name[print package name]" \
    "--version[print package version]" \
    "-V[print package version]" \
    "--fullname[print <package name>-<version>]" \
    "--author[print the author's name]" \
    "--author-email[print the author's email address]" \
    "--maintainer[print the maintainer's name]" \
    "--maintainer-email[print the maintainer's email address]" \
    "--contact[print the maintainer's name if known, else the author's]" \
    "--contact-email[print the maintainer's email address if known, else the author's]" \
    "--url[print the URL for this package]" \
    "--license[print the license of the package]" \
    "--licence[alias for --license]" \
    "--description[print the package description]" \
    "--long-description[print the long package description]" \
    "--platforms[print the list of platforms]" \
    "--classifiers[print the list of classifiers]" \
    "--keywords[print the list of keywords]" \
    "--provides[print the list of packages/modules provided]" \
    "--requires[print the list of packages/modules required]" \
    "--obsoletes[print the list of packages/modules made obsolete]" \
    "*::setup.py commands:_setuppy_command"
}

(( $+functions[_setuppy_command] )) ||
_setuppy_command() {
  local cmd ret=1

  (( $+setuppy_cmds )) || _setuppy_cmds=(
    "build:build everything needed to install" \
    "build_py:\"build\" pure Python modules (copy to build directory)" \
    "build_ext:build C/C++ extensions (compile/link to build directory)" \
    "build_clib:build C/C++ libraries used by Python extensions" \
    "build_scripts:\"build\" scripts (copy and fixup #! line)" \
    "clean:clean up temporary files from 'build' command" \
    "install:install everything from build directory" \
    "install_lib:install all Python modules (extensions and pure Python)" \
    "install_headers:install C/C++ header files" \
    "install_scripts:install scripts (Python or otherwise)" \
    "install_data:install data files" \
    "sdist:create a source distribution (tarball, zip file, etc.)" \
    "register:register the distribution with the Python package index" \
    "bdist:create a built (binary) distribution" \
    "bdist_dumb:create a \"dumb\" built distribution" \
    "bdist_rpm:create an RPM distribution" \
    "bdist_wininst:create an executable installer for MS Windows" \
    "upload:upload binary package to PyPI" \
    "check:perform some checks on the package" \
    "alias:define a shortcut to invoke one or more commands" \
    "bdist_egg:create an \"egg\" distribution" \
    "develop:install package in 'development mode'" \
    "easy_install:Find/get/install Python packages" \
    "egg_info:create a distribution's .egg-info directory" \
    "rotate:delete older distributions, keeping N newest files" \
    "saveopts:save supplied options to setup.cfg or other config file" \
    "setopt:set an option in setup.cfg or another config file" \
    "test:run unit tests after in-place build" \
    "install_egg_info:Install an .egg-info directory for the package" \
    "upload_docs:Upload documentation to PyPI" \
    )

  if (( CURRENT == 1 )); then
    _describe -t commands 'setup.py subcommand' _setuppy_cmds || compadd "$@" - ${(s.:.)${(j.:.)_setuppy_syns}}
  else
    local curcontext="$curcontext"

    cmd="${${_setuppy_cmds[(r)$words[1]:*]%%:*}:-${(k)_setuppy_syns[(r)(*:|)$words[1](:*|)]}}"
    if (( $#cmd )); then
      curcontext="${curcontext%:*:*}:setuppy-${cmd}:"
      _call_function ret _setuppy_$cmd || _message 'no more arguments'
    else
      _message "unknown setup.py command: $words[1]"
      fi
    return ret
  fi
}

(( $+functions[_setuppy_build] )) ||
_setuppy_build() {
  _arguments -s \
    "--build-base=[base directory for build library]" \
    "-b[base directory for build library]" \
    "--build-purelib=[build directory for platform-neutral distributions]" \
    "--build-platlib=[build directory for platform-specific distributions]" \
    "--build-lib=[build directory for all distribution (defaults to either build-purelib or build-platlib]" \
    "--build-scripts=[build directory for scripts]" \
    "--build-temp=[temporary build directory]" \
    "-t[temporary build directory]" \
    "--plat-name=[platform name to build for, if supported (default: linux-i686)]" \
    "-p[platform name to build for, if supported (default: linux-i686)]" \
    "--compiler=[specify the compiler type]" \
    "-c[specify the compiler type]" \
    "--debug[compile extensions and libraries with debugging information]" \
    "-g[compile extensions and libraries with debugging information]" \
    "--force[forcibly build everything (ignore file timestamps)]" \
    "-f[forcibly build everything (ignore file timestamps)]" \
    "--executable=[specify final destination interpreter path (build.py)]" \
    "-e[specify final destination interpreter path (build.py)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_build_py] )) ||
_setuppy_build_py() {
  _arguments -s \
    "--build-lib=[directory to \"build\" (copy) to]" \
    "-d[directory to \"build\" (copy) to]" \
    "--compile[compile .py to .pyc]" \
    "-c[compile .py to .pyc]" \
    "--no-compile[don't compile .py files \[default\]]" \
    "--optimize=[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "-O[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "--force[forcibly build everything (ignore file timestamps)]" \
    "-f[forcibly build everything (ignore file timestamps)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_build_ext] )) ||
_setuppy_build_ext() {
  _arguments -s \
    "--build-lib=[directory for compiled extension modules]" \
    "-b[directory for compiled extension modules]" \
    "--build-temp=[directory for temporary files (build by-products)]" \
    "-t[directory for temporary files (build by-products)]" \
    "--plat-name=[platform name to cross-compile for, if supported (default: linux-i686)]" \
    "-p[platform name to cross-compile for, if supported (default: linux-i686)]" \
    "--inplace[ignore build-lib and put compiled extensions into the source directory alongside your pure Python modules]" \
    "-i[ignore build-lib and put compiled extensions into the source directory alongside your pure Python modules]" \
    "--include-dirs=[list of directories to search for header files (separated by ':')]" \
    "-I[list of directories to search for header files (separated by ':')]" \
    "--define=[C preprocessor macros to define]" \
    "-D[C preprocessor macros to define]" \
    "--undef=[C preprocessor macros to undefine]" \
    "-U[C preprocessor macros to undefine]" \
    "--libraries=[external C libraries to link with]" \
    "-l[external C libraries to link with]" \
    "--library-dirs=[directories to search for external C libraries (separated by ':')]" \
    "-L[directories to search for external C libraries (separated by ':')]" \
    "--rpath=[directories to search for shared C libraries at runtime]" \
    "-R[directories to search for shared C libraries at runtime]" \
    "--link-objects=[extra explicit link objects to include in the link]" \
    "-O[extra explicit link objects to include in the link]" \
    "--debug[compile/link with debugging information]" \
    "-g[compile/link with debugging information]" \
    "--force[forcibly build everything (ignore file timestamps)]" \
    "-f[forcibly build everything (ignore file timestamps)]" \
    "--compiler=[specify the compiler type]" \
    "-c[specify the compiler type]" \
    "--swig-cpp[make SWIG create C++ files (default is C)]" \
    "--swig-opts=[list of SWIG command line options]" \
    "--swig=[path to the SWIG executable]" \
    "--user[add user include, library and rpath]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_build_clib] )) ||
_setuppy_build_clib() {
  _arguments -s \
    "--build-clib=[directory to build C/C++ libraries to]" \
    "-b[directory to build C/C++ libraries to]" \
    "--build-temp=[directory to put temporary build by-products]" \
    "-t[directory to put temporary build by-products]" \
    "--debug[compile with debugging information]" \
    "-g[compile with debugging information]" \
    "--force[forcibly build everything (ignore file timestamps)]" \
    "-f[forcibly build everything (ignore file timestamps)]" \
    "--compiler=[specify the compiler type]" \
    "-c[specify the compiler type]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_build_scripts] )) ||
_setuppy_build_scripts() {
  _arguments -s \
    "--build-dir=[directory to \"build\" (copy) to]" \
    "-d[directory to \"build\" (copy) to]" \
    "--force[forcibly build everything (ignore file timestamps]" \
    "-f[forcibly build everything (ignore file timestamps]" \
    "--executable=[specify final destination interpreter path]" \
    "-e[specify final destination interpreter path]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_clean] )) ||
_setuppy_clean() {
  _arguments -s \
    "--build-base=[base build directory (default: 'build.build-base')]" \
    "-b[base build directory (default: 'build.build-base')]" \
    "--build-lib=[build directory for all modules (default: 'build.build-lib')]" \
    "--build-temp=[temporary build directory (default: 'build.build-temp')]" \
    "-t[temporary build directory (default: 'build.build-temp')]" \
    "--build-scripts=[build directory for scripts (default: 'build.build-scripts')]" \
    "--bdist-base=[temporary directory for built distributions]" \
    "--all[remove all build output, not just temporary by-products]" \
    "-a[remove all build output, not just temporary by-products]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install] )) ||
_setuppy_install() {
  _arguments -s \
    "--prefix=[installation prefix]" \
    "--exec-prefix=[(Unix only) prefix for platform-specific files]" \
    "--home=[(Unix only) home directory to install under]" \
    "--user[install in user site-package]" \
    "--install-base=[base installation directory (instead of --prefix or --home)]" \
    "--install-platbase=[base installation directory for platform-specific files (instead of --exec-prefix or --home)]" \
    "--root=[install everything relative to this alternate root directory]" \
    "--install-purelib=[installation directory for pure Python module distributions]" \
    "--install-platlib=[installation directory for non-pure module distributions]" \
    "--install-lib=[installation directory for all module distributions (overrides --install-purelib and --install-platlib)]" \
    "--install-headers=[installation directory for C/C++ headers]" \
    "--install-scripts=[installation directory for Python scripts]" \
    "--install-data=[installation directory for data files]" \
    "--compile[compile .py to .pyc \[default\]]" \
    "-c[compile .py to .pyc \[default\]]" \
    "--no-compile[don't compile .py files]" \
    "--optimize=[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "-O[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "--force[force installation (overwrite any existing files)]" \
    "-f[force installation (overwrite any existing files)]" \
    "--skip-build[skip rebuilding everything (for testing/debugging)]" \
    "--record=[filename in which to record list of installed files]" \
    "--old-and-unmanageable[Try not to use this!]" \
    "--single-version-externally-managed[used by system package builders to create 'flat' eggs]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install_lib] )) ||
_setuppy_install_lib() {
  _arguments -s \
    "--install-dir=[directory to install to]" \
    "-d[directory to install to]" \
    "--build-dir=[build directory (where to install from)]" \
    "-b[build directory (where to install from)]" \
    "--force[force installation (overwrite existing files)]" \
    "-f[force installation (overwrite existing files)]" \
    "--compile[compile .py to .pyc \[default\]]" \
    "-c[compile .py to .pyc \[default\]]" \
    "--no-compile[don't compile .py files]" \
    "--optimize=[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "-O[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "--skip-build[skip the build steps]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install_headers] )) ||
_setuppy_install_headers() {
  _arguments -s \
    "--install-dir=[directory to install header files to]" \
    "-d[directory to install header files to]" \
    "--force[force installation (overwrite existing files)]" \
    "-f[force installation (overwrite existing files)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install_scripts] )) ||
_setuppy_install_scripts() {
  _arguments -s \
    "--install-dir=[directory to install scripts to]" \
    "-d[directory to install scripts to]" \
    "--build-dir=[build directory (where to install from)]" \
    "-b[build directory (where to install from)]" \
    "--force[force installation (overwrite existing files)]" \
    "-f[force installation (overwrite existing files)]" \
    "--skip-build[skip the build steps]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install_data] )) ||
_setuppy_install_data() {
  _arguments -s \
    "--install-dir=[base directory for installing data files (default: installation base dir)]" \
    "-d[base directory for installing data files (default: installation base dir)]" \
    "--root=[install everything relative to this alternate root directory]" \
    "--force[force installation (overwrite existing files)]" \
    "-f[force installation (overwrite existing files)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_sdist] )) ||
_setuppy_sdist() {
  _arguments -s \
    "--formats=[formats for source distribution (comma-separated list)]" \
    "--keep-temp[keep the distribution tree around after creating archive file(s)]" \
    "-k[keep the distribution tree around after creating archive file(s)]" \
    "--dist-dir=[directory to put the source distribution archive(s) in \[default: dist\]]" \
    "-d[directory to put the source distribution archive(s) in \[default: dist\]]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_register] )) ||
_setuppy_register() {
  _arguments -s \
    "--repository=[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "-r[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "--show-response[display full response text from server]" \
    "--list-classifiers[list the valid Trove classifiers]" \
    "--strict[Will stop the registering if the meta-data are not fully compliant]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_bdist] )) ||
_setuppy_bdist() {
  _arguments -s \
    "--bdist-base=[temporary directory for creating built distributions]" \
    "-b[temporary directory for creating built distributions]" \
    "--plat-name=[platform name to embed in generated filenames (default: linux-i686)]" \
    "-p[platform name to embed in generated filenames (default: linux-i686)]" \
    "--formats=[formats for distribution (comma-separated list)]" \
    "--dist-dir=[directory to put final built distributions in \[default: dist\]]" \
    "-d[directory to put final built distributions in \[default: dist\]]" \
    "--skip-build[skip rebuilding everything (for testing/debugging)]" \
    "--owner=[Owner name used when creating a tar file \[default: current user\]]" \
    "-u[Owner name used when creating a tar file \[default: current user\]]" \
    "--group=[Group name used when creating a tar file \[default: current group\]]" \
    "-g[Group name used when creating a tar file \[default: current group\]]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_bdist_dumb] )) ||
_setuppy_bdist_dumb() {
  _arguments -s \
    "--bdist-dir=[temporary directory for creating the distribution]" \
    "-d[temporary directory for creating the distribution]" \
    "--plat-name=[platform name to embed in generated filenames (default: linux-i686)]" \
    "-p[platform name to embed in generated filenames (default: linux-i686)]" \
    "--format=[archive format to create (tar, ztar, gztar, zip)]" \
    "-f[archive format to create (tar, ztar, gztar, zip)]" \
    "--keep-temp[keep the pseudo-installation tree around after creating the distribution archive]" \
    "-k[keep the pseudo-installation tree around after creating the distribution archive]" \
    "--dist-dir=[directory to put final built distributions in]" \
    "-d[directory to put final built distributions in]" \
    "--skip-build[skip rebuilding everything (for testing/debugging)]" \
    "--relative[build the archive using relative paths(default: false)]" \
    "--owner=[Owner name used when creating a tar file \[default: current user\]]" \
    "-u[Owner name used when creating a tar file \[default: current user\]]" \
    "--group=[Group name used when creating a tar file \[default: current group\]]" \
    "-g[Group name used when creating a tar file \[default: current group\]]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_bdist_rpm] )) ||
_setuppy_bdist_rpm() {
  _arguments -s \
    "--bdist-base=[base directory for creating built distributions]" \
    "--rpm-base=[base directory for creating RPMs (defaults to \"rpm\" under --bdist-base; must be specified for RPM 2)]" \
    "--dist-dir=[directory to put final RPM files in (and .spec files if --spec-only)]" \
    "-d[directory to put final RPM files in (and .spec files if --spec-only)]" \
    "--python=[path to Python interpreter to hard-code in the .spec file (default: \"python\")]" \
    "--fix-python[hard-code the exact path to the current Python interpreter in the .spec file]" \
    "--spec-only[only regenerate spec file]" \
    "--source-only[only generate source RPM]" \
    "--binary-only[only generate binary RPM]" \
    "--use-bzip2[use bzip2 instead of gzip to create source distribution]" \
    "--distribution-name=[name of the (Linux) distribution to which this RPM applies (*not* the name of the module distribution!)]" \
    "--group=[package classification \[default: \"Development/Libraries\"\]]" \
    "--release=[RPM release number]" \
    "--serial=[RPM serial number]" \
    "--vendor=[RPM \"vendor\" (eg. \"Joe Blow <joe@example.com>\") \[default: maintainer or author from setup script\]]" \
    "--packager=[RPM packager (eg. \"Jane Doe <jane@example.net>\")\[default: vendor\]]" \
    "--doc-files=[list of documentation files (space or comma-separated)]" \
    "--changelog=[RPM changelog]" \
    "--icon=[name of icon file]" \
    "--provides=[capabilities provided by this package]" \
    "--requires=[capabilities required by this package]" \
    "--conflicts=[capabilities which conflict with this package]" \
    "--build-requires=[capabilities required to build this package]" \
    "--obsoletes=[capabilities made obsolete by this package]" \
    "--no-autoreq[do not automatically calculate dependencies]" \
    "--keep-temp[don't clean up RPM build directory]" \
    "-k[don't clean up RPM build directory]" \
    "--no-keep-temp[clean up RPM build directory \[default\]]" \
    "--use-rpm-opt-flags[compile with RPM_OPT_FLAGS when building from source RPM]" \
    "--no-rpm-opt-flags[do not pass any RPM CFLAGS to compiler]" \
    "--rpm3-mode[RPM 3 compatibility mode (default)]" \
    "--rpm2-mode[RPM 2 compatibility mode]" \
    "--prep-script=[Specify a script for the PREP phase of RPM building]" \
    "--build-script=[Specify a script for the BUILD phase of RPM building]" \
    "--pre-install=[Specify a script for the pre-INSTALL phase of RPM building]" \
    "--install-script=[Specify a script for the INSTALL phase of RPM building]" \
    "--post-install=[Specify a script for the post-INSTALL phase of RPM building]" \
    "--pre-uninstall=[Specify a script for the pre-UNINSTALL phase of RPM building]" \
    "--post-uninstall=[Specify a script for the post-UNINSTALL phase of RPM building]" \
    "--clean-script=[Specify a script for the CLEAN phase of RPM building]" \
    "--verify-script=[Specify a script for the VERIFY phase of the RPM build]" \
    "--force-arch=[Force an architecture onto the RPM build process]" \
    "--quiet[Run the INSTALL phase of RPM building in quiet mode]" \
    "-q[Run the INSTALL phase of RPM building in quiet mode]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_bdist_wininst] )) ||
_setuppy_bdist_wininst() {
  _arguments -s \
    "--bdist-dir=[temporary directory for creating the distribution]" \
    "--plat-name=[platform name to embed in generated filenames (default: linux-i686)]" \
    "-p[platform name to embed in generated filenames (default: linux-i686)]" \
    "--keep-temp[keep the pseudo-installation tree around after creating the distribution archive]" \
    "-k[keep the pseudo-installation tree around after creating the distribution archive]" \
    "--target-version=[require a specific python version on the target system]" \
    "--no-target-compile[do not compile .py to .pyc on the target system]" \
    "-c[do not compile .py to .pyc on the target system]" \
    "--no-target-optimize[do not compile .py to .pyo (optimized)on the target system]" \
    "-o[do not compile .py to .pyo (optimized)on the target system]" \
    "--dist-dir=[directory to put final built distributions in]" \
    "-d[directory to put final built distributions in]" \
    "--bitmap=[bitmap to use for the installer instead of python-powered logo]" \
    "-b[bitmap to use for the installer instead of python-powered logo]" \
    "--title=[title to display on the installer background instead of default]" \
    "-t[title to display on the installer background instead of default]" \
    "--skip-build[skip rebuilding everything (for testing/debugging)]" \
    "--install-script=[basename of installation script to be run after installation or before uninstallation]" \
    "--pre-install-script=[Fully qualified filename of a script to be run before any files are installed.  This script need not be in the distribution]" \
    "--user-access-control=[specify Vista's UAC handling - 'none'/default=no handling, 'auto'=use UAC if target Python installed for all users, 'force'=always use UAC]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_upload] )) ||
_setuppy_upload() {
  _arguments -s \
    "--repository=[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "-r[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "--show-response[display full response text from server]" \
    "--sign[sign files to upload using gpg]" \
    "-s[sign files to upload using gpg]" \
    "--identity=[GPG identity used to sign files]" \
    "-i[GPG identity used to sign files]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_check] )) ||
_setuppy_check() {
  _arguments -s \
    "--metadata[Verify meta-data]" \
    "-m[Verify meta-data]" \
    "--restructuredtext[Checks if long string meta-data syntax are reStructuredText-compliant]" \
    "-r[Checks if long string meta-data syntax are reStructuredText-compliant]" \
    "--strict[Will exit with an error if a check fails]" \
    "-s[Will exit with an error if a check fails]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_alias] )) ||
_setuppy_alias() {
  _arguments -s \
    "--remove[remove (unset) the alias]" \
    "-r[remove (unset) the alias]" \
    "--global-config[save options to the site-wide distutils.cfg file]" \
    "-g[save options to the site-wide distutils.cfg file]" \
    "--user-config[save options to the current user's pydistutils.cfg file]" \
    "-u[save options to the current user's pydistutils.cfg file]" \
    "--filename=[configuration file to use (default=setup.cfg)]" \
    "-f[configuration file to use (default=setup.cfg)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_bdist_egg] )) ||
_setuppy_bdist_egg() {
  _arguments -s \
    "--bdist-dir=[temporary directory for creating the distribution]" \
    "-b[temporary directory for creating the distribution]" \
    "--plat-name=[platform name to embed in generated filenames (default: linux-i686)]" \
    "-p[platform name to embed in generated filenames (default: linux-i686)]" \
    "--exclude-source-files[remove all .py files from the generated egg]" \
    "--keep-temp[keep the pseudo-installation tree around after creating the distribution archive]" \
    "-k[keep the pseudo-installation tree around after creating the distribution archive]" \
    "--dist-dir=[directory to put final built distributions in]" \
    "-d[directory to put final built distributions in]" \
    "--skip-build[skip rebuilding everything (for testing/debugging)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_develop] )) ||
_setuppy_develop() {
  _arguments -s \
    "--prefix=[installation prefix]" \
    "--zip-ok[install package as a zipfile]" \
    "-z[install package as a zipfile]" \
    "--multi-version[make apps have to require() a version]" \
    "-m[make apps have to require() a version]" \
    "--upgrade[force upgrade (searches PyPI for latest versions)]" \
    "-U[force upgrade (searches PyPI for latest versions)]" \
    "--install-dir=[install package to DIR]" \
    "-d[install package to DIR]" \
    "--script-dir=[install scripts to DIR]" \
    "-s[install scripts to DIR]" \
    "--exclude-scripts[Don't install scripts]" \
    "-x[Don't install scripts]" \
    "--always-copy[Copy all needed packages to install dir]" \
    "-a[Copy all needed packages to install dir]" \
    "--index-url=[base URL of Python Package Index]" \
    "-i[base URL of Python Package Index]" \
    "--find-links=[additional URL(s) to search for packages]" \
    "-f[additional URL(s) to search for packages]" \
    "--build-directory=[download/extract/build in DIR; keep the results]" \
    "-b[download/extract/build in DIR; keep the results]" \
    "--optimize=[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "-O[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "--record=[filename in which to record list of installed files]" \
    "--always-unzip[don't install as a zipfile, no matter what]" \
    "-Z[don't install as a zipfile, no matter what]" \
    "--site-dirs=[list of directories where .pth files work]" \
    "-S[list of directories where .pth files work]" \
    "--editable[Install specified packages in editable form]" \
    "-e[Install specified packages in editable form]" \
    "--no-deps[don't install dependencies]" \
    "-N[don't install dependencies]" \
    "--allow-hosts=[pattern(s) that hostnames must match]" \
    "-H[pattern(s) that hostnames must match]" \
    "--local-snapshots-ok[allow building eggs from local checkouts]" \
    "-l[allow building eggs from local checkouts]" \
    "--version[print version information and exit]" \
    "--no-find-links[Don't load find-links defined in packages being installed]" \
    "--user[install in user site-package]" \
    "--uninstall[Uninstall this source package]" \
    "-u[Uninstall this source package]" \
    "--egg-path=[Set the path to be used in the .egg-link file]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_easy_install] )) ||
_setuppy_easy_install() {
  _arguments -s \
    "--prefix=[installation prefix]" \
    "--zip-ok[install package as a zipfile]" \
    "-z[install package as a zipfile]" \
    "--multi-version[make apps have to require() a version]" \
    "-m[make apps have to require() a version]" \
    "--upgrade[force upgrade (searches PyPI for latest versions)]" \
    "-U[force upgrade (searches PyPI for latest versions)]" \
    "--install-dir=[install package to DIR]" \
    "-d[install package to DIR]" \
    "--script-dir=[install scripts to DIR]" \
    "-s[install scripts to DIR]" \
    "--exclude-scripts[Don't install scripts]" \
    "-x[Don't install scripts]" \
    "--always-copy[Copy all needed packages to install dir]" \
    "-a[Copy all needed packages to install dir]" \
    "--index-url=[base URL of Python Package Index]" \
    "-i[base URL of Python Package Index]" \
    "--find-links=[additional URL(s) to search for packages]" \
    "-f[additional URL(s) to search for packages]" \
    "--build-directory=[download/extract/build in DIR; keep the results]" \
    "-b[download/extract/build in DIR; keep the results]" \
    "--optimize=[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "-O[also compile with optimization: -O1 for \"python -O\", -O2 for \"python -OO\", and -O0 to disable \[default: -O0\]]" \
    "--record=[filename in which to record list of installed files]" \
    "--always-unzip[don't install as a zipfile, no matter what]" \
    "-Z[don't install as a zipfile, no matter what]" \
    "--site-dirs=[list of directories where .pth files work]" \
    "-S[list of directories where .pth files work]" \
    "--editable[Install specified packages in editable form]" \
    "-e[Install specified packages in editable form]" \
    "--no-deps[don't install dependencies]" \
    "-N[don't install dependencies]" \
    "--allow-hosts=[pattern(s) that hostnames must match]" \
    "-H[pattern(s) that hostnames must match]" \
    "--local-snapshots-ok[allow building eggs from local checkouts]" \
    "-l[allow building eggs from local checkouts]" \
    "--version[print version information and exit]" \
    "--no-find-links[Don't load find-links defined in packages being installed]" \
    "--user[install in user site-package]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_egg_info] )) ||
_setuppy_egg_info() {
  _arguments -s \
    "--egg-base=[directory containing .egg-info directories (default: top of the source tree)]" \
    "-e[directory containing .egg-info directories (default: top of the source tree)]" \
    "--tag-svn-revision[Add subversion revision ID to version number]" \
    "-r[Add subversion revision ID to version number]" \
    "--tag-date[Add date stamp (e.g. 20050528) to version number]" \
    "-d[Add date stamp (e.g. 20050528) to version number]" \
    "--tag-build=[Specify explicit tag to add to version number]" \
    "-b[Specify explicit tag to add to version number]" \
    "--no-svn-revision[Don't add subversion revision ID \[default\]]" \
    "-R[Don't add subversion revision ID \[default\]]" \
    "--no-date[Don't include date stamp \[default\]]" \
    "-D[Don't include date stamp \[default\]]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_rotate] )) ||
_setuppy_rotate() {
  _arguments -s \
    "--match=[patterns to match (required)]" \
    "-m[patterns to match (required)]" \
    "--dist-dir=[directory where the distributions are]" \
    "-d[directory where the distributions are]" \
    "--keep=[number of matching distributions to keep]" \
    "-k[number of matching distributions to keep]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_saveopts] )) ||
_setuppy_saveopts() {
  _arguments -s \
    "--global-config[save options to the site-wide distutils.cfg file]" \
    "-g[save options to the site-wide distutils.cfg file]" \
    "--user-config[save options to the current user's pydistutils.cfg file]" \
    "-u[save options to the current user's pydistutils.cfg file]" \
    "--filename=[configuration file to use (default=setup.cfg)]" \
    "-f[configuration file to use (default=setup.cfg)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_setopt] )) ||
_setuppy_setopt() {
  _arguments -s \
    "--command=[command to set an option for]" \
    "-c[command to set an option for]" \
    "--option=[option to set]" \
    "-o[option to set]" \
    "--set-value=[value of the option]" \
    "-s[value of the option]" \
    "--remove[remove (unset) the value]" \
    "-r[remove (unset) the value]" \
    "--global-config[save options to the site-wide distutils.cfg file]" \
    "-g[save options to the site-wide distutils.cfg file]" \
    "--user-config[save options to the current user's pydistutils.cfg file]" \
    "-u[save options to the current user's pydistutils.cfg file]" \
    "--filename=[configuration file to use (default=setup.cfg)]" \
    "-f[configuration file to use (default=setup.cfg)]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_test] )) ||
_setuppy_test() {
  _arguments -s \
    "--test-module=[Run 'test_suite' in specified module]" \
    "-m[Run 'test_suite' in specified module]" \
    "--test-suite=[Test suite to run (e.g. 'some_module.test_suite')]" \
    "-s[Test suite to run (e.g. 'some_module.test_suite')]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_install_egg_info] )) ||
_setuppy_install_egg_info() {
  _arguments -s \
    "--install-dir=[directory to install to]" \
    "-d[directory to install to]" \
    "*::setup.py commands:_setup.py"
}

(( $+functions[_setuppy_upload_docs] )) ||
_setuppy_upload_docs() {
  _arguments -s \
    "--repository=[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "-r[url of repository \[default: http://pypi.python.org/pypi\]]" \
    "--show-response[display full response text from server]" \
    "--upload-dir=[directory to upload]" \
    "*::setup.py commands:_setup.py"
}

_setup.py "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
