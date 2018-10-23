echo "Make sure to have the list of urls/cp codes in each of the respective 'purge_urls.json' or 'purge_cpcode.json' files before you proceed..."

read -p "Purge by ? | Type cpcode or url: " purgeby
read -p "Purge on network? | Type staging or production: " network
read -p "Purge method? | Type invalidate or delete: " method

echo "Issuing purge..."

if [ "$purgeby" == url ]; then

	http -a purge: POST :"/ccu/v3/$method/$purgeby/$network" "Content-Type:application/json" < purge_urls.json
else 
	http -a purge: POST :"/ccu/v3/$method/$purgeby/$network" "Content-Type:application/json" < purge_cpcode.json

fi

echo "Purge complete..."
