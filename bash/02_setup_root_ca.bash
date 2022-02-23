########################
# include the magic
########################
. /root/demo-magic/demo-magic.sh

export _PWD="/var/www/html/bash"

source ${_PWD}/01_env_bootstrap.bash
mkdir -p ${CERTS_HOME}
chmod 777 ${CERTS_HOME}

pei "vault secrets disable ${RootCAName}"
pei "vault secrets enable -path ${RootCAName} pki"
pei "vault secrets tune -max-lease-ttl=${CA_ttl} ${RootCAName}"

pei "vault write -format=json ${RootCAName}/root/generate/internal \
common_name=\"${CommonName}\" \
province=\"Ontario\" \
organization=\"HashiCat Software\" \
ttl=${CA_ttl} | tee \
  >(jq -r .data.certificate > ${CERTS_HOME}/${RootCAName}_certicate.pem) \
  >(jq -r .data.issuing_ca  > ${CERTS_HOME}/${RootCAName}_issuing_ca.pem)"

pei "vault write ${RootCAName}/config/urls \
issuing_certificates=\"${VAULT_ADDR}/v1/${RootCAName}/ca\" \
crl_distribution_points=\"${VAULT_ADDR}/v1/${RootCAName}/crl\""

pei "vault write ${RootCAName}/roles/${CARoleName} \
allowed_domains=\"${CommonName}\" \
allow_subdomains=\"true\" \
max_ttl=${Cert_ttl}"

export leaf_common_name="dev.${CommonName}"

vault write -format=json ${RootCAName}/issue/${CARoleName} \
	common_name=${leaf_common_name} \
	province="Ontario" \
	organization="HashiCat Software" \
	ttl=${CA_ttl} | tee \
	>(jq -r .data.certificate > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_certicate.pem) \
	>(jq -r .data.issuing_ca  > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_issuing_ca.pem) \
	>(jq -r .data.private_key > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_private_key.key)
