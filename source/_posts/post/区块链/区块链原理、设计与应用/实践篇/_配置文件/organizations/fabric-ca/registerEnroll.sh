

function createProviderOrg {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org.provider.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org.provider.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-provider --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-provider.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-provider.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-provider.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-provider.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org.provider.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-provider --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-provider --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-provider --id.name providerOrgadmin --id.secret providerOrgadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org.provider.com/peers
  mkdir -p organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-provider -M ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/msp --csr.hosts peer0.org.provider.com --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.provider.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-provider -M ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls --enrollment.profile tls --csr.hosts peer0.org.provider.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org.provider.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.provider.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org.provider.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.provider.com/tlsca/tlsca.org.provider.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org.provider.com/ca
  cp ${PWD}/organizations/peerOrganizations/org.provider.com/peers/peer0.org.provider.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org.provider.com/ca/ca.org.provider.com-cert.pem

  mkdir -p organizations/peerOrganizations/org.provider.com/users
  mkdir -p organizations/peerOrganizations/org.provider.com/users/User1@org.provider.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-provider -M ${PWD}/organizations/peerOrganizations/org.provider.com/users/User1@org.provider.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org.provider.com/users/Admin@org.provider.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://providerOrgadmin:providerOrgadminpw@localhost:7054 --caname ca-provider -M ${PWD}/organizations/peerOrganizations/org.provider.com/users/Admin@org.provider.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/providerOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.provider.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.provider.com/users/Admin@org.provider.com/msp/config.yaml

}


function createSubscriberOrg {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org.subscriber.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org.subscriber.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-subscriber --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-subscriber.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-subscriber.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-subscriber.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-subscriber.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org.subscriber.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-subscriber --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-subscriber --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-subscriber --id.name subscriberOrgadmin --id.secret subscriberOrgadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org.subscriber.com/peers
  mkdir -p organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-subscriber -M ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/msp --csr.hosts peer0.org.subscriber.com --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-subscriber -M ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls --enrollment.profile tls --csr.hosts peer0.org.subscriber.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org.subscriber.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org.subscriber.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/tlsca/tlsca.org.subscriber.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org.subscriber.com/ca
  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/peers/peer0.org.subscriber.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org.subscriber.com/ca/ca.org.subscriber.com-cert.pem

  mkdir -p organizations/peerOrganizations/org.subscriber.com/users
  mkdir -p organizations/peerOrganizations/org.subscriber.com/users/User1@org.subscriber.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-subscriber -M ${PWD}/organizations/peerOrganizations/org.subscriber.com/users/User1@org.subscriber.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org.subscriber.com/users/Admin@org.subscriber.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://subscriberOrgadmin:subscriberOrgadminpw@localhost:8054 --caname ca-subscriber -M ${PWD}/organizations/peerOrganizations/org.subscriber.com/users/Admin@org.subscriber.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/subscriberOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.subscriber.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.subscriber.com/users/Admin@org.subscriber.com/msp/config.yaml

}


function createRegulatorOrg {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org.regulator.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org.regulator.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-regulator --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-regulator.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-regulator.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-regulator.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-regulator.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org.regulator.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-regulator --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-regulator --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-regulator --id.name regulatorOrgadmin --id.secret regulatorOrgadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org.regulator.com/peers
  mkdir -p organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/msp --csr.hosts peer0.org.regulator.com --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls --enrollment.profile tls --csr.hosts peer0.org.regulator.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org.regulator.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.regulator.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org.regulator.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org.regulator.com/tlsca/tlsca.org.regulator.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org.regulator.com/ca
  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/peers/peer0.org.regulator.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org.regulator.com/ca/ca.org.regulator.com-cert.pem

  mkdir -p organizations/peerOrganizations/org.regulator.com/users
  mkdir -p organizations/peerOrganizations/org.regulator.com/users/User1@org.regulator.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/org.regulator.com/users/User1@org.regulator.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org.regulator.com/users/Admin@org.regulator.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://regulatorOrgadmin:regulatorOrgadminpw@localhost:9054 --caname ca-regulator -M ${PWD}/organizations/peerOrganizations/org.regulator.com/users/Admin@org.regulator.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/regulatorOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org.regulator.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org.regulator.com/users/Admin@org.regulator.com/msp/config.yaml

}


function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/example.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml


}
