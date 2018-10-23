if [ $# -ne 1 ]; then 
	echo "Usage 1 argument -> accountSwitchKey"
	exit 1
fi

switchKey=$1

echo "Getting the groups..."
http :"/papi/v1/groups?accountSwitchKey=$switchKey"
echo "Finished..."
