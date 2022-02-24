########################
# include the magic
########################
. /root/demo-magic/demo-magic.sh

source ${BASH_HOME}/01_env_bootstrap.bash

echo "# Ensure there is nothing on our desired endpoint:"
echo ""
vault secrets disable ${InterimCAName}

clear
echo "# 1- Enable the PKI engine at path ${InterimCAName}:"
echo ""
pei "vault secrets enable -path ${InterimCAName} pki"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 2- Configure the maximum lease period for ${InterimCAName} to ${CA_ttl}:"
echo ""
pei "vault secrets tune \\
  -max-lease-ttl=${CA_ttl} \\
  -description=\"Intermediate Certificate Authority\" \\
  ${InterimCAName}"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 3- Generate the certificate signing authority request (CSR) for ${InterimCAName}:"
echo ""
pei "vault write -format=json ${InterimCAName}/intermediate/generate/internal \\
  common_name=\"${InterimCAName}\" \\
  ttl=${IntCA_ttl} | tee \\
  >(jq -r .data.csr > ${CERTS_HOME}/${InterimCAName}.csr)"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 4- ${CommonName} to sign intermediate certificate and the CA chain for ${InterimCAName}:"
echo ""
pei "vault write -format=json ${RootCAName}/root/sign-intermediate \\
    csr=@${CERTS_HOME}/${InterimCAName}.csr \\
    common_name=\"${CommonName}\" \\
    ttl=${CA_ttl} | tee \\
    >(jq -r .data.certificate > ${CERTS_HOME}/${InterimCAName}_certificate.pem) \\
    >(jq -r .data.issuing_ca >  ${CERTS_HOME}/${InterimCAName}_issuing_ca.pem)"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 5- Genered signed intermediate certificate and the CA chain for ${InterimCAName}:"
echo ""
pei "vault write ${InterimCAName}/intermediate/set-signed \\
certificate=@${CERTS_HOME}/${InterimCAName}_certificate.pem"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 6- Configure the URL for the certificate issuer and the certificate revocation list for ${InterimCAName}:"
echo ""
pei "vault write ${InterimCAName}/config/urls \\
  issuing_certificates=\"${VAULT_ADDR}/v1/${InterimCAName}/ca\" \\
  crl_distribution_points=\"${VAULT_ADDR}/v1/${InterimCAName}/crl\""
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 7- Associate a Vault role to broker communications with CA for ${InterimCAName}:"
echo ""
pei "vault write ${InterimCAName}/roles/${IntRoleName} \\
    allowed_domains="dev.${CommonName}" \\
    allow_subdomains="true" \\
    max_ttl=${Cert_ttl} \\
    generate_lease=true"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 8 - Create bundle for dev.${InterimCAName}:"
echo ""
export leaf_common_name="dev.${InterimCAName}"
echo ""
pei "cat \\
  ${CERTS_HOME}/${InterimCAName}_issuing_ca.pem \\
  ${CERTS_HOME}/${InterimCAName}_certificate.pem \\
  > ${CERTS_HOME}/${InterimCAName}_ca_bundle.crt"
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}
