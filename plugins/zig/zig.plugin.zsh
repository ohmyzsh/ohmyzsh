
# Zig as C & CXX compiler (clang wrapper)
export ZCC="zig cc -fno-sanitize=all -lc"
export ZCXX="zig c++ -fno-sanitize=all -lc -lc++"

# Zig build-system project
alias zbuild="zig build"
alias zbuildrun="zig build run"
alias zbuildtest="zig build test"
alias zbuildexe="zig init-exe"
alias zbuildlib="zig init-lib"

# Other Commands
alias zfmt="zig fmt"
alias zlint="zig ast-check"
alias c2zig="zig translate-c"
alias ztest="zig test"
alias zrun="zig run"
alias zversion="zig version"

alias zfind='find . -name "*.zig"'
