if [ $# -ne 3 ]; then 
	echo "Usage: 3 arguments-> switchKey, propertyName, version"
	exit 1
fi	

#echo "Fetching property..."

switchKey=$1
property=$2
version=$3

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId"
echo "groupId=$groupId"
echo "propertyId=$propertyId"

echo "Updating the rule tree..."

http PUT :"/papi/v1/properties/$propertyId/versions/$version/rules?contractId=$contractId&groupId=$groupId& \
validateRules=true&accountSwitchKey=$switchKey" "Content-Type:application/json" < rules.json

echo "Finished...updating the rule tree"
