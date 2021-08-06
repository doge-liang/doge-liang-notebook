#!/bin/bash

######################## 安装发布者的链码 #############################
. ./scripts/utils.sh
setupProviderPeerENV

# 链码名
export CC_NAME=strategy
# 链码版本
export CC_VERSION=v1.0
# 链码序列号
export CC_SEQ=1
# 链码策略
# export CC_POLICY="OR('ProviderMSP.peer', 'SubscriberMSP.peer', 'RegulatorMSP.peer')"
export CC_POLICY="OR('ProviderMSP.peer')"
# 可以不设置,自己用来过滤脚本用的
export CC_LIFECYCLE="DEPLOY"
export CC_LABEL=${CC_NAME}_${CC_VERSION}
# 设置 Go 链码的变量
setGoCC

# 检查是否配置了私有数据集合配置文件
if [[ -f ${CC_PATH}/../../collections_config.json ]]; then
    export PRIVATE_COLLECTION_DEF="--collections-config ${CC_PATH}/../../collections_config.json"
fi

pushd $CC_PATH
./build.sh
popd

set -x
rm tmp/${CC_LABEL}.tar.gz
peer lifecycle chaincode package tmp/${CC_LABEL}.tar.gz --path ${CC_PATH} --lang $CC_LANG --label ${CC_LABEL}

set +x

setupProviderPeerENV
peer lifecycle chaincode install tmp/${CC_LABEL}.tar.gz
setupSubscriberPeerENV1
peer lifecycle chaincode install tmp/${CC_LABEL}.tar.gz

PACKAGE_ID=$(peer lifecycle chaincode queryinstalled --output json | jq -r '.installed_chaincodes[] | select(.label == env.CC_LABEL) | .package_id')
echo "PACKAGE_ID('$ORGANIZATION_NAME'):" ${PACKAGE_ID}

# 以发布者身份同意链码定义
setupProviderPeerENV
peer lifecycle chaincode approveformyorg \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --init-required \
    --package-id ${PACKAGE_ID} \
    --sequence $CC_SEQ \
    --waitForEvent \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF

# 以订阅者身份同意链码定义，由于不安装该链码可以不加 packageID
setupSubscriberPeerENV1
peer lifecycle chaincode approveformyorg \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --init-required \
    --package-id ${PACKAGE_ID} \
    --sequence $CC_SEQ \
    --waitForEvent \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF


setupProviderPeerENV
peer lifecycle chaincode commit \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    --peerAddresses $PEER0_PROVIDER_ADDRESS \
    --tlsRootCertFiles $PEER0_PROVIDER_TLS_ROOTCERT_FILE \
    --peerAddresses $PEER0_SUBSCRIBER_ADDRESS \
    --tlsRootCertFiles $PEER0_SUBSCRIBER_TLS_ROOTCERT_FILE \
    -C $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence $CC_SEQ \
    --init-required \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --isInit -c '{"Function":"","Args":[]}'

######################################################################

# 设置 provider 组织变量
setupProviderPeerENV
# 设置 subscriber 组织变量
setupSubscriberPeerENV

# 登录 Subscriber.user1
# fabric-ca-client enroll -u https://user1:user1pw@localhost:9202 \
#     --caname ca-Subscriber \
#     --tls.certfiles ${PWD}/organizations/peerOrganizations/subscriber.mynetwork.com/ca/ca.subscriber.mynetwork.com-cert.pem
setupSubscriberUser1ENV

# 登录 Subscriber.user2
# fabric-ca-client enroll -u https://user2:user2pw@localhost:9202 \
#     --caname ca-Subscriber \
#     --tls.certfiles ${PWD}/organizations/peerOrganizations/subscriber.mynetwork.com/ca/ca.subscriber.mynetwork.com-cert.pem
setupSubscriberUser2ENV

peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"'Init'","Args":[""]}'

# Query 测试
peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetAllStrategies", "Args":[""]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"IsProvided", "Args":["6799979985630134272"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetAllTradesByStrategyID", "Args":["6799980250357825536"]}' | jq
peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetTradesPageByStrategyID", "Args":["6799980250357825536", "", ""]}' | jq
peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"DelTradesByStrategyID", "Args":["6799980250357825536"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetPositionsByStrategyID", "Args":["6799979985630134272"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetPositionsHashByStrategyID", "Args":["6799979985630134272"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetPlanningTradesByStrategyID", "Args":["6799979985630134272"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"GetPlanningTradesHashByStrategyID", "Ar  gs":["6799979985630134272"]}' | jq

# 使用如下命令可以验证哈希值的正确性，注意 key/value 的顺序
echo -n "{\"id\":\"6804443402281680896\",\"strategyID\":\"6799979985630134272\",\"stockID\":\"600161.SH\",\"amount\":-100}" |shasum -a 256

peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"DeleteStrategy", "Args":["6799979314809929728"]}'

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"ReadTrades", "Args":["3"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"ReadPositions", "Args":["3"]}' | jq

peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c '{"Function":"StrategyExists", "Args":["3"]}' | jq

# Invoke 测试
# 新建策略
peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"Distribute","Args":["{\"ID\":\"1\",\"name\":\"新建测试策略名\",\"provider\":\"\",\"maxDrawdown\":0.1,\"sharpeRatio\":0.1,\"annualReturn\":0.2,\"subscribers\":[],\"state\":0}"]}'


