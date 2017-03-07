script_root=${0:a:h}

_mongodbs() {
	compadd $(mongo --quiet $script_root/load_databases.js)
}
compdef _mongodbs mongo

