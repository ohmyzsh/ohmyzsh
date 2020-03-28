alias kfkt=kafka-topics
alias kfkcc="kafka-console-consumer"
alias kfkcp="kafka-console-producer"

alias kfkt-new='kfkt --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic'
alias kfkt-list='kfkt --describe --bootstrap-server localhost:9092'
alias kfkt-delete='kfkt --delete --bootstrap-server localhost:9092 --topic'

alias kfkcpt="kfkcp --broker-list localhost:9092 --topic"
