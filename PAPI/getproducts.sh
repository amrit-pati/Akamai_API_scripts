if [ $# -ne 2 ]; then 
	echo "Usage 2 arguments -> accountSwitchKey, contractId"
	exit 1
fi

switchKey=$1
contractId=$2

echo "Getting the products..."
http :"/papi/v1/products?accountSwitchKey=$switchKey&contractId=$contractId"
echo "Finished..."
