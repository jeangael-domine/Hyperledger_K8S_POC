# POC to test the deployment of a Hyperledger blockchain using Kubernetes

The purpose of the POC is to set up a Hyperledger blockchain composed of a single two-peer organization and install the chaincode you can find in the Hyperledger fabric-samples (see https://hyperledger-fabric.readthedocs.io/en/latest/tutorials.html).

Steps to use the POC:

1) Once the repository is cloned, execute the following command:
`kubectl apply -f k8s`

2) Connect onto the cli container with a bash :
`kubectl exec -it XXX bash`

where XXX is the name of the CLI pod which can retrieved using `kubectl get pods`

3) Create the channel, the anchors and make the peer join the channel and install the chaincode by executing the script:
`./crypto/script.sh`

4) Instatiate the chaincode by executing :
`peer chaincode instantiate -o orderer-node-port:7050 -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR('Org1MSP.member','Org2MSP.member')"`
