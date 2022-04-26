export OPENSEARCH_USER="$(echo $OPENSEARCH_USER_B64 | base64 -d)"
export OPENSEARCH_PWD="$(echo $OPENSEARCH_PWD_B64 | base64 -d)"
export OPENSEARCH_HOST="$(echo $OPENSEARCH_HOST_B64 | base64 -d)"

#echo $OPENSEARCH_USER:$OPENSEARCH_PWD@$OPENSEARCH_HOST

log() {
if [ "$LOGLEVEL" == "INFO" ];
then
	# POST data
	curl -XPOST -u "$OPENSEARCH_USER:$OPENSEARCH_PWD" https://$OPENSEARCH_HOST:20184/twifka/_doc -H "Content-Type: application/json" -d ''"$1"'' #1>/dev/null 2>1

fi
}

urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}
