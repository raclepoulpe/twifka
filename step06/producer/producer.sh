#!/bin/bash

. TWITTER_API_properties.sh
. PRODUCER_properties.sh
. PRODUCER_functions.sh

urlEncodedQuery=$(urlencode "$query")
log "query: $query"

start_time=$(date --date='-120 seconds' '+%Y-%m-%dT%H:%M:%SZ')
end_time=$(date --date='-60 seconds' '+%Y-%m-%dT%H:%M:%SZ')

log "start_time: $start_time"
log "end_time:   $end_time"

req="https://api.twitter.com/2/tweets/search/recent?query=$urlEncodedQuery&tweet.fields=created_at&max_results=$max_results&start_time=$start_time&end_time=$end_time&expansions=author_id&user.fields=created_at"

resp=$(curl -s "$req" -H "Authorization: Bearer $BEARER_TOKEN")

nb_result=$(echo $resp | jq '.meta|.result_count')

if [ $nb_result -gt 0 ] 
then
 log "Request returns $nb_result Tweets"

 echo $resp |jq '.data[]|.id' | \
 while read i;\
  do
  id="${i//\"/}";\
  author_id=$(echo $resp | jq --arg twid $id '.data[] | select(.id==($twid)) | .author_id');\
  created_at=$(echo $resp | jq --arg twid $id '.data[] | select(.id==($twid)) | .created_at');\
  text=$(echo $resp | jq --arg twid $id '.data[] | select(.id==($twid)) | .text');\
  user=$(echo $resp | jq --arg aid ${author_id//\"/} '.includes[][] | select(.id==($aid))');\
  json="$(echo "{\"id\":$i,\"created_at\":$created_at,\"text\":$text,\"author\":$user}" | jq )";\
 
  log "Push tweet with id ${id} to Kafka..";\
  log "$json";\
 # echo $json | kafkacat -q -F kafkacat.conf -P -t mytopic;\
 done
else
 log "Request returns no response"
fi
