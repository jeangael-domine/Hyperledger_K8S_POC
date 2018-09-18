#!/bin/sh

WORKING_DIRECTORY=$HOME/Hyperledger_K8S_POC
FABRIC_CFG_PATH=$WORKING_DIRECTORY 

cryptogen generate --config=$WORKING_DIRECTORY/new-org/crypto-config.yaml --output="$WORKING_DIRECTORY/new-org/crypto-config"

configtxgen -printOrg Org2MSP > $WORKING_DIRECTORY/new-org/org2.json

cp -R $WORKING_DIRECTORY/crypto-config/ordererOrganizations $WORKING_DIRECTORY/new-org/crypto-config/