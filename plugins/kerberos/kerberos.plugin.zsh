#Execute a command without a kerberos ccache.
function nok () {
    KRB5CCNAME='' $*
}
