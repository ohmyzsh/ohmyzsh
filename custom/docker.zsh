# requires { sure } from 00aa-lib.zsh

remove-all-docker-containers() {
  sure
  docker rm $(docker ps -a -q)
}

remove-all-docker-images() {
  sure
  docker rmi $(docker images -q)
}

remove-stopped-old-docker-containers() {
  sure
  docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
}

dserve() {
  echo "Usage: dserve"
  local container=dserve${$(pwd)//\//-}
  (docker restart $container \
    || docker run -d --name $container -P -v "$(pwd):/usr/share/nginx/html:ro" nginx:stable-alpine) \
    && docker port $container
}

dserve-php() {
  echo "Usage: dserve-php"
  local container=dserve-php-${$(pwd)//\//-}
  (docker restart $container \
    || docker run -d --name $container -P -v "$(pwd):/var/www/html:ro" php:5-apache) \
    && docker port $container
}

doc() {
  echo "Usage: doc"
  # add zsh conf
  # bind shell so we can change current dir (cd, etc)
  docker run -it --rm -v "$HOME:/root" -v "/:/all" mhoush/zsh zsh -c "cd /all$(pwd) && $*"
}

sdoc() {
  echo "Usage: sdoc"
  docker run -it --rm -v "$HOME:/root" -v "/:/all:ro" mhoush/zsh zsh -c "cd /all$(pwd) && $*"
}
