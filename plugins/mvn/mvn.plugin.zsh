# Calls mvnw if found in the current project, otherwise execute the original mvn
mvn-or-mvnw() {
  local dir="$PWD"
  while [[ ! -x "$dir/mvnw" && "$dir" != / ]]; do
    dir="${dir:h}"
  done

  if [[ -x "$dir/mvnw" ]]; then
    echo "Running \`$dir/mvnw\`..." >&2
    "$dir/mvnw" "$@"
    return $?
  fi

  command mvn "$@"
}

# Wrapper function for Maven's mvn command. Based on https://gist.github.com/1027800
mvn-color() {
  local BOLD=$(echoti bold)
  local TEXT_RED=$(echoti setaf 1)
  local TEXT_GREEN=$(echoti setaf 2)
  local TEXT_YELLOW=$(echoti setaf 3)
  local TEXT_BLUE=$(echoti setaf 4)
  local TEXT_WHITE=$(echoti setaf 7)
  local RESET_FORMATTING=$(echoti sgr0)

  (
    # Filter mvn output using sed. Before filtering set the locale to C, so invalid characters won't break some sed implementations
    unset LANG
    LC_CTYPE=C mvn "$@" | sed \
      -e "s/\(\[INFO\]\)\(.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[DEBUG\]\)\(.*\)/${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
      -e "s/\(\[WARNING\]\)\(.*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[ERROR\]\)\(.*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
      -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"

    # Make sure formatting is reset
    echo -ne "${RESET_FORMATTING}"
  )
}

# either use original mvn or the mvn wrapper
alias mvn="mvn-or-mvnw"

# Run mvn against the pom found in a project's root directory (assumes a git repo)
alias 'mvn!'='mvn -f $(git rev-parse --show-toplevel 2>/dev/null || echo ".")/pom.xml'

# aliases
alias mvnag='mvn archetype:generate'
alias mvnboot='mvn spring-boot:run'
alias mvnc='mvn clean'
alias mvncd='mvn clean deploy'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvnci='mvn clean install'
alias mvncie='mvn clean install eclipse:eclipse'
alias mvncini='mvn clean initialize'
alias mvncist='mvn clean install -DskipTests'
alias mvncisto='mvn clean install -DskipTests --offline'
alias mvncom='mvn compile'
alias mvncp='mvn clean package'
alias mvnct='mvn clean test'
alias mvncv='mvn clean verify'
alias mvncvst='mvn clean verify -DskipTests'
alias mvnd='mvn deploy'
alias mvndocs='mvn dependency:resolve -Dclassifier=javadoc'
alias mvndt='mvn dependency:tree'
alias mvne='mvn eclipse:eclipse'
alias mvnfmt='mvn fmt:format'
alias mvnjetty='mvn jetty:run'
alias mvnp='mvn package'
alias mvnqdev='mvn quarkus:dev'
alias mvns='mvn site'
alias mvnsrc='mvn dependency:sources'
alias mvnt='mvn test'
alias mvntc='mvn tomcat:run'
alias mvntc7='mvn tomcat7:run'
alias mvn-updates='mvn versions:display-dependency-updates'


function listMavenCompletions {
  local file new_file
  local -a profiles POM_FILES modules

  # Root POM
  POM_FILES=(~/.m2/settings.xml)

  # POM in the current directory
  if [[ -f pom.xml ]]; then
    local file=pom.xml
    POM_FILES+=("${file:A}")
  fi

  # Look for POM files in parent directories
  while [[ -n "$file" ]] && grep -q "<parent>" "$file"; do
    # look for a new relativePath for parent pom.xml
    new_file=$(grep -e "<relativePath>.*</relativePath>" "$file" | sed -e 's/.*<relativePath>\(.*\)<\/relativePath>.*/\1/')

    # if <parent> is present but not defined, assume ../pom.xml
    if [[ -z "$new_file" ]]; then
      new_file="../pom.xml"
    fi

    # if file doesn't exist break
    file="${file:h}/${new_file}"
    if ! [[ -e "$file" ]]; then
      break
    fi

    POM_FILES+=("${file:A}")
  done

  # Get profiles from found files
  for file in $POM_FILES; do
    [[ -e $file ]] || continue
    profiles+=($(sed 's/<!--.*-->//' "$file" | sed '/<!--/,/-->/d' | grep -e "<profile>" -A 1 | grep -e "<id>.*</id>" | sed 's?.*<id>\(.*\)<\/id>.*?-P\1?'))
  done

  # List modules
  modules=($(print -l **/pom.xml(-.N:h) | grep -v '/target/classes/META-INF/'))

  reply=(
    # common lifecycle
    clean initialize process-resources compile process-test-resources test-compile test package verify install deploy site

    # integration testing
    pre-integration-test integration-test

    # common plugins
    deploy failsafe install site surefire checkstyle javadoc jxr pmd ant antrun archetype assembly dependency enforcer gpg help release repository source eclipse idea jetty cargo jboss tomcat tomcat6 tomcat7 exec versions war ear ejb android scm buildnumber nexus repository sonar license hibernate3 liquibase flyway gwt

    # deploy
    deploy:deploy-file
    # failsafe
    failsafe:integration-test failsafe:verify
    # install
    install:install-file install:help
    # site
    site:site site:deploy site:run site:stage site:stage-deploy site:attach-descriptor site:jar site:effective-site
    # surefire
    surefire:test

    # checkstyle
    checkstyle:checkstyle checkstyle:check checkstyle:checkstyle-aggregate
    # javadoc
    javadoc:javadoc javadoc:test-javadoc javadoc:javadoc-no-fork javadoc:test-javadoc-no-fork javadoc:aggregate javadoc:test-aggregate javadoc:jar javadoc:test-jar javadoc:aggregate-jar javadoc:test-aggregate-jar javadoc:fix javadoc:test-fix javadoc:resource-bundle javadoc:test-resource-bundle
    # jxr
    jxr:jxr jxr:aggregate jxr:test-jxr jxr:test-aggregate
    # pmd
    pmd:pmd pmd:cpd pmd:check pmd:cpd-check

    # ant
    ant:ant ant:clean
    # antrun
    antrun:run
    # archetype
    archetype:generate archetype:create-from-project archetype:crawl
    # assembly
    assembly:single assembly:assembly
    # dependency
    dependency:analyze dependency:analyze-dep-mgt dependency:analyze-only dependency:analyze-report dependency:analyze-duplicate dependency:build-classpath dependency:copy dependency:copy-dependencies dependency:display-ancestors dependency:get dependency:go-offline dependency:list dependency:list-repositories dependency:properties dependency:purge-local-repository dependency:resolve dependency:resolve-plugins dependency:sources dependency:tree dependency:unpack dependency:unpack-dependencies
    # enforcer
    enforcer:enforce enforcer:display-info
    # gpg
    gpg:sign gpg:sign-and-deploy-file
    # help
    help:active-profiles help:all-profiles help:describe help:effective-pom help:effective-settings help:evaluate help:expressions help:system
    # release
    release:clean release:prepare release:prepare-with-pom release:rollback release:perform release:stage release:branch release:update-versions
    # jgitflow
    jgitflow:feature-start jgitflow:feature-finish jgitflow:release-start jgitflow:release-finish jgitflow:hotfix-start jgitflow:hotfix-finish jgitflow:build-number
    # repository
    repository:bundle-create repository:bundle-pack
    # source
    source:aggregate source:jar source:jar-no-fork source:test-jar source:test-jar-no-fork

    # eclipse
    eclipse:clean eclipse:eclipse
    # idea
    idea:clean idea:idea

    # jetty
    jetty:run jetty:run-exploded
    # cargo
    cargo:start cargo:run cargo:stop cargo:deploy cargo:undeploy cargo:help
    # jboss
    jboss:start jboss:stop jboss:deploy jboss:undeploy jboss:redeploy
    # tomcat
    tomcat:start tomcat:stop tomcat:deploy tomcat:undeploy tomcat:redeploy
    # tomcat6
    tomcat6:run tomcat6:run-war tomcat6:run-war-only tomcat6:stop tomcat6:deploy tomcat6:undeploy
    # tomcat7
    tomcat7:run tomcat7:run-war tomcat7:run-war-only tomcat7:deploy
    # tomee
    tomee:run tomee:run-war tomee:run-war-only tomee:stop tomee:deploy tomee:undeploy
    # spring-boot
    spring-boot:run spring-boot:repackage
    # quarkus
    quarkus:dev quarkus:list-extensions quarkus:add-extension quarkus:add-extensions quarkus:generate-config quarkus:help
    # exec
    exec:exec exec:java
    # versions
    versions:display-dependency-updates versions:display-plugin-updates versions:display-property-updates versions:update-parent versions:update-properties versions:update-child-modules versions:lock-snapshots versions:unlock-snapshots versions:resolve-ranges versions:set versions:use-releases versions:use-next-releases versions:use-latest-releases versions:use-next-snapshots versions:use-latest-snapshots versions:use-next-versions versions:use-latest-versions versions:commit versions:revert
    # scm
    scm:add scm:bootstrap scm:branch scm:changelog scm:check-local-modification scm:checkin scm:checkout scm:diff scm:edit scm:export scm:list scm:remove scm:status scm:tag scm:unedit scm:update scm:update-subprojects scm:validate
    # buildnumber
    buildnumber:create buildnumber:create-timestamp buildnumber:help buildnumber:hgchangeset

    # war
    war:war war:exploded war:inplace war:manifest
    # ear
    ear:ear ear:generate-application-xml
    # ejb
    ejb:ejb
    # android
    android:apk android:apklib android:deploy android:deploy-dependencies android:dex android:emulator-start android:emulator-stop android:emulator-stop-all android:generate-sources android:help android:instrument android:manifest-update android:pull android:push android:redeploy android:run android:undeploy android:unpack android:version-update android:zipalign android:devices
    # nexus
    nexus:staging-list nexus:staging-close nexus:staging-drop nexus:staging-release nexus:staging-build-promotion nexus:staging-profiles-list nexus:settings-download
    # repository
    repository:bundle-create repository:bundle-pack repository:help

    # sonar
    sonar:sonar
    # license
    license:format license:check
    # hibernate3
    hibernate3:hbm2ddl hibernate3:help
    # liquibase
    liquibase:changelogSync liquibase:changelogSyncSQL liquibase:clearCheckSums liquibase:dbDoc liquibase:diff liquibase:dropAll liquibase:help liquibase:migrate liquibase:listLocks liquibase:migrateSQL liquibase:releaseLocks liquibase:rollback liquibase:rollbackSQL liquibase:status liquibase:tag liquibase:update liquibase:updateSQL liquibase:updateTestingRollback
    # flyway
    flyway:clean flyway:history flyway:init flyway:migrate flyway:status flyway:validate
    # gwt
    gwt:browser gwt:clean gwt:compile gwt:compile-report gwt:css gwt:debug gwt:eclipse gwt:eclipseTest gwt:generateAsync gwt:help gwt:i18n gwt:mergewebxml gwt:resources gwt:run gwt:sdkInstall gwt:source-jar gwt:soyc gwt:test
    # asciidoctor
    asciidoctor:process-asciidoc asciidoctor:auto-refresh asciidoctor:http asciidoctor:zip
    # compiler
    compiler:compile compiler:testCompile
    # resources
    resources:resources resources:testResources resources:copy-resources
    # verifier
    verifier:verify
    # jar
    jar:jar jar:test-jar
    # rar
    rar:rar
    # acr
    acr:acr
    # shade
    shade:shade
    # changelog
    changelog:changelog changelog:dev-activity changelog:file-activity
    # changes
    changes:announcement-mail changes:announcement-generate changes:changes-check changes:changes-validate changes:changes-report changes:jira-report changes:trac-report changes:github-report
    # doap
    doap:generate
    # docck
    docck:check
    # jdeps
    jdeps:jdkinternals jdeps:test-jdkinternals
    # linkcheck
    linkcheck:linkcheck
    # project-info-reports
    project-info-reports:cim project-info-reports:dependencies project-info-reports:dependency-convergence project-info-reports:dependency-info project-info-reports:dependency-management project-info-reports:distribution-management project-info-reports:help project-info-reports:index project-info-reports:issue-tracking project-info-reports:license project-info-reports:mailing-list project-info-reports:modules project-info-reports:plugin-management project-info-reports:plugins project-info-reports:project-team project-info-reports:scm project-info-reports:summary
    # surefire-report
    surefire-report:failsafe-report-only surefire-report:report surefire-report:report-only
    # invoker
    invoker:install invoker:integration-test invoker:verify invoker:run
    # jarsigner
    jarsigner:sign jarsigner:verify
    # patch
    patch:apply
    # pdf
    pdf:pdf
    # plugin
    plugin:descriptor plugin:report plugin:updateRegistry plugin:addPluginArtifactMetadata plugin:helpmojo
    # remote-resources
    remote-resources:bundle remote-resources:process
    # scm-publish
    scm-publish:help scm-publish:publish-scm scm-publish:scmpublish
    # stage
    stage:copy
    # toolchain
    toolchain:toolchain
    #liberty
    liberty:clean-server liberty:compile-jsp liberty:configure-arquillian liberty:create-server liberty:debug liberty:debug-server liberty:deploy liberty:dev liberty:display-url liberty:dump-server liberty:install-apps liberty:install-feature liberty:install-server liberty:java-dump-server liberty:package-server liberty:run liberty:run-server liberty:server-status liberty:start liberty:start-server liberty:status liberty:stop liberty:stop-server liberty:test-start-server liberty:test-stop-server liberty:undeploy liberty:uninstall-feature
    # vaadin
    vaadin:prepare-frontend vaadin:build-frontend vaadin:clean-frontend vaadin:dance

    # options
    "-Dmaven.test.skip=true" -DskipTests -DskipITs -Dmaven.surefire.debug -DenableCiProfile "-Dpmd.skip=true" "-Dcheckstyle.skip=true" "-Dtycho.mode=maven" "-Dmaven.test.failure.ignore=true" "-DgroupId=" "-DartifactId=" "-Dversion=" "-Dpackaging=jar" "-Dfile="

    # arguments
    -am --also-make
    -amd --also-make-dependents-am
    -B --batch-mode
    -b --builder
    -C --strict-checksums
    -c --lax-checksums
    -cpu --check-plugin-updates
    -D --define
    -e --errors
    -emp --encrypt-master-password
    -ep --encrypt-password
    -f --file
    -fae --fail-at-end
    -ff --fail-fast
    -fn --fail-never
    -gs --global-settings
    -gt --global-toolchains
    -h --help
    -l --log-file
    -llr --legacy-local-repository
    -N --non-recursive
    -npr --no-plugin-registry
    -npu --no-plugin-updates
    -nsu --no-snapshot-updates
    -o --offline
    -P --activate-profiles
    -pl --projects
    -q --quiet
    -rf --resume-from
    -s --settings
    -t --toolchains
    -T --threads
    -U --update-snapshots
    -up --update-plugins
    -v --version
    -V --show-version
    -X --debug

    cli:execute cli:execute-phase
    archetype:generate generate-sources
    cobertura:cobertura
    -Dtest=$(if [ -d ./src/test/java ] ; then find ./src/test/java -type f -name '*.java' | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi)
    -Dit.test=$(if [ -d ./src/test/java ] ; then find ./src/test/java -type f -name '*.java' | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dit.test=\1?' ; fi)

    $profiles
    $modules
  )
}

compctl -K listMavenCompletions mvn mvnw
compctl -K listMavenCompletions mvn-color
compctl -K listMavenCompletions mvn-or-mvnw
