#!/bin/sh

WORKING_DIR=/opt/gopath/src/github.com/hyperledger/fabric/peer/new-org
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/node-port/orderers/orderer.node-port/msp/tlscacerts/tlsca.node-port-cert.pem
CHANNEL_NAME=mychannel

echo "===================== Retrieving the genesis block of channel '$CHANNEL_NAME' ====================="
peer channel fetch 0 $WORKING_DIR/mychannel.block -o orderer-node-port:7050 -c $CHANNEL_NAME --cafile $ORDERER_CA
echo

echo "===================== Joining '$CORE_PEER_ADDRESS' to channel '$CHANNEL_NAME' ====================="
peer channel join -b $WORKING_DIR/mychannel.block
echo

CORE_PEER_ADDRESS=peer1-org2:7051
echo "===================== Joining '$CORE_PEER_ADDRESS' to channel '$CHANNEL_NAME' ====================="
peer channel join -b $WORKING_DIR/mychannel.block
echo

CORE_PEER_ADDRESS=peer0-org2:7051
echo "===================== Installing new version of mycc chaincode on '$CORE_PEER_ADDRESS' ====================="
peer chaincode install -n mycc -v 2.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02