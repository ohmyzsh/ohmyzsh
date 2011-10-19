_fab_list() {
    if [ ! -f fabfile.py ]; then return 0;
    else
         reply=(`fab --shortlist`)
    fi
}

compctl -K _fab_list fab
