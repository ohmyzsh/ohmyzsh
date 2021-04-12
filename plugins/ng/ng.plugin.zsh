ng_opts='addon asset-sizes b build completion d destroy doc e2e g generate get github-pages:deploy gh-pages:deploy h help i init install lint make-this-awesome new s serve server set t test update v version -h --help'

_ng_completion () {
  local words cword opts
  read -Ac words
  read -cn cword
  let cword-=1

  case $words[cword] in
    addon )
      opts='-b --blueprint -d -dir --directory --dry-run -sb --skip-bower -sg --skip-git -sn --skip-npm -v --verbose'
      ;;

    asset-sizes )
      opts='-o --output-path'
      ;;

    b | build )
      opts='--environment --output-path --suppress-sizes --target --watch --watcher -dev -e -prod'
      ;;

    d | destroy )
      opts='--dry-run --verbose --pod --classic --dummy --in-repo --in-repo-addon -d -v -p -c -dum -id -ir'
      ;;

    g | generate )
      opts='class component directive enum module pipe route service --generate -d --dry-run --verbose -v --pod -p --classic -c --dummy -dum -id --in-repo --in-repo-addon -ir'
      ;;

    gh-pages:deploy | github-pages:deploy )
      opts='--environment --gh-token --gh-username --skip-build --user-page --message'
      ;;

    h | help | -h | --help)
      opts='--json --verbose -v'
      ;;

    init )
      opts='--blueprint --dry-run --link-cli --mobile --name --prefix --skip-bower --skip-npm --source-dir --style --verbose -b -d -lc -n -p -sb -sd -sn -v'
      ;;

    new )
      opts='--blueprint --directory --dry-run --link-cli --mobile --prefix --skip-bower --skip-git --skip-npm --source-dir --style --verbose -b -d -dir -lc -p -sb -sd -sg -sn -v'
      ;;

    s | serve | server )
      opts='--environment --host --insecure-proxy --inspr --live-reload --live-reload-base-url --live-reload-host --live-reload-live-css --live-reload-port --output-path --port --proxy --ssl --ssl-cert --ssl-key --target --watcher -H -dev -e -lr -lrbu -lrh -lrp -op -out -p -pr -prod -pxy -t -w'
      ;;

    set )
      opts='--global -g'
      ;;

    t | test )
      opts='--browsers --colors --config-file --environment --filter --host --launch --log-level --module --path --port --query --reporter --server --silent --test-page --test-port --watch -H -c -cf -e -f -m -r -s -tp -w'
      ;;
      
    update )
      opts='--all --dryRun --force --from --migrate-only --next --registry --to -d'
      ;;

    v | version )
      opts='--verbose'
      ;;

    ng )
      opts=$ng_opts
      ;;

    * )
      opts=''
      ;;
  esac

  reply=(${=opts})
}

compctl -K _ng_completion ng
