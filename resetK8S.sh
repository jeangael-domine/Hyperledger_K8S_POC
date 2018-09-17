kubectl delete deployment cli-org1-deployment
kubectl delete deployment ca-deployment
kubectl delete deployment orderer-deployment
kubectl delete deployment peer0-org1-deployment
kubectl delete deployment peer1-org1-deployment

kubectl delete service ca-node-port
kubectl delete service orderer-node-port
kubectl delete service peer0-org1-node-port
kubectl delete service peer1-org1-node-port

kubectl delete pvc couchdb-volume-claim

kubectl get deployments
kubectl get pods
kubectl get services
kubectl get pv
kubectl get pvc