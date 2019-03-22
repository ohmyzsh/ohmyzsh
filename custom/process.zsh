amasijar() {
  pkill -f $@
}

process-port() {
  # echo "Usage: process-port [PARTOFPROCESSNAME]"
  lsof -nP | grep -E "$1.*LISTEN"
}

process-tcp-port() {
  # echo "Usage: process-tcp-port [PARTOFPROCESSNAME]"
  lsof -nP -i4TCP | grep -E "$1.*LISTEN"
}

kill-process-by-port() {
  # echo "Usage: kill-process-by-port [PARTOFPROCESSNAME]"
  process-port $1 | awk "{ print \$2; }" | xargs kill
}

