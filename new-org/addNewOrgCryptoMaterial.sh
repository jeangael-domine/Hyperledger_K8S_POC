#!/bin/sh

WORKING_DIR=/opt/gopath/src/github.com/hyperledger/fabric/peer/new-org
CHANNEL_NAME=mychannel


echo "===================== Fetching config of channel '$CHANNEL_NAME' ===================== "
peer channel fetch config $WORKING_DIR/config_block.pb -o orderer-node-port:7050 -c $CHANNEL_NAME
echo

echo "===================== Trimming channel '$CHANNEL_NAME' config and converting it into JSON ===================== "
configtxlator proto_decode --input $WORKING_DIR/config_block.pb --type common.Block | jq .data.data[0].payload.data.config > $WORKING_DIR/config.json
echo

echo "===================== Appending the new org configuration definition ===================== "
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org2MSP":.[1]}}}}}' $WORKING_DIR/config.json $WORKING_DIR/org2.json > $WORKING_DIR/modified_config.json
echo

echo "===================== Translating config.json into protobuf ===================== "
configtxlator proto_encode --input $WORKING_DIR/config.json --type common.Config --output $WORKING_DIR/config.pb
echo

echo "===================== Encoding modified_config.json into modified_config.pb ===================== "
configtxlator proto_encode --input $WORKING_DIR/modified_config.json --type common.Config --output $WORKING_DIR/modified_config.pb
echo

echo "===================== Calculating the delta between the two config protobufs config.pb and modified_config.pb ===================== "
configtxlator compute_update --channel_id $CHANNEL_NAME --original $WORKING_DIR/config.pb --updated $WORKING_DIR/modified_config.pb --output $WORKING_DIR/org2_update.pb
echo

echo "===================== Decoding the delta into JSON ===================== "
configtxlator proto_decode --input $WORKING_DIR/org2_update.pb --type common.ConfigUpdate | jq . > $WORKING_DIR/org2_update.json
echo

echo "===================== Wrapping the update file in an envelope message ===================== "
echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat org2_update.json)'}}}' | jq . > $WORKING_DIR/org2_update_in_envelope.json
echo

echo "===================== Converting the envelope message into the fully fledged protobuf format required by Fabric ===================== "
configtxlator proto_encode --input $WORKING_DIR/org2_update_in_envelope.json --type common.Envelope --output $WORKING_DIR/org2_update_in_envelope.pb
echo

echo "===================== Signing the config with the Admin user ===================== "
peer channel signconfigtx -f $WORKING_DIR/org2_update_in_envelope.pb
echo

echo "===================== Updating the config of channel '$CHANNEL_NAME' ===================== "
peer channel update -f $WORKING_DIR/org2_update_in_envelope.pb -c $CHANNEL_NAME -o orderer-node-port:7050
echo