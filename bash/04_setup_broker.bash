########################
# include the magic
########################
. ${DEMO_MAGIC}/demo-magic.sh

source ${BASH_HOME}/01_env_bootstrap.bash


echo "# Ensure there is nothing on our desired endpoint:"
echo ""
vault auth disable ${ROLE_NAME}

clear
echo "# 1- Enable the path ${ROLE_NAME} approle:"
echo ""
pei "vault auth enable -path ${ROLE_NAME} approle"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 2- Create Vault policy ${ROLE_POLICY}:
# Full permissions on pki intermediate. To issue certificates, the
# minimus requirement is "write" but to access the secret path we
# need \"read\" as well."
echo ""
pei "vault policy write ${ROLE_POLICY} -<<EOF 
path \"${InterimCAName}/*\" {
  capabilities = [ \"create\", \"read\", \"update\", \"delete\", \"list\", \"sudo\" ]
}
EOF"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 3- Associate Vault policy ${ROLE_POLICY} with ${ROLE_NAME}:"
echo ""
pei "vault write auth/${ROLE_NAME}/role/${ROLE_NAME} \\
  token_policies=${ROLE_POLICY} \\
  secret_id_num_uses=${SECRET_ID_NUM_USES} \\
  token_num_uses=${TOKEN_NUM_USES}"