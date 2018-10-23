if [ $# -ne 4 ]; then
        echo "Usage: 4 arguments-> switchKey, propertyName, version, ForwarHostHeader"
        exit 1
fi

echo "Fetching property..."

switchKey=$1
property=$2
version=$3
forwardhostheader=$4

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

var=$(jq '.rules.behaviors|length' file.json)

for((num=0;num<$var;num++)) 
do

var1=$(jq --arg key1 $num '.rules.behaviors[$key1|tonumber].name' file.json)

if [ "$var1" = '"origin"' ]
then 
	cat file.json | jq --arg key1 $num --arg key2 $forwardhostheader '.rules.behaviors[$key1|tonumber].options.forwardHostHeader=$key2 ' \
	> file.json.tmp && mv file.json.tmp file.json
fi
done

echo "Updating the origin server hostname..."

http  PUT  ":/papi/v1/properties/$propertyId/versions/$version/rules? \
contractId=$contractId&groupId=$groupId&validateRules=true&accountSwitchKey=$switchKey" "Content-Type:application/json" < file.json

echo "Update complete..."
