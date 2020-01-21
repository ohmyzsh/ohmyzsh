function mvn {
	if [ -x ./mvnw ]; then
		./mvnw "$@"
	else
		docker run -it --rm \
    -v $(pwd):$(pwd) \
    -v ${ZSH_MVN_USER_HOME:-$HOME/.m2}:/.m2 \
    -w $(pwd) \
    -u $(id -u) \
    -e MAVEN_CONFIG=/.m2 \
    ${ZSH_MAVEN_IMAGE:-maven:latest} \
    mvn -Duser.home=/ "$@"
	fi
}
