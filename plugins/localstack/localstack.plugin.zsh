# CLI support for LOCALSTACK interaction
#
# See README.md for details
lsk() {
  case $1 in
    sqs-send)
      shift
      sqs-send "$@"
      ;;
    *)
      echo "Command not found: $1"
      return 1
      ;;
  esac
}

# Send SQS function
#
# This function sends a given message in sqs to a given queue, when used Localstack
#
# Use:
#   sqs-send <queue> <message>
#
# Parameters
#   <queue> A given queue
#   <message> A content of message em json archive
#
# Example
#   sqs-send user user.json
sqs-send(){
  if [ -z "$1" ]; then
	  echo "Use: sqs-send <queue> <payload>"
	  return 1
  fi

  curl -X POST "http://localhost:4566/000000000000/$1" -d "Action=SendMessage" -d "MessageBody=$(cat $2)"
}