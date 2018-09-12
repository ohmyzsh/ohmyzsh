#compdef scala scalac
# ------------------------------------------------------------------------------
# Copyright (c) 2012 Github zsh-users - https://github.com/zsh-users
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the zsh-users nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ZSH-USERS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for scala and scalac (https://www.scala-lang.org/).
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Tony Sloane <inkytonik@gmail.com>
#
# ------------------------------------------------------------------------------

typeset -A opt_args
local context state line

_scala_features () {
   compadd "postfixOps" "reflectiveCalls" "implicitConversions" "higherKinds" \
     "existentials" "experimental.macros" "_"
}

_scala_phases () {
   compadd "parser" "namer" "packageobjects" "typer" "patmat" "superaccessors" \
     "extmethods" "pickler" "refchecks" "selectiveanf" "selectivecps" "uncurry" \
     "tailcalls" "specialize" "explicitouter" "erasure" "posterasure" "lazyvals" \
     "lambdalift" "constructors" "flatten" "mixin" "cleanup" "icode" "inliner" \
     "inlineExceptionHandlers" "closelim" "dce" "jvm" "terminal"
}

local -a shared_opts
shared_opts=(
  "-bootclasspath+[Override location of bootstrap class files]:bootstrap class directory:_files -/"
  "-classpath+[Specify where to find user class files]:directory:_files -/"
  "-D-[Pass -Dproperty=value directly to the runtime system]"
  "-d+[Destination for generated classfiles]: directory or jar file:_files"
  "-dependencyfile+[Set dependency tracking file]:dependency tracking file:_files"
  "-deprecation[Emit warning and location for usages of deprecated APIs]"
  "-encoding+[Specify character encoding used by source files]:encoding:"
  "-explaintypes[Explain type errors in more detail]"
  "-extdirs+[Override location of installed extensions]:extensions directory:_files -/"
  "-g\:-[Set level of generated debugging info (default\: vars)]:debugging info level:(none source line vars notailcalls)"
  "-help[Print a synopsis of standard options]"
  "-J-[pass argument directly to Java runtime system]:JVM argument:"
  "-javabootclasspath+[Override java boot classpath]:Java boot class path directory]:_files -/"
  "-javaextdirs+[Override java extdirs classpath]:Java extdirs directory:_files -/"
  "-language\:-[Enable one or more language features]:feature:_scala_features"
  "-no-specialization[Ignore @specialize annotations]"
  "-nobootcp[Do not use the boot classpath for the scala jars]"
  "-nowarn[Generate no warnings]"
  "-optimise[Generate faster bytecode by applying optimisations to the program]"
  "-P\:-[Pass an option to a plugin (written plugin\:opt)]:plugin option:"
  "-print[Print program with Scala-specific features removed]"
  "-sourcepath+[Specify location(s) of source files]:source file directory:_files -/"
  "-target\:-[Target platform for object files (default\: jvm-1.5)]:platform name:(jvm-1.5 msil)"
  "-toolcp+[Add to the runner classpath]:directory:_files -/"
  "-unchecked[Enable detailed unchecked (erasure) warnings]"
  "-uniqid[Uniquely tag all identifiers in debugging output]"
  "-usejavacp[Utilize the java.class.path in classpath resolution]"
  "-verbose[Output messages about what the compiler is doing]"
  "-version[Print product version and exit]"
  "-X[Print a synopsis of advanced options]"
  "-Y[Print a synopsis of private options]"
)

local -a X_opts
X_opts=(
  "-Xcheck-null[Warn upon selection of nullable reference]"
  "-Xcheckinit[Wrap field accessors to throw an exception on uninitialized access]"
  "-Xdisable-assertions[Generate no assertions or assumptions]"
  "-Xelide-below+[Calls to @elidable methods are omitted if method priority is lower than integer argument]"
  "-Xexperimental[Enable experimental extensions]"
  "-Xfatal-warnings[Fail the compilation if there are any warnings]"
  "-Xfull-lubs[Retains pre 2.10 behavior of less aggressive truncation of least upper bounds]"
  "-Xfuture[Turn on future language features]"
  "-Xgenerate-phase-graph+[Generate the phase graphs (outputs .dot files) to fileX.dot]:output file:_files"
  "-Xlint[Enable recommended additional warnings]"
  "-Xlog-free-terms[Print a message when reification creates a free term]"
  "-Xlog-free-types[Print a message when reification resorts to generating a free type]"
  "-Xlog-implicits[Show more detail on why some implicits are not applicable]"
  "-Xlog-implicit-conversions[Print a message whenever an implicit conversion is inserted]"
  "-Xlog-reflective-calls[Print a message when a reflective method call is generated]"
  "-Xmacro-settings\:-[Custom settings for macros]:option"
  "-Xmain-class+[Class for manifest's Main-Class entry (only useful with -d jar)]:path:"
  "-Xmax-classfile-name+[Maximum filename length for generated classes]"
  "-Xmigration[Warn about constructs whose behavior may have changed]"
  "-Xno-forwarders[Do not generate static forwarders in mirror classes]"
  "-Xno-patmat-analysis[Don't perform exhaustivity/unreachability analysis. Also, ignore @switch annotation]"
  "-Xno-uescape[Disable handling of \u unicode escapes]"
  "-Xnojline[Do not use JLine for editing]"
  "-Xoldpatmat[Use the pre-2.10 pattern matcher. Otherwise, the 'virtualizing' pattern matcher is used in 2.10]"
  "-Xprint\:-[Print out program after <phase>]:phase name:_scala_phases"
  "-Xprint-icode\:-[Log internal icode to *.icode files after phase (default\: icode)]:phase name:_scala_phases"
  "-Xprint-pos[Print tree positions, as offsets]"
  "-Xprint-types[Print tree types (debugging option)]"
  "-Xprompt[Display a prompt after each error (debugging option)]"
  "-Xresident[Compiler stays resident: read source filenames from standard input]"
  "-Xscript+[Treat the source file as a script and wrap it in a main method]:main object name"
  "-Xshow-class+[Show internal representation of class]:class name"
  "-Xshow-object+[Show internal representation of object]:object name"
  "-Xshow-phases[Print a synopsis of compiler phases]"
  "-Xsource-reader+[Specify a class name for a custom method of reading source files]:class name"
  "-Xverify[Verify generic signatures in generated bytecode]"

  "-Xassem-extdirs+[List of directories containing assemblies (requires -target:msil) (default\: lib)]:assembly directory:_files -/"
  "-Xassem-name+[Name of the output assembly (requires -target:msil)]:assembly name:_files"
  "-Xassem-path+[List of assemblies referenced by the program (requires -target:msil)]:assembly path:_files"
  "-Xsourcedir+[Mirror source folder structure in output directory (requires -target:msil)]:source directory:_files -/"

  "-Xplugin\:-[Load one or more plugins from file]:plugin file:_files"
  "-Xpluginsdir+[Path to search compiler plugins]:plugin directory:_files -/"
  "-Xplugin-list[Print a synopsis of loaded plugins]"
  "-Xplugin-disable\:-[Disable the given plugin(s)]"
  "-Xplugin-require\:-[Abort unless the given plugin(s) are available]"
)

local -a Y_opts
Y_opts=(
  "-Y[Print a synopsis of private options]"
  "-Ybuild-manager-debug[Generate debug information for the Refined Build Manager compiler]"
  "-Ybuilder-debug\:-[Compile using the specified build manager (default\: none)]:build manager:(none refined simple)"
  "-Yclosure-elim[Perform closure elimination]"
  "-Ycompact-trees[Use compact tree printer when displaying trees]"
  "-Ydead-code[Perform dead code elimination]"
  "-Ydependent-method-types[Allow dependent method types]"
  "-Ydump-classes+[Dump the generated bytecode to .class files (useful for reflective compilation that utilizes in-memory classloaders)]:output directory:_files -/"
  "-Yeta-expand-keeps-star[Eta-expand varargs methods to T* rather than Seq[T].  This is a temporary option to ease transition.]"
  "-Ygen-javap+[Generate a parallel output directory of .javap files]:output directory:_files -/"
  "-Yinfer-argument-types[Infer types for arguments of overridden methods]"
  "-Yinline[Perform inlining when possible]"
  "-Yinline-handlers[Perform exception handler inlining when possible]"
  "-Yinline-warnings[Emit inlining warnings (normally suppressed due to high volume)]"
  "-Yinvalidate+[Invalidate classpath entry before run]:classpath entry"
  "-Ylinearizer\:-[Linearizer to use (default\: rpo)]:linearizer:(normal dfs rpo dump)"
  "-Ylog-classpath[Output information about what classpath is being applied]"
  "-Yno-adapted-args[Do not adapt an argument list (either by inserting unit or creating a tuple) to match the receiver]"
  "-Ymacro-debug-lite[Trace essential macro-related activities]"
  "-Ymacro-debug-verbose[Trace all macro-related activities: compilation, generation of synthetics, classloading, expansion, exceptions]"
  "-Yno-completion[Disable tab-completion in the REPL]"
  "-Yno-generic-signatures[Suppress generation of generic signatures for Java]"
  "-Yno-imports[Compile without any implicit imports]"
  "-Yno-predef[Compile without importing Predef]"
  "-Yno-self-type-checks[Suppress check for self-type conformance among inherited members]"
  "-Yno-squeeze[Disable creation of compact code in matching]"
  "-Ynotnull[Enable (experimental and incomplete) scala.NotNull]"
  "-Yoverride-objects[Allow member objects to be overridden]"
  "-Yoverride-vars[Allow vars to be overridden]"
  "-Ypmat-naive[Desugar matches as naively as possible]"
  "-Ypresentation-delay+[Wait number of ms after typing before starting typechecking]"
  "-Ypresentation-log+[Log presentation compiler events into file]:log file:_files"
  "-Ypresentation-replay+[Replay presentation compiler events from file]:log file:_files"
  "-Ypresentation-strict[Do not report type errors in sources with syntax errors]"
  "-Ypresentation-verbose[Print information about presentation compiler tasks]"
  "-Yprofile-class+[Specify name of profiler class]:profiler class name"
  "-Yprofile-memory[Heap snapshot after compiler run (requires jgpagent on JVM -agentpath)]"
  "-Yrangepos[Use range positions for syntax trees]"
  "-Yrecursion+[Set recursion depth used when locking symbols]"
  "-Yreify-copypaste[Dump the reified trees in copypasteable representation]"
  "-Yrepl-sync[Do not use asynchronous code for REPL startup]"
  "-Yresolve-term-conflict\:-[Resolve term conflicts (default\: error)]:resolution strategy:(package object error)"
  "-Yself-in-annots[Include a \"self\" identifier inside of annotations]"
  "-Yshow\:-[Show after <phase> (requires -Xshow-class or -Xshow-object)]:phase name:_scala_phases"
  "-Yshow-syms[Print the AST symbol hierarchy after each phase]"
  "-Yshow-symkinds[Print abbreviated symbol kinds next to symbol names]"
  "-Yshow-trees[Print detailed ASTs (requires -Xprint\:phase)]"
  "-Yshow-trees-compact[Print detailed ASTs in compact form (requires -Xprint\:)]"
  "-Yshow-trees-stringified[Print stringifications along with detailed ASTs (requires -Xprint\:)]"
  "-Ystatistics[Print compiler statistics]"
  "-Ystruct-dispatch\:-[Structural method dispatch policy (default\: poly-cache)]:policy name:(no-cache mono-cache poly-cache invoke-dynamic)"

  "-Ybrowse\:-[Browse the abstract syntax tree after <phase>]:phase name:_scala_phases"
  "-Ycheck\:-[Check the tree at the end of <phase>]:phase name:_scala_phases"
  "-Ylog\:-[Log operations during <phase>]:phase name:_scala_phases"
  "-Yprofile\:-[Profile CPU usage of given phases (requires jgpagent on JVM -agentpath)]:phase name:_scala_phases"
  "-Yskip\:-[Skip <phase>]:phase name:_scala_phases"
  "-Ystop-after\:-[Stop after given phase <phase>]:phase name:_scala_phases"
  "-Ystop-before\:-[Stop before given phase <phase>]:phase name:_scala_phases"

  "-Ywarn-adapted-args[Warn if an argument list is modified to match the receiver]"
  "-Ywarn-all[Enable all -Y warnings]"
  "-Ywarn-dead-code[Warn when dead code is identified]"
  "-Ywarn-inaccessible[Warn about inaccessible types in method signatures]"
  "-Ywarn-nullary-override[Warn when non-nullary overrides nullary, e.g. def foo() over def foo]"
  "-Ywarn-nullary-unit[Warn when nullary methods return Unit]"
  "-Ywarn-numeric-widen[Warn when numerics are widened]"
  "-Ywarn-value-discard[Warn when non-Unit expression results are unused]"

  "-Ybuild-manager-debug[Generate debug information for the Refined Build Manager compiler]"
  "-Ybuilder-debug\:-[Compile using the specified build manager (default\: none)]:manager:(none refined simple)"
  "-Ycompletion-debug[Trace all tab completion activity]"
  "-Ydebug[Increase the quantity of debugging output]"
  "-Ydoc-debug[Trace all scaladoc activity]"
  "-Yide-debug[Generate, validate and output trees using the interactive compiler]"
  "-Yinfer-debug[Trace type inference and implicit search]"
  "-Yissue-debug[Print stack traces when a context issues an error]"
  "-Ypatmat-debug[Trace pattern matching translation]"
  "-Ypmat-debug[Trace all pattern matcher activity]"
  "-Ypos-debug[Trace position validation]"
  "-Ypresentation-debug[Enable debugging output for the presentation compiler]"
  "-Yreify-debug[Trace reification]"
  "-Yrepl-debug[Trace all REPL activity]"
  "-Ytyper-debug[Trace all type assignments]"
)

local -a scala_opts
scala_opts=(
  "-e+[execute <string> as if entered in the repl]:string" \
  "-howtorun+[what to run (default\: guess)]:execution mode:(script object jar guess)" \
  "-i+[preload <file> before starting the repl]:file to preload:_files" \
  "-nc[no compilation daemon\: do not use the fsc offline compiler]" \
  "-save[save the compiled script in a jar for future use]"
)

case $words[$CURRENT] in
    -X*) _arguments $X_opts;;
    -Y*) _arguments $Y_opts;;
      *) case $service in
           scala)  _arguments $scala_opts $shared_opts "*::filename:_files";;
           scalac) _arguments $shared_opts "*::filename:_files";;
         esac
esac

return 0
