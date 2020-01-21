function gradle {
	if [ -x ./gradlew ] ; then
		./gradlew "$@"
	else
		docker run -it --rm \
    -v $(pwd):$(pwd) \
    -v ${GRADLE_USER_HOME:-$HOME/.gradle}:/.gradle \
    -w $(pwd) \
    -u $(id -u) \
    -e GRADLE_USER_HOME="/.gradle" \
    ${ZSH_GRADLE_IMAGE:-gradle:latest} \
    gradle "$@"
	fi
}
