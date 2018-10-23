if [ $# -ne 5 ]; then 
	echo "Usage: 5 arguments-> switchKey, propertyName, contractId, groupId, productId"
	echo "Run the getcontracts.sh, getgroups.sh and  getproducts.sh scripts to get the list of all the inputs needed"
	exit 1
fi	

echo "Fetching property..."

switchKey=$1
property=$2
contractId=$3
groupId=$4
productId=$5

echo "Creating new property...$property"

http POST :"/papi/v1/properties?contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey" \
"Content-Type:application/json" productId=$productId propertyName=$property

echo "Finished..."
