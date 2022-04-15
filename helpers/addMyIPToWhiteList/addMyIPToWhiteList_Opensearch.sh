#!/bin/bash
  
# Script variables(s)
SCRIPTROOTDIR="$GITPOD_REPO_ROOT"
source $SCRIPTROOTDIR/helpers/OVHcloud.properties.sh

myPubIP="$(cat $SCRIPTROOTDIR/IP.pub)"
api="$SCRIPTROOTDIR/helpers/ovhAPI.sh"

echo ""
echo -e "Add this public IP address \e[1m\033[38;5;2m${myPubIP}$(tput sgr0) to an OVHcloud Opensearch managed cluster"
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

# Select the Opensearch Cluster
opensearchClusterList=""
for opensearchClusterId in $($api GET /cloud/project/${serviceId}/database/opensearch | jq -r .[])
do
        opensearchClusterDesc="$($api GET /cloud/project/${serviceId}/database/opensearch/${opensearchClusterId} | jq -r .description)"
        opensearchClusterList="${opensearchClusterList} [${opensearchClusterDesc}]${opensearchClusterId}"
done


echo "Select your Opensearch Cluster:"
echo ""
select opensearchCluster in $opensearchClusterList
do
        opensearchClusterId="$(echo $opensearchCluster | cut -d ']' -f2)"
        break
done
echo ""

data="{\"ip\":\"${myPubIP}/32\",\"description\":\"Gitpod\"}"

resp="$($api POST /cloud/project/${serviceId}/database/opensearch/${opensearchClusterId}/ipRestriction ${data})"

echo "response:"
echo "${resp}"

# Delete
echo ""
echo "Delete string:"
echo "$api DELETE /cloud/project/${serviceId}/database/opensearch/${opensearchClusterId}/ipRestriction/${myPubIP}%2F32"
