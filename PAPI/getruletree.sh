read -p "Enter account switch key: " switchKey
read -p "Enter the property name: " property
read -p "Enter the version: " version

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

http :"/papi/v1/properties/$propertyId/versions/$version/rules?contractId=$contractId&groupId=$groupId&validateRules=true \
&accountSwitchKey=$switchKey"

