# CanIUse.com Command Line Search Utility
# Michael Wales, http://github.com/walesmd
#
# A very basic bash function that quickly searches http://caniuse.com/
#
# Examples:
#     caniuse
#     caniuse border-radius
#     caniuse "alpha transparency" counters "canvas drawings" html svg

caniuse() {
    local domain="http://caniuse.com/"
    local query

    if [ $# -eq 0 ]; then
        open ${domain}
    else
        for term in "$@"; do
            query=$(python -c "import sys, urllib as ul; print ul.quote('${term}');")
            open "${domain}#search=${query}"
        done
    fi
}
