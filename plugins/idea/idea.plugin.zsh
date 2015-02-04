local _idea_paths > /dev/null 2>&1
_idea_paths=(
    "$HOME/Applications/IntelliJ IDEA 14.app"
    "/Applications/IntelliJ IDEA 14.app"
    "$HOME/Applications/IntelliJ IDEA 13.app"
    "/Applications/IntelliJ IDEA 13.app"
    "$HOME/Applications/IntelliJ IDEA 12.app"
    "/Applications/IntelliJ IDEA 12.app"
    "$HOME/Applications/IntelliJ IDEA 14 CE.app"
    "/Applications/IntelliJ IDEA 14 CE.app"
    "$HOME/Applications/IntelliJ IDEA 13 CE.app"
    "/Applications/IntelliJ IDEA 13 CE.app"
    "$HOME/Applications/IntelliJ IDEA 12 CE.app"
    "/Applications/IntelliJ IDEA 12 CE.app"
)

for _idea_path in $_idea_paths; do
    if [[ -a $_idea_path ]]; then
        alias idea="open -a '$_idea_path'"
        break
    fi
done
