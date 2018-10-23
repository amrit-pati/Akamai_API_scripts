if [ $# -ne 3 ]; then 
	echo "Usage:3 arguments-> switchKey, propertyName, version"
	exit 1
fi	


read -p "Enter domainPrefix: " domainprefix
read -p "Enter domainSuffix: " domainsuffix
read -p "Enter ipversion | IPV4 | IPV6_COMPLIANCE: " ipversion

switchKey=$1
property=$2
version=$3

echo "Fetching property..."

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId" 
echo "groupId=$groupId" 
echo "propertyId=$propertyId"

http :"/papi/v1/properties/$propertyId/versions/$version?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" > file.json

productId=$(jq '.versions.items[].productId' file.json | tr -d '"')

echo "Creating Edge hostname...$edgehostname"

http POST :"/papi/v1/edgehostnames?contractId=$contractId&groupId=$groupId&options=mapDetails&accountSwitchKey=$switchKey" \
"Content-Type:application/json" productId=$productId domainPrefix=$domainprefix domainSuffix=$domainsuffix secure=false ipVersionBehavior=$ipversion

echo "Finished creating...$edgehostname"



