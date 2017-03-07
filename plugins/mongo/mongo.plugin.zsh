_mongodbs() {
	mypath=$(dirname $0)
	compadd $(mongo --quiet $mypath/load_databases.js)
}
compdef _mongodbs mongo

