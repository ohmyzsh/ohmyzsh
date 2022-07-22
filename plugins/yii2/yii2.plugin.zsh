# Yii2 command completion

_yii2_format_command () {
  awk '/^- [a-z]+/ { sub(":", "", $2); print $2 }'
}

_yii2 () {
  if [ -f ./yii ]; then
    _arguments \
      '1: :->command'\
      '*: :->params'

    case $state in
      command)

      local -a commands
      local -a name

      if [[ $words[2] == *\/ ]]; then
        name=$words[2]
      fi

      commands=(${(f)"$(./yii help $name --color=0 | _yii2_format_command)"})
      compadd -Q -S '' -a -- commands
    esac
  fi
}

compdef _yii2 yii
