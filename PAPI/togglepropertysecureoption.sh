if [ $# -ne 4 ]; then
        echo "Usage: 4 arguments-> switchKey, propertyName, version, issecure|true or false"
        exit 1
fi

echo "Fetching property..."

switchKey=$1
property=$2
version=$3
issecure=$4

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId"
echo "groupId=$groupId"
echo "propertyId=$propertyId"

echo "Getting rule tree..."

http GET :"/papi/v1/properties/$propertyId/versions/$version/rules? \
contractId=$contractId&groupId=$groupId&validateRules=true&accountSwitchKey=$switchKey" > file.json

jq --argjson key $issecure '.rules.options.is_secure=$key' file.json > file.json.tmp && mv file.json.tmp file.json

echo "Toggling the secure option for property..."

http  PUT  ":/papi/v1/properties/$propertyId/versions/$version/rules? \
contractId=$contractId&groupId=$groupId&validateRules=true&accountSwitchKey=$switchKey" "Content-Type:application/json" < file.json

echo "Toggle complete..."
