function shell_proxy_promt_info() {
    if [ ${http_proxy} ] || [ ${https_proxy} ] ; then
        echo " "
    fi

    return 0
}
