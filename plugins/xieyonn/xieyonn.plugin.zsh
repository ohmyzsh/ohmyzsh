function shell_proxy_promt_info() {
    if [ ${http_proxy} ] || [ ${https_proxy} ] ; then
        echo "  "
    fi

    return 0
}

alias gtidy='git reset --hard && git clean -df'
