# TODO: Don't do this in such a weird way.
export PATH=`echo $PATH | sed -e 's|/usr/bin|/usr/local/share/npm/bin:&|'`
