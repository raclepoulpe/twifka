#!/bin/bash
  
# Script variables(s)
SCRIPTROOTDIR="$GITPOD_REPO_ROOT"
source $SCRIPTROOTDIR/OVHcloud.properties.sh

myPubIP="$(cat $SCRIPTROOTDIR/IP.pub)"
api="$SCRIPTROOTDIR/scripts/ovhAPI.sh"

echo ""
echo -e "Add this public IP address \e[1m\033[38;5;2m${myPubIP}$(tput sgr0) to an OVHcloud Kafka managed cluster"
echo ""

PS3="Enter a number: "

# Select the service
serviceList=""
for serviceId in $($api GET /cloud/project | jq -r .[])
do
        serviceDesc="$($api GET /cloud/project/${serviceId} | jq -r .description)"
        serviceList="${serviceList} [${serviceDesc}]${serviceId}"
done

echo ""
echo "Select your OVHcloud service:"
echo ""
select service in $serviceList
do
        serviceId="$(echo $service | cut -d ']' -f2)"
        break
done
echo ""

# Select the Kafka Cluster
kafkaClusterList=""
for kafkaClusterId in $($api GET /cloud/project/${serviceId}/database/kafka | jq -r .[])
do
        kafkaClusterDesc="$($api GET /cloud/project/${serviceId}/database/kafka/${kafkaClusterId} | jq -r .description)"
        kafkaClusterList="${kafkaClusterList} [${kafkaClusterDesc}]${kafkaClusterId}"
done


echo "Select your Kafka Cluster:"
echo ""
select kafkaCluster in $kafkaClusterList
do
        kafkaClusterId="$(echo $kafkaCluster | cut -d ']' -f2)"
        break
done
echo ""

data="{\"ip\":\"${myPubIP}/32\",\"description\":\"Gitpod\"}"

resp="$($api POST /cloud/project/${serviceId}/database/kafka/${kafkaClusterId}/ipRestriction ${data})"

echo "response:"
echo "${resp}"

# Delete
echo ""
echo "Delete string:"
echo "$api DELETE /cloud/project/${serviceId}/database/kafka/${kafkaClusterId}/ipRestriction/${myPubIP}%2F32"
