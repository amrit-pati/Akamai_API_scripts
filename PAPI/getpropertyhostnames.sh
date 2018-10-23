read -p "Enter the account switchkey: " switchKey
read -p "Enter the property name: " property
read -p "Enter the property version: " version

echo "Fetching property..."

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId" 
echo "groupId=$groupId" 
echo "propertyId=$propertyId"

echo "Getting property hostnames..."

http :"/papi/v1/properties/$propertyId/versions/$version/hostnames? \
contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey&validateHostnames=true"

echo "Finished..."
