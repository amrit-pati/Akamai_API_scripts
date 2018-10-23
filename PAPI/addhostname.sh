
read -p "Enter the switchKey: " switchKey
read -p "Enter the property name: " property
read -p "Enter the version: " version
read -p "Enter the hostname: " hostname
read -p "Enter the Edgehostname to cname to: " edgehostname

echo "Fetching property..."

http POST :"/papi/v1/search/find-by-value?accountSwitchKey=$switchKey" "Content-Type:application/json" propertyName=$property \
> file.json

contractId=$(jq '.versions.items[0].contractId' file.json | tr -d '"')
groupId=$(jq '.versions.items[0].groupId' file.json | tr -d '"')
propertyId=$(jq '.versions.items[0].propertyId' file.json | tr -d '"')

echo "contractId=$contractId" 
echo "groupId=$groupId" 
echo "propertyId=$propertyId"

echo "Checking if the edgehostname exists..."

http :"/papi/v1/edgehostnames?contractId=$contractId&groupId=$groupId&options=mapDetails&accountSwitchKey=$switchKey" > file.json 

var=$(jq '.edgeHostnames.items|length' file.json)

for((num=0;num<$var;num++))
do 

var1=$(jq --arg key1 $num '.edgeHostnames.items[$key1|tonumber].edgeHostnameDomain' file.json | tr -d '"' )

if [ $var1 = $edgehostname ]
then
	echo "Edgehostname found"
	found="found"
	break
fi
done

if [ "$found" != "found" ]
then 
	echo "Edgehostname is not yet created, please create the edgehostname first and then try adding the hostname"
	exit 1
fi 

echo "Getting property hostnames..."

http :"/papi/v1/properties/$propertyId/versions/$version/hostnames? \
contractId=$contractId&groupId=$groupId&accountSwitchKey=$switchKey&validateHostnames=true" > file.json

jq '.hostnames.items' file.json > file.json.tmp &&  mv file.json.tmp file.json

jq --arg val1 $hostname --arg val2 $edgehostname '. +=[{"cnameFrom": $val1,"cnameTo": $val2,"cnameType":"EDGE_HOSTNAME"}]' file.json > file.json.tmp \
&&  mv file.json.tmp file.json 

echo "Updating hostnames in the config..."

http PUT :"/papi/v1/properties/$propertyId/versions/$version/hostnames? \
contractId=$contractId&groupId=$groupId&validateHostnames=true&accountSwitchKey=$switchKey" "Content-Type:application/json" < file.json

echo "Finished..."
