
read -p "Enter account switchkey: " switchKey
read -p "Enter the property name: " property
read -p "Enter the property version: " version
read -p "Enter the hostname to be removed: " hostname

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
contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey&validateHostnames=true" > file.json

jq '.hostnames.items' file.json > file.json.tmp &&  mv file.json.tmp file.json

jq --arg val1 $hostname ' del(.[]|select(.cnameFrom==$val1)) ' file.json > file.json.tmp \
&&  mv file.json.tmp file.json 

echo "Updating hostnames in the config..."

http PUT :"/papi/v1/properties/$propertyId/versions/$version/hostnames? \
contractId=$contractId&groupId=$groupId&validateHostnames=true&accountSwitchKey=$switchKey" "Content-Type:application/json" < file.json

echo "Finished..."
