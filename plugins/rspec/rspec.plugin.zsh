function rspec_with () {
  grep -l $1 spec/*/*_spec.rb | xargs rspec
}
