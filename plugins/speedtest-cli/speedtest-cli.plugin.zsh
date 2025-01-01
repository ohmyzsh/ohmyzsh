_speedtest_cli_completions() {
    local state
    typeset -A opt_args

    _arguments \
        '--no-download[Do not perform download test]' \
        '--no-upload[Do not perform upload test]' \
        '--single[Only use a single connection instead of multiple]' \
        '--bytes[Display values in bytes instead of bits]' \
        '--share[Generate a URL to the speedtest.net share results image]' \
        '--simple[Suppress verbose output, only show basic information]' \
        '--csv[Suppress verbose output, only show basic information in CSV format]' \
        '--csv-delimiter[Single character delimiter for CSV output]:delimiter:,' \
        '--csv-header[Print CSV headers]' \
        '--json[Suppress verbose output, show basic information in JSON format]' \
        '--list[Display a list of speedtest.net servers sorted by distance]' \
        '--server[Specify a server ID to test against]:server ID:' \
        '--exclude[Exclude a server from selection]:server ID:' \
        '--mini[URL of the Speedtest Mini server]:URL:' \
        '--source[Source IP address to bind to]:IP address:' \
        '--timeout[HTTP timeout in seconds]:timeout in seconds:' \
        '--secure[Use HTTPS instead of HTTP for speedtest.net servers]' \
        '--no-pre-allocate[Do not pre-allocate upload data]' \
        '--version[Show the version number and exit]'
}

compdef _speedtest_cli_completions speedtest-cli
