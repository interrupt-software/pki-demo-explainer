########################
# include the magic
########################
. /root/demo-magic/demo-magic.sh

source ${BASH_HOME}/01_env_bootstrap.bash

clear
echo "# 1- This sequence simulates the broker accessing the secret store \\
# within the scope of the broker. We assume the access credentials \\
# are valid and should fail nicely."
echo ""
pei "export ROLE_ID=\$(cat \${SECRET_STORE_APP_ROLE_CREDS} | jq -r '.role_id')"
pei "export SECRET_ID=\$(cat \${SECRET_STORE_APP_ROLE_CREDS} | jq -r '.secret_id')"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 2- Use the roleID identity to login and obtain a session token."
echo ""
pei "export APP_TOKEN=\$(vault write -format=json \\
  auth/\${ROLE_NAME}/login role_id=\${ROLE_ID} \\
  secret_id=\${SECRET_ID} \\
  | jq -r '.auth.client_token')"