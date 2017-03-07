dbs = db.adminCommand( {listDatabases: 1} ).databases;

for(var i = 0; i < dbs.length; i++) {
	print(dbs[i].name);
}
