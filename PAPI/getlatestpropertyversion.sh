
read -p "Enter account switch key: " switchKey
read -p "Enter property name: " property
read -p "Enter the network(STAGING, PRODUCTION or LATEST for the highest version of config: " version

echo "Fetching property..."

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId"
echo "groupId=$groupId"
echo "propertyId=$propertyId"

if [ "$version" == STAGING -o "$version" == PRODUCTION ] 
then 

	http :"/papi/v1/properties/$propertyId/versions/latest?activatedOn=$version&contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey"
else
	http :"/papi/v1/properties/$propertyId/versions/latest?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey"
fi

echo "Finished..."
