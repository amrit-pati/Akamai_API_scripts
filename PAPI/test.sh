read -p "Enter account switchkey: " switchKey
read -p "Enter property name: " property
read -p "Enter version: " version
read -p "Enter network: " network
read -p "Enter activation notes: " note
read -p "Enter notification email id(only one): " email

if [ "$network" == "PRODUCTION" ]; then

	read -p "Enter the peer reviewer email: " peeremail
	read -p "Enter the customer email: " customeremail
	
fi

echo "Fetching property..."

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
jq --arg key "$peeremail" ' .complianceRecord.peerReviewedBy=$key ' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key "$customeremail" ' .complianceRecord.customerEmail=$key ' activation.json > activation.json.tmp && mv activation.json.tmp activation.json
jq --arg key "ACTIVATE" '.activationType=$key' activation.json > activation.json.tmp && mv activation.json.tmp activation.json

echo "Pushing property for activation..."

http POST :"/papi/v1/properties/$propertyId/activations?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" \
"Content-Type:application/json" < activation.json

echo "Finished...Activation in progress"



