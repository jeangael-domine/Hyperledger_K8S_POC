# POC to test the deployment of a Hyperledger blockchain using Kubernetes

The purpose of the POC is to set up a Hyperledger blockchain composed of a single two-peer organization and install the chaincode you can find in the Hyperledger fabric-samples (see https://hyperledger-fabric.readthedocs.io/en/latest/tutorials.html).

Steps to use the POC:

1. Once the repository is cloned, execute the following command:

```
kubectl apply -f k8s
```

2. Connect onto the cli container with a bash :

```
kubectl exec -it XXX bash
```

where XXX is the name of the CLI pod which can retrieved using `kubectl get pods`


*********** The remaining steps must be performed from the bash ***********

3. Create the channel, the anchors and make the peer join the channel and install the chaincode by executing the script:
```
./script.sh
```

4. Instantiate the chaincode by executing :

```
peer chaincode instantiate -o orderer-node-port:7050 -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR('Org1MSP.member','Org2MSP.member')"
```

.) Query the blockchain:

```
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
```

6. Perform a transaction:

```
peer chaincode invoke -o orderer-node-port:7050 -C mychannel -n mycc  -c '{"Args":["invoke","a","b","10"]}'
```

7. Query the blockchain from the both peers (to check it is up to date as well:

```
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
export CORE_PEER_ADDRESS=peer1-org1-node-port:7051
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","b"]}'
```


NB:

1)Hyperledger uses configuration located inside the *crypto-config* and *channel-artifacts* folders to set up the blockchain (peers, orderer, ...).
As the **Kubernetes** containers need to have access to them, they are mounted as hostPath volumes and not NFS volumes as most tutorials on the net do.
I did that so as to simplify as much as possible the set up of a working environment because I did not wand to spend time on a NFS server setup (it may be simple to do but I did not know anything about it at the time of the POC).

2) One of the biggest issues I encountered was the instantiation of the blockchain. Indeed by default the peer creates a dedicated docker container for the chaincode using the docker daemon of the host.
This is problematic because in this case the container does not belong to the K8S cluster and thus cannot communicate with the it. As a consequence, it cannot reach back to the peer as they are not in the same network.
The solution I used was to add to the Peers' pods a *Docker daemon* container that the peer connects to in order to create the chaincode container. Thus they are on the same network and can communicate together.