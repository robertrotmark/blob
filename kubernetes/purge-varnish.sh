# Write your commands here

if (( "$#" != 2 )) 
then
    echo "Usage Info: $0 namespace banurl"
exit 1
fi

namespace=$1
#Verify that the namespace exist and that it's ready.
nsexist=$(kubectl get ns ${namespace} --template={{.status.phase}} )
if [ "$nsexist" != "Active" ]
then
    echo "Namespace does not exist."
    exit 1;
fi

banurl=$2
pods=$(kubectl get pod -n $namespace -l app=varnish -o jsonpath="{.items[*].metadata.name}")
for name in $pods
do
   echo Banning URL: $banurl in pod $name
   kubectl -n $namespace exec -it $name -- sh -c "varnishadm ban \"req.url == $banurl\""
done


