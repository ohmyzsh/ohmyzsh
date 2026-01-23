#compdef swagger

local context state state_descr line
typeset -A opt_args

__expand() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    "(--compact)--compact[when present, doesn't prettify the json]" \
    '(-o, --output)'{-o,--output}"[the file to write to]:output" && return 0
}

__flatten() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    "(--compact)--compact[when present, doesn't prettify the the json]" \
    '(-o, --output)'{-o,--output}"[the file to write to]:output" && return 0
}

__generate_client() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-f,--spec)'{-f,--spec}"[the spec file to use (default:swagger.{json,yml,yaml)]:spec" \
    '(-a,--api-package)'{-a,--api-package}"[the package to save the operations (default:operations)]:api-package" \
    '(-m,--model-package)'{-m,--model-package}"[the package to save the models (default: models)]:model-package" \
    '(-s,--server-package)'{-s,--server-package}"[the package to save the server specific code (default: restapi)]:server-package" \
    '(-c,--client-package)'{-c,--client-package}"[the package to save the client specific code (default: client)]:client-package" \
    '(-t,--target)'{-t,--target}"[the base directory for generating the files (default: ./)]:target" \
    '(-T,--template-dir)'{-T,--template-dir}"[alternative template override directory]:template-dir" \
    '(-C,--config-file)'{-C,--config-file}"[configuration file to use for overriding template options]:config-file" \
    '(-A,--name)'{-A,--name}"[the name of the application, defaults to a mangled value of info.title]:name" \
    '(-O,--operation)'{-O,--operation}"[specify an operation to include, repeat for multiple]:operation" \
    '(--tags)'--tags"[the tags to include, if not specified defaults to all]:tags" \
    '(-P,--principal)'{-P,--principal}"[the model to use for the security principal]:principal" \
    '(-M,--model)'{-M,--model}"[specify a model to include, repeat for multiple]:model" \
    '(--default-scheme)'--default-scheme"[the default scheme for this client (default: http)]:default-scheme" \
    '(--default-produces)'--default-produces"[the default mime type that API operations produce (default: application/json)]:default-produces" \
    '(--skip-models)'--skip-models"[no models will be generated when this flag is specified]" \
    '(--skip-operations)'--skip-operations"[no operations will be generated when this flag is specified]" \
    '(--dump-data)'--dump-data"[when present dumps the json for the template generator instead of generating files]" \
    '(--skip-validation)'--skip-validation"[skips validation of spec prior to generation]" && return 0
}

__generate_model() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-f,--spec)'{-f,--spec}"[the spec file to use (default swagger.{json,yml,yaml})]:spec" \
    '(-a,--api-package)'{-a,--api-package}"[the package to save the operations (default: operations)]:api-package" \
    '(-m,--model-package)'{-m,--model-package}"[the package to save the models (default: models)]:model-package" \
    '(-s,--server-package)'{-s,--server-package}"[the package to save the server specific code (default: restapi)]:server-package" \
    '(-c,--client-package)'{-c,--client-package}"[the package to save the client specific code (default: client)]:client-package" \
    '(-t,--target)'{-t,--target}"[the base directory for generating the files (default: ./)]:target" \
    '(-T,--template-dir)'{-T,--template-dir}"[alternative template override directory]:template-dir" \
    '(-C,--config-file)'{-C,--config-file}"[configuration file to use for overriding template options]:config-file" \
    '(-n,--name)'{-n,--name}"[the model to generate]:name" \
    "(--skip-struct)--skip-struct[when present will not generate the model struct]" \
    "(--dump-data)--dump-data[when present dumps the json for the template generator instead of generating files]" && return 0
}

