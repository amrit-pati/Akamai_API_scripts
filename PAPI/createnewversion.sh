
read -p "Enter account switchkey: " switchKey
read -p "Enter property name: " property
read -p "Enter version to create from: " fromversion

echo "Fetching property..."

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId"
echo "groupId=$groupId"
echo "propertyId=$propertyId"

echo "Creating new version..."

http POST :"/papi/v1/properties/$propertyId/versions?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" \
"Content-Type:application/json" createFromVersion=$fromversion

echo "New version created..."
