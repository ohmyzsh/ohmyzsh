print -Pn '%F{yellow}'
cat >&2 <<-EOD
	nyan plugin:
	The nyancat server used by this plugin was shut down due to increased
	bandwidth costs, so the nyan plugin no longer works. You can get the
	same functionality in some distributions by installing the nyancat package,
	or you can compile it yourself.
	See https://github.com/klange/nyancat for more information.
EOD
print -Pn '%f'
