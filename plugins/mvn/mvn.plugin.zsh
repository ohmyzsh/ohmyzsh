function listMavenCompletions { 
	 reply=(
		cli:execute cli:execute-phase archetype:generate generate-sources compile clean install test test-compile deploy package cobertura:cobertura jetty:run gwt:run gwt:debug -DskipTests -Dmaven.test.skip=true -DarchetypeCatalog=http://tapestry.formos.com/maven-snapshot-repository -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`); 
}

compctl -K listMavenCompletions mvn