__generate_operation() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-f,--spec)'{-f,--spec}"[the spec file to use (default swagger.{json,yml,yaml})]:spec" \
    '(-a,--api-package)'{-a,--api-package}"[the package to save the operations (default: operations)]:api-package" \
    '(-m,--model-package)'{-m,--model-package}"[the package to save the models (default: models)]:model-package" \
    '(-s,--server-package)'{-s,--server-package}"[the package to save the server specific code (default: restapi)]:server-package" \
    '(-c,--client-package)'{-c,--client-package}"[the package to save the client specific code (default: client)]:client-package" \
    '(-t,--target)'{-t,--target}"[the base directory for generating the files (default: ./)]:target" \
    '(-T,--template-dir)'{-T,--template-dir}"[alternative template override directory]:template-dir" \
    '(-C,--config-file)'{-C,--config-file}"[configuration file to use for overriding template options]:config-file" \
    '(-n,--name)'{-n,--name}"[the operations to generate, repeat for multiple]:name" \
    "(--tags)--tags[the tags to include, if not specified defaults to all]:tags" \
    '(-P,--principal)'{-P,--principal}"[the model to use for the security principal]:principal" \
    "(--default-scheme)--default-scheme[the default scheme for this API (default: http)]:default-scheme" \
    "(--skip-handler)--skip-handler[when present will not generate an operation handler]" \
    "(--skip-parameters)--skip-parameters[when present will not generate the parameter model struct]" \
    "(--skip-responses)--skip-responses[when present will not generate the response model struct]" \
    "(--skip-url-builder)--skip-url-builder[when present will not generate a URL builder]" \
    "(--dump-data)--dump-data[when present dumps the json for the template generator instead of generating files]" && return 0
}

__generate_server() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-f,--spec)'{-f,--spec}"[the spec file to use (default swagger.{json,yml,yaml})]:spec" \
    '(-a,--api-package)'{-a,--api-package}"[the package to save the operations (default: operations)]:api-package" \
    '(-m,--model-package)'{-m,--model-package}"[the package to save the models (default: models)]:model-package" \
    '(-s,--server-package)'{-s,--server-package}"[the package to save the server specific code (default: restapi)]:server-package" \
    '(-c,--client-package)'{-c,--client-package}"[the package to save the client specific code (default: client)]:client-package" \
    '(-t,--target)'{-t,--target}"[the base directory for generating the files (default: ./)]:target" \
    '(-T,--template-dir)'{-T,--template-dir}"[alternative template override directory]:template-dir" \
    '(-C,--config-file)'{-C,--config-file}"[configuration file to use for overriding template options]:config-file" \
    '(-A,--name)'{-A,--name}"[the name of the application, defaults to a mangled value of info.title]:name" \
    '(-O,--operation)'{-O,--operation}"[specify an operation to include, repeat for multiple]:operations" \
    "(--tags)--tags[the tags to include, if not specified defaults to all]:tags" \
    '(-P,--principal)'{-P,--principal}"[the model to use for the security principal]:principal" \
    "(--default-scheme)--default-scheme[the default scheme for this API (default: http)]:default-scheme" \
    '(-M,--model)'{-M,--model}"[specify a model to include, repeat for multiple]:model" \
    "(--skip-models)--skip-models[no models will be generated when this flag is specified]" \
    "(--skip-operations)--skip-operations[no operations will be generated when this flag is specified]" \
    "(--skip-support)--skip-support[no supporting files will be generated when this flag is specified]" \
    "(--exclude-main)--exclude-main[exclude main function, so just generate the library]" \
    "(--exclude-spec)--exclude-spec[don't embed the swagger specification]" \
    "(--with-context)--with-context[handlers get a context as first arg]" \
    "(--dump-data)--dump-data[when present dumps the json for the template generator instead of generating files]" \
    "(--flag-strategy)--flag-strategy[the strategy to provide flags for the server (default: go-flags)]:flag-strategy:(go-flags pflag)" \
    "(--compatibility-mode)--compatibility-mode[the compatibility mode for the tls server (default: modern)]:compatibility-mode:(modern intermediate)" \
    "(--skip-validation)--skip-validation[skips validation of spec prior to generation]" && return 0
}

__generate_spec() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-b,--base-path)'{-b,--base-path}"[the base path to use (default: .)]:base-path" \
    '(-m,--scan-models)'{-m,--scan-models}"[includes models that were annotated with 'swagger:model']" \
    "(--compact)--compact[when present, doesn't prettify the the json]" \
    '(-o,--output)'{-o,--output}"[the file to write to]:output" \
    '(-i,--input)'{-i,--input}"[the file to use as input]:input" && return 0
}

__generate_support() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '(-f,--spec)'{-f,--spec}"[the spec file to use (default swagger.{json,yml,yaml})]:spec" \
    '(-a,--api-package)'{-a,--api-package}"[the package to save the operations (default: operations)]:api-package" \
    '(-m,--model-package)'{-m,--model-package}"[the package to save the models (default: models)]:model-package" \
    '(-s,--server-package)'{-s,--server-package}"[the package to save the server specific code (default: restapi)]:server-package" \
    '(-c,--client-package)'{-c,--client-package}"[the package to save the client specific code (default: client)]:client-package" \
    '(-t,--target)'{-t,--target}"[the base directory for generating the files (default: ./)]:target" \
    '(-T,--template-dir)'{-T,--template-dir}"[alternative template override directory]:template-dir" \
    '(-C,--config-file)'{-C,--config-file}"[configuration file to use for overriding template options]:config-file" \
    '(-A,--name)'{-A,--name}"[the name of the application, defaults to a mangled value of info.title]:name" \
    '(-O,--operation)'{-O,--operation}"[specify an operation to include, repeat for multiple]:operation" \
    "(--principal)--principal[the model to use for the security principal]:principal" \
    '(-M,--model)'{-M,--model}"[specify a model to include, repeat for multiple]:model" \
    "(--dump-data)--dump-data[when present dumps the json for the template generator instead of generating files]" \
    "(--default-scheme)--default-scheme[the default scheme for this API (default: http)]:default-scheme" && return 0
}

__generate() {
  local commands
  commands=(
    'client:generate all the files for a client library'
    'model:generate one or more models from the swagger spec'
    'operation:generate one or more server operations from the swagger spec'
    'server:generate all the files for a server application'
    'spec:generate a swagger spec document from a go application'
    'support:generate supporting files like the main function and the api builder'
  )

  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "swagger generate subcommand" commands
    return
  fi

  case "$words[1]" in
    client)
      __generate_client ;;
    model)
      __generate_model ;;
    operation)
      __generate_operation ;;
    server)
      __generate_server ;;
    spec)
      __generate_spec ;;
    support)
      __generate_support ;;
  esac
}

__init_spec() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    "(--format)--format[the format for the spec document (default: yaml)]:format:(yaml json)" \
    "(--title)--title[the title of the API]:title" \
    "(--description)--description[the description of the API]:description" \
    "(--version)--version[the version of the API (default: 0.1.0)]:version" \
    "(--terms)--terms[the terms of services]:terms" \
    "(--consumes)--consumes[add a content type to the global consumes definitions, can repeat (default: application/json)]:consumes" \
    "(--produces)--produces[add a content type to the global produces definitions, can repeat (default: application/json)]:produces" \
    "(--scheme)--scheme[add a scheme to the global schemes definition, can repeat (default: http)]:scheme" \
    "(--contact.name)--contact.name[name of the primary contact for the API]:contact.name" \
    "(--contact.url)--contact.url[url of the primary contact for the API]:contact.url" \
    "(--contact.email)--contact.email[email of the primary contact for the API]:contact.email" \
    "(--license.name)--license.name[name of the license for the API]:license.name" \
    "(--license.url)--license.url[url of the license for the API]:license.url" && return 0
}

__init() {
  local commands
  commands=(
    'spec:'
  )

  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "swagger spec subcommand" commands
    return
  fi

  case "$words[1]" in
    spec)
      __init_spec ;;
  esac
}

__serve() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    "(--base-path)--base-path[the base path to serve the spec and UI at]:base-path" \
    '(-F,--flavor)'{-F,--flavor}"[the flavor of docs, can be swagger or redoc (default: redoc)]:flavor:(redoc swagger)" \
    "(--doc-url)--doc-url[override the url which takes a url query param to render the doc ui]:doc-url" \
    "(--no-open)--no-open[when present won't open the the browser to show the url]" \
    "(--no-ui)--no-ui[when present, only the swagger spec will be served]" \
    '(-p,--port)'{-p,--port}'[the port to serve this site (default:$PORT)]:port' \
    '(--host)--host[the interface to serve this site, defaults to 0.0.0.0 (default:$HOST)]:host' && return 0
}

__validate() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' && return 0
}

__version() {
  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' && return 0
}

# swagger tool
_swagger_complete() {
  local commands
  commands=(
    'expand:expand $ref fields in a swagger spec'
    'flatten:flattens a swagger document'
    'generate:generate go code'
    'init:initialize a spec document'
    'serve:serve spec and docs'
    'validate:validate the swagger document'
    'version:print the version'
  )

  _arguments \
    '(-h,--help)'{-h,--help}'[Print help message]' \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "swagger subcommand" commands
    return
  fi

  case "$words[1]" in
    expand)
      __expand ;;
    flatten)
      __flatten ;;
    generate)
      __generate ;;
    init)
      __init ;;
    serve)
      __serve ;;
    validate)
      __validate ;;
    version)
      __version ;;
  esac
}

compdef _swagger_complete swagger