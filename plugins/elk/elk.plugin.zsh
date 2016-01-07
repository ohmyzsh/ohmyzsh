# Aliases for the ELK stack

# General
alias stelk="sudo systemctl status elasticsearch.service; sudo systemctl status logstash; sudo systemctl status kibana.service;"
#   open FDs
alias stelsysfs="sysctl fs.file-nr"

# Elastic search cluster health
alias stelh="curl 'localhost:9200/_cluster/health?pretty'"

# Elastic search cluser nodes info
alias stelno="curl 'http://localhost:9200/_cat/nodes?v'"
alias stelproc="curl 'http://localhost:9200/_nodes/_all/process?pretty'"
alias steljvm="curl 'http://localhost:9200/_nodes/_all/jvm?pretty'"
alias stelsh="curl 'http://localhost:9200/_cat/shards"

