#!/bin/sh

WORKING_DIRECTORY=$HOME/Hyperledger_K8S_POC
FABRIC_CFG_PATH=$WORKING_DIRECTORY/new-org

rm -Rf $FABRIC_CFG_PATH/crypto-config org2.json

cryptogen generate --config=$FABRIC_CFG_PATH/crypto-config.yaml --output=$FABRIC_CFG_PATH/crypto-config

configtxgen --configPath=$FABRIC_CFG_PATH -printOrg Org2MSP > $FABRIC_CFG_PATH/org2.json

cp -R $WORKING_DIRECTORY/crypto-config/ordererOrganizations $FABRIC_CFG_PATH/crypto-config/