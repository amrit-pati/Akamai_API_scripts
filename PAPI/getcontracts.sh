if [ $# -ne 1 ]; then 
	echo "Usage 1 argument -> accountSwitchKey"
	exit 1
fi

switchKey=$1

echo "Getting the contracts..."
http :"/papi/v1/contracts?accountSwitchKey=$switchKey"
echo "Finished..."
