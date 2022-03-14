
source ${BASH_HOME}/01_env_bootstrap.bash
source ${BASH_HOME}/06_broker_auth.bash

########################
# include the magic
########################
. ${DEMO_MAGIC}/demo-magic.sh

echo ""
echo "# Here are the identity credentials and the subsequent session token:"
echo ""
pei "echo \${ROLE_ID}"
echo ""
pei "echo \${SECRET_ID}"
echo ""
pei "echo \${APP_TOKEN}"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# Confirm the token identiy:"
echo ""
pei "unset VAULT_TOKEN"
pei "export VAULT_TOKEN=\${APP_TOKEN}"
pei "vault token lookup"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo ""
pei "cp \${CERTS_HOME}/\${InterimCAName}_ca_bundle.crt \${APP_HOME}/ca_bundle.crt"
echo ""
pei "export APP_NAME=\"app1.dev\""
echo ""
pei "export CRT_CONSUMER_ROLE=\"server\""
echo ""

pei "vault write -format=json \\
  \${InterimCAName}/issue/\${IntRoleName} \\
  common_name=\${APP_NAME}.\${CommonName} \\
  > \"\${CERTS_HOME}/\${APP_NAME}.\${CommonName}-\${CRT_CONSUMER_ROLE}.json\""
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

cat "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}.json" |  tee \
>(jq -r .data.ca_chain    > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_ca_chain.pem") \
>(jq -r .data.certificate > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem") \
>(jq -r .data.issuing_ca  > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_issuing_ca.pem") \
>(jq -r .data.private_key > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem")

sleep 2
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem ${APP_HOME}/server.key
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem ${APP_HOME}/server.crt

echo ""
pei "export CRT_CONSUMER_ROLE=\"client\""
echo ""
pei "vault write -format=json \\
  \${InterimCAName}/issue/\${IntRoleName} \\
  common_name=\${APP_NAME}.\${CommonName} \\
  > \"\${CERTS_HOME}/\${APP_NAME}.\${CommonName}-\${CRT_CONSUMER_ROLE}.json\""
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

cat "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}.json" |  tee \
>(jq -r .data.ca_chain    > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_ca_chain.pem") \
>(jq -r .data.certificate > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem") \
>(jq -r .data.issuing_ca  > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_issuing_ca.pem") \
>(jq -r .data.private_key > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem")

sleep 2
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem ${APP_HOME}/client.key
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem ${APP_HOME}/client.crt

unset VAULT_TOKEN
unset APP_TOKEN

# These are here for the demo and not related to the PKI exercise

cp ${APP_HOME}/server.* ${WWW_HOME}/.
cp ${APP_HOME}/client.* ${WWW_HOME}/.
cp ${APP_HOME}/ca_bundle.crt ${WWW_HOME}/.
