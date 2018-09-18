#!/bin/sh

WORKING_DIR=/opt/gopath/src/github.com/hyperledger/fabric/peer/new-org
CHANNEL_NAME=mychannel

peer channel fetch config config_block.pb -o orderer-node-port:7050 -c $CHANNEL_NAME

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > $WORKING_DIR/config.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org2MSP":.[1]}}}}}' $WORKING_DIR/config.json $WORKING_DIR/org2.json > $WORKING_DIR/modified_config.json

configtxlator proto_encode --input $WORKING_DIR/config.json --type common.Config --output $WORKING_DIR/config.pb

configtxlator proto_encode --input $WORKING_DIR/modified_config.json --type common.Config --output $WORKING_DIR/modified_config.pb

configtxlator compute_update --channel_id $CHANNEL_NAME --original $WORKING_DIR/config.pb --updated modified_config.pb --output $WORKING_DIR/org2_update.pb

configtxlator proto_decode --input $WORKING_DIR/org2_update.pb --type common.ConfigUpdate | jq . > $WORKING_DIR/org2_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat org2_update.json)'}}}' | jq . > $WORKING_DIR/org2_update_in_envelope.json

configtxlator proto_encode --input $WORKING_DIR/org2_update_in_envelope.json --type common.Envelope --output $WORKING_DIR/org2_update_in_envelope.pb

peer channel signconfigtx -f $WORKING_DIR/org2_update_in_envelope.pb

peer channel update -f $WORKING_DIR/org2_update_in_envelope.pb -c $CHANNEL_NAME -o orderer-node-port:7050