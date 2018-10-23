if [ $# -ne 1 ]; then 
	echo "Usage: 1 argument->network|staging or production "
	exit 1
fi	

network=$1

http -a purge: POST :"/ccu/v3/delete/cpcode/staging" "Content-Type:application/json" < purge_cpcode.json
