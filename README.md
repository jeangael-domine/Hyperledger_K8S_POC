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

4) Instantiate the chaincode by executing :

`peer chaincode instantiate -o orderer-node-port:7050 -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR('Org1MSP.member','Org2MSP.member')"`

NB:

Hyperledger uses configuration located inside the crypto-config and channel-artifacts folders to set up the blockchain (peers, orderer, ...).
As the Kubernetes containers need to have access to them, they are mounted as hostPath volumes and not NFS volumes as most tutorials on the net do.
I did that so as to simplify as much as possible the set up of a working environment because I did not wand to spend time on a NFS server setup (it may be simple to do but I did not know anything about it at the time of the POC).