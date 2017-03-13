
_ng_completion () {
  local words cword opts
  read -Ac words
  read -cn cword
  let cword-=1

  case $words[cword] in
    ng | help)
		  opts='--version -v b build completion doc e e2e eject g generate get help l lint new s serve server set t test v version xi18n' ;;
    b | build)
		  opts='--aot --app --base-href --deploy-url --environment --extract-css --i18n-file --i18n-format --locale --output-hashing --output-path --poll --progress --sourcemap --stats-json --target --vendor-chunk --verbose --watch -a -aot -bh -d -e -ec -i18nFile -i18nFormat -locale -oh -op -poll -pr -sm -statsJson -t -v -vc -w' ;;
    completion)
		  opts='--all --bash --zsh -a -b -z' ;;
    e | e2e)
		  opts='--aot --app --base-href --config --deploy-url --element-explorer --environment --extract-css --hmr --host --i18n-file --i18n-format --live-reload --live-reload-client --locale --open --output-hashing --output-path --poll --port --progress --proxy-config --serve --sourcemap --specs --ssl --ssl-cert --ssl-key --target --vendor-chunk --verbose --watch --webdriver-update -H -a -aot -bh -c -d -e -ec -ee -hmr -i18nFile -i18nFormat -liveReloadClient -locale -lr -o -oh -op -p -pc -poll -pr -s -sm -sp -ssl -sslCert -sslKey -t -v -vc -w -wu' ;;
    eject)
		  opts='--aot --app --base-href --deploy-url --environment --extract-css --force --i18n-file --i18n-format --locale --output-hashing --output-path --poll --progress --sourcemap --target --vendor-chunk --verbose --watch -a -aot -bh -d -e -ec -force -i18nFile -i18nFormat -locale -oh -op -poll -pr -sm -t -v -vc -w' ;;
    g | generate)
		  opts='class component directive enum guard interface module pipe service--dry-run --verbose -d -v' ;;
    get)
		  opts='--global -global' ;;
    l | lint)
		  opts='--fix --force --format -fix -force -format' ;;
    new)
		  opts='--directory --dry-run --inline-style --inline-template --link-cli --ng4 --prefix --routing --skip-commit --skip-git --skip-install --skip-tests --source-dir --style --verbose -d -dir -is -it -lc -ng4 -p -routing -sc -sd -sg -si -st -style -v' ;;
    s | serve | server)
		  opts='--aot --app --base-href --deploy-url --environment --extract-css --hmr --host --i18n-file --i18n-format --live-reload --live-reload-client --locale --open --output-hashing --output-path --poll --port --progress --proxy-config --sourcemap --ssl --ssl-cert --ssl-key --target --vendor-chunk --verbose --watch -H -a -aot -bh -d -e -ec -hmr -i18nFile -i18nFormat -liveReloadClient -locale -lr -o -oh -op -p -pc -poll -pr -sm -ssl -sslCert -sslKey -t -v -vc -w' ;;
    set)
		  opts='--global -g' ;;
    t | test)
		  opts='--app --browsers --code-coverage --colors --config --log-level --poll --port --progress --reporters --single-run --sourcemap --watch -a -browsers -c -cc -colors -logLevel -poll -port -progress -reporters -sm -sr -w' ;;
    --version | -v | v | version)
		  opts='--verbose -verbose' ;;
    xi18n)
		  opts='--app --i18n-format --locale --out-file --output-path --progress --verbose -a -f -l -of -op -progress -verbose' ;;
    *)
		  opts='' ;;
  esac

  setopt shwordsplit
  reply=($opts)
  unset shwordsplit
}

compctl -K _ng_completion ng
