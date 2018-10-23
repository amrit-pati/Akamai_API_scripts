if [ $# -ne 2 ]; then 
	echo "Usage: 2 arguments-> switchKey, propertyName"
	exit 1
fi	

echo "Fetching property..."

switchKey=$1
property=$2

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property

echo "Finished.."
