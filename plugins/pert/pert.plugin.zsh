#
# A simple utility to estimate tasks using PERT 
# (Program evaluation and review technique)
#

alias pert="pert.sh"

# helper cli calculator
_calc() {
    echo "scale=2; $@" | bc -l | sed 's/^\./0./'
    return 0
}

# divider row
_divider() {
    divider=------------------------------
    divider=" +"$divider$divider$divider"+"
    printf "%$_width.${_width}s+\n" "$divider"
    return 0
}

# show help for command list
_help() {
    print -P ""
    print -P "A command line PERT calculator for quick estimates."
    print -P ""
    print -P "Comma separated task list in the form \"1,2,12 4,5,9 2,3,6\"," 
    print -P "where whitespace separates tasks."
    print -P ""
    print -P "Usage:"
    print -P ""
    print -P "    pert [optimistic,realistic,pessimistic]"
    print -P ""
    print -P "Example:"
    print -P ""
    print -P "    pert 1,3,4"
    print -P "    pert 10,15,20 5,7,10"
    print -P "    pert \"1,2,3\" \"15,17,20\""
    print -P ""
    return 0
}

# header row
_table_header() {
    print -P ""
    print -P "Tasks"
    print -P ""
    _width=88
    _divider
    printf "$format" "#" "optimistic" "realistic" "pessimistic" "duration" "risk" "variance"
    _divider
    return 0
}

# footer summary row
_table_footer_sum() {
    printf "$format" "summary" "-" "-" "-" $total_estimate $total_standard_deviation $total_variance
    _divider
    return 0
}

# footer 3point row
_table_footer_tpe() {
    print -P ""
    print -P "Three point estimates"
    print -P ""
    
    _width=42 
    tpeformat=" | %-13s |%11s |%10s |\n"
    
    _divider
    printf "$tpeformat" "confidence"
    _divider
    printf "$tpeformat" "1 Sigma - 68%" $(_calc "$total_estimate - $total_standard_deviation") $(_calc "$total_estimate + $total_standard_deviation")
    printf "$tpeformat" "2 Sigma - 95%" $(_calc "$total_estimate - 2 * $total_standard_deviation") $(_calc "$total_estimate + 2 * $total_standard_deviation")
    printf "$tpeformat" "3 Sigma - 99%" $(_calc "$total_estimate - 3 * $total_standard_deviation") $(_calc "$total_estimate + 3 * $total_standard_deviation")
    _divider
    return 0
}

# main function
pert() {

    # help text
    if [ -z "$1" ] || [[ "$1" =~ [-]*(help|h) ]]; then
        _help
        return 1
    fi
    
    format=" | %-12s |%11s |%10s |%12s |%9s |%9s |%9s |\n"
    
    # header
    _table_header
    
    counter=0
    total_estimate=0
    total_standard_deviation=0
    total_variance=0
    for var in "$@"; do
        # counter iterator
        counter=$[$counter +1]
    
        # optimistic value
        o=${var[(ws:,:)1]}
        
        # realistic value
        r=${var[(ws:,:)2]}
        
        # pessimistic value
        p=${var[(ws:,:)3]}
        
        # check values
        if [ -z "$o" ] || [ -z "$r" ] || [ -z "$p" ]; then
            printf "$format" "$counter. bad input" $o $r $p
        else
            # pert estimate
            pert_estimate=$(_calc "($o+4*$r+$p)/6")
            total_estimate=$(_calc "$total_estimate + $pert_estimate") 
            
            # standard deviation
            standard_deviation=$(_calc "($p-$o)/6")
            total_standard_deviation=$(_calc "$total_standard_deviation + $standard_deviation")
    
            # variance
            variance=$(_calc "$standard_deviation * $standard_deviation")
            total_variance=$(_calc "$total_variance + $variance")
        
            # table row        
            printf "$format" "$counter. task" $o $r $p $pert_estimate $standard_deviation $variance
        fi
    done
    
    _divider
    
    # footer     
    if [[ $total_estimate > 0 ]]; then
        _table_footer_sum
        _table_footer_tpe
    fi
    
    print -P ""
    return 0
}

unset _width