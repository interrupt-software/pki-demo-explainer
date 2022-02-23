########################
# include the magic
########################
. /root/demo-magic/demo-magic.sh

export _PWD="/var/www/html/bash"

source ${_PWD}/01_env_bootstrap.bash
mkdir -p ${CERTS_HOME}
chmod 777 ${CERTS_HOME}

echo "# Ensure there is nothing on our desired endpoint:"
echo ""
vault secrets disable ${RootCAName}
echo ""

clear
echo "# 1- Enable the PKI secrets engine at path ${RootCAName}:"
echo ""
pei "vault secrets enable -path ${RootCAName} pki"
echo ""
read -n 1 -s -r -p "Press any key to continue..."

clear
echo "# 2- Configure the maximum lease period for the root CA to ${CA_ttl}:"
echo ""
pei "vault secrets tune -max-lease-ttl=${CA_ttl} ${RootCAName}"
echo ""
read -n 1 -s -r -p "Press any key to continue..."

clear
echo "# 3- Generate the root certificate and the CA chain for ${CommonName}:"
echo ""
pei "vault write -format=json ${RootCAName}/root/generate/internal \\
	common_name=\"${CommonName}\" \\
	province=\"Ontario\" \\
	organization=\"HashiCat Software\" \\
	ttl=${CA_ttl} | tee \\
		>(jq -r .data.certificate > ${CERTS_HOME}/${RootCAName}_certicate.pem) \\
		>(jq -r .data.issuing_ca  > ${CERTS_HOME}/${RootCAName}_issuing_ca.pem)"
echo ""
read -n 1 -s -r -p "Press any key to continue..."

clear
echo "# 4- Configure the URL for the certificate issuer and the certificate revocation list for ${CommonName}:"
echo ""
pei "vault write ${RootCAName}/config/urls \\
	issuing_certificates=\"${VAULT_ADDR}/v1/${RootCAName}/ca\" \\
	crl_distribution_points=\"${VAULT_ADDR}/v1/${RootCAName}/crl\""
echo ""
read -n 1 -s -r -p "Press any key to continue..."

clear
echo "# 5- Associate a Vault role to broker communications with CA ${RootCAName}:"
echo ""
pei "vault write ${RootCAName}/roles/${CARoleName} \\
	allowed_domains=\"${CommonName}\" \\
	allow_subdomains=\"true\" \\
	max_ttl=${Cert_ttl}"
echo ""
read -n 1 -s -r -p "Press any key to continue..."

clear
echo "# 6.1- Create a leaf for dev.${CommonName}:"
echo ""
pei "export leaf_common_name=dev.${CommonName}"
echo ""
echo "# 6.2- Create bundle for dev.${CommonName}:"
echo ""
pei "vault write -format=json ${RootCAName}/issue/${CARoleName} \\
	common_name=${leaf_common_name} \\
	province=\"Ontario\" \\
	organization=\"HashiCat Software\" \\
	ttl=${CA_ttl} | tee \\
	>(jq -r .data.certificate > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_certicate.pem) \\
	>(jq -r .data.issuing_ca  > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_issuing_ca.pem) \\
	>(jq -r .data.private_key > ${CERTS_HOME}/${RootCAName}_${leaf_common_name}_private_key.key)"
