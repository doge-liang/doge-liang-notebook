function setGoCC() {
    export CC_LANG=golang
    export CC_PATH=${PWD}/chaincode/chaincode_example01/go
}

function setupCommonENV() {
    export FABRIC_CFG_PATH=${PWD}/fabric-bin/${FABRIC_VERSION}/config
    export ORDERER_ADDRESS=localhost:7050
    export PEER0_PROVIDER_ADDRESS=localhost:7051
    export PEER0_SUBSCRIBER_ADDRESS=localhost:9051
    export PEER1_SUBSCRIBER_ADDRESS=localhost:9052
    export PEER0_REGULATOR_ADDRESS=localhost:10051
    export PEER0_PROVIDER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/ca.crt
    export PEER0_SUBSCRIBER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/ca.crt
    
    export ORDERER_CA=${PWD}/organizations/ordererOrganizations/org.orderer.com/orderers/org.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem
    export CHANNEL_NAME=mychannel
}

function setupSubscriberPeerENV1() {
    export CORE_PEER_LOCALMSPID=SubscriberMSP
    export CORE_PEER_ADDRESS=$PEER0_SUBSCRIBER_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org.subscriber.com/users/Admin@org.subscriber.com/msp
}

function setupSubscriberPeerENV2() {
    export CORE_PEER_LOCALMSPID=SubscriberMSP
    export CORE_PEER_ADDRESS=$PEER1_SUBSCRIBER_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer1.org.subscriber.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer1.org.subscriber.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer1.org.subscriber.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org.subscriber.com/users/Admin@org.subscriber.com/msp
}

function setupProviderPeerENV() {
    export CORE_PEER_LOCALMSPID=ProviderMSP
    export CORE_PEER_ADDRESS=$PEER0_PROVIDER_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org.provider.com/users/Admin@org.provider.com/msp
}

function setupRegulatorPeerENV() {
    export CORE_PEER_LOCALMSPID=RegulatorMSP
    export CORE_PEER_ADDRESS=$PEER0_REGULATOR_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org.regulator.com/users/Admin@org.regulator.com/msp
}