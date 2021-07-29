RESOURCE=$1
NAME=$2
NAMESPACE=$3
if [ ! $RESOURCE ]; then
    echo "Must provide a resource type"
    exit
fi
if [ ! $NAME ]; then
    echo "Must provide a resource name"
    exit
fi

kubectl proxy &
if [ $RESOURCE != "namespace" ]; then

kubectl get $RESOURCE $NAME -n $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' > temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/${NAMESPACE}/${RESOURCE}s/${NAME}/finalize

else

kubectl get $RESOURCE $NAME -o json |jq '.spec = {"finalizers":[]}' > temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/${RESOURCE}s/${NAME}/finalize
fi

pkill kubectl
rm -rf temp.json

