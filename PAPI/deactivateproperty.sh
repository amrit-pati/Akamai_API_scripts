if [ $# -ne 6 ]; then 
	echo "Usage:6 arguments-> switchKey, propertyName, version, network | STAGING or PRODUCTION, note, notifyEmail(just one email)"
	exit 1
fi	

echo "Fetching property..."

switchKey=$1
property=$2
version=$3
network=$4
note=$5
email=$6

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId" 
echo "groupId=$groupId" 
echo "propertyId=$propertyId"

jq --argjson key $version '.propertyVersion=$key' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key $network '.network=$key' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key "$note" '.note=$key' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key "$email" ' del(.notifyEmails[]) | .notifyEmails+=[$key]' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key "DEACTIVATE" '.activationType=$key' activation.json > activation.json.tmp && mv activation.json.tmp activation.json

echo "Submitting property for deactivation..."

http POST :"/papi/v1/properties/$propertyId/activations?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" \
"Content-Type:application/json" < activation.json

echo "Finished...Deactivation in progress"



