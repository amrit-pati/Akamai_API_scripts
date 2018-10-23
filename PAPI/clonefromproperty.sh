read -p "Enter account switch key: " switchKey
read -p "Enter property name: " property
read -p "Enter proudct ID, this will decide product type(run getproducts.sh script to see list of available products): " productId
read -p "Enter the name of property to clone from: " cloneFrom
read -p "Enter the version to clone from: " version
read -p "Do you want to copy hostnames?(yes|no): " answer

if [ $answer == yes ]; then

	copyhostnames=true
else
	copyhostnames=false
fi

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$cloneFrom \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "Cloning new property from...$cloneFrom"

http POST :"/papi/v1/properties?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" \
"Content-Type:application/json" productId=$productId propertyName=$property \
cloneFrom:='{ "propertyId":"'"$propertyId"'", "version": '$version' , "copyHostnames": '$copyhostnames' }'

echo "Finished..."
