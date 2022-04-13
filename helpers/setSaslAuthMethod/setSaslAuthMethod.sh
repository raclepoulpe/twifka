#!/bin/bash
  
# Script variables(s)
SCRIPTROOTDIR="$GITPOD_REPO_ROOT"
source $SCRIPTROOTDIR/helpers/OVHcloud.properties.sh

api="$SCRIPTROOTDIR/helpers/ovhAPI.sh"

echo ""
echo -e "set or unset sasl auth method to an OVHcloud Kafka managed cluster"
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

echo "Select value:"
echo ""
select myvalue in "true" "false"
do
	myresp="$myvalue"
	break
done

data="{\"kafka_authentication_methods.sasl\":\"$myresp\"}"

resp="$($api PUT /cloud/project/${serviceId}/database/kafka/${kafkaClusterId}/advancedConfiguration ${data})"

echo "response:"
echo "${resp}"
echo ""