{"ID":"1",
"strategyID":"1",
"stockID":"测试股票",
"amount":100,
"commission":100.5,
"dateTime":"2020-05-19T08:00:00+08:00",
"price":100.1}

"{\"ID\":\"1\",\"name\":\"RSI\",\"provider\":\"\",\"maxDrawdown\":19.933237749831438,\"annualReturn\":18.856075857426564,\"sharpeRatio\":0.6830671762335108,\"subscribers\":[],\"state\":\"private\",\"planningTrades\":[],\"trades\":[{\"ID\":\"0\",\"amount\":100,\"commission\":61.84,\"price\":22.861,\"stockID\":\"002821.SZ\",\"dateTime\":\"2020-05-19T08:00:00+08:00\"},{\"ID\":\"1\",\"amount\":100,\"commission\":6.86,\"dateTime\":\"2020-05-19T08:00:00+08:00\",\"price\":22.861,\"stockID\":\"300498.SZ\"}],\"positions\":[]}"

# 1. "Args":["..."]
# 2. JSON需要被转义之后才能放进去

{"ID":"strategy_3","name":"新建测试策略名","provider":"","maxDrawdown":0.1,"annualReturn":0.2,"subscribers":[],"state":"private","trades":[{"stockID":"stock1","amount":10,"commission":10,"dateTime":"2021-04-20T06:18:11.401905999Z","price":100}],"positions":[{"stockID":"stock1","Price":100,"amount":10}]}
peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"SetStrategyPublic", "Args":["1"]}'

peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"SetStrategyPrivate", "Args":["1"]}'

# TODO:未测试
peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"Update", "Args":["1", "[{\"ID\":\"1\",\"strategyID\":\"1\",\"stockID\":\"测试股票\",\"amount\":100,\"commission\":100.5,\"dateTime\":\"2020-05-19T08:00:00+08:00\",\"price\":100.1}]", "[]", "[]"]}'

# 删除策略

fabric-ca-client enroll -u https://admin:adminpw@localhost:9201 \
    --caname ca-Provider \
    --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem

fabric-ca-client register --caname ca-Provider \
    --id.name peer0 \
    --id.secret peer0pw \
    --id.type peer \
    --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem

fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9201 \
    --caname ca-Provider \
    -M /home/ubuntu/mynetwork/organizations/peerOrganizations/provider.mynetwork.com/peers/peer0.provider.mynetwork.com/msp \
    --csr.hosts peer0.provider.mynetwork.com \
    --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem

fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9201 \
    --caname ca-Provider \
    -M /home/ubuntu/mynetwork/organizations/peerOrganizations/provider.mynetwork.com/peers/peer0.provider.mynetwork.com/tls \
    --enrollment.profile tls \
    --csr.hosts peer0.provider.mynetwork.com \
    --csr.hosts localhost \
    --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem

fabric-ca-client enroll -u https://user1:user1pw@localhost:9201 --caname ca-Provider -M /home/ubuntu/mynetwork/organizations/peerOrganizations/provider.mynetwork.com/users/User1@provider.mynetwork.com/msp --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem
fabric-ca-client enroll -u https://providerOrgadmin:providerOrgadminpw@localhost:9201 --caname ca-Provider -M /home/ubuntu/mynetwork/organizations/peerOrganizations/provider.mynetwork.com/users/Admin@provider.mynetwork.com/msp --tls.certfiles /home/ubuntu/mynetwork/organizations/fabric-ca/providerOrg/tls-cert.pem

# 订阅测试
peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    --ordererTLSHostnameOverride orderer.mynetwork.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    -c '{"Function":"Subscribe", "Args":["1"]}'


PutState puts the specified `key` and `value` into the transaction's writeset as a data-write proposal. PutState doesn't effect the ledger until the transaction is validated and successfully committed. Simple keys must not be an empty string and must not start with a null character (0x00) in order to avoid range query collisions with composite keys, which internally get prefixed with 0x00 as composite key namespace. In addition, if using CouchDB, keys can only contain valid UTF-8 strings and cannot begin with an underscore ("_").

CreateCompositeKey combines the given `attributes` to form a composite key. The objectType and attributes are expected to have only valid utf8 strings and should not contain U+0000 (nil byte) and U+10FFFF (biggest and unallocated code point). The resulting composite key can be used as the key in PutState().

