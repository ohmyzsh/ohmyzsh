## The mvn Plugin

The [mvn](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/mvn) plugin provides many [aliases](#Aliases).

Enable it by adding _mvn_ to the [_plugins array_](https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template#L48) before sourcing OMZ (see [[Plugins]]).

## Aliases

| Alias                | Command                                                                                                                                   |
|:---------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
|mvncie|mvn clean install eclipse:eclipse|
|mvnci|mvn clean install|
|mvncist|mvn clean install -DskipTests|
|mvne|mvn eclipse:eclipse|
|mvnd|mvn deploy|
|mvnp|mvn package|
|mvnc|mvn clean|
|mvncom|mvn compile|
|mvnct|mvn clean test|
|mvnt|mvn test|
|mvnag|mvn archetype:generate|
|mvn-updates|mvn versions:display-dependency-updates|
|mvntc7|mvn tomcat7:run|
|mvnjetty|mvn jetty:run|
|mvndt|mvn dependency:tree|
|mvns|mvn site|
|mvnsrc|mvn dependency:sources|
|mvndocs|mvn dependency:resolve -Dclassifier=javadoc|
