########################
# include the magic
########################
. /root/demo-magic/demo-magic.sh

clear
echo "# 1- Get roleID details "
echo ""
pei "export ROLE_ID=\$(vault read -format=json \\
  auth/${ROLE_NAME}/role/${ROLE_NAME}/role-id \\
  | jq -r '.data.role_id')"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 2- Request an encrypted token for the roleID"
echo ""
pei "export WRAPPED_TOKEN=\$(vault write -format=json \\
  -wrap-ttl=300s -force \\
  auth/${ROLE_NAME}/role/${ROLE_NAME}/secret-id \\
  | jq -r '.wrap_info.token')"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

echo "# 3- Store the wrapped token for nearly immediate use."
echo "# This simulates storing the wrapped token for the secret id in a secret store \\
# within the scope of the broker. We are limiting the use of the wrapped token \\
# to about 300 seconds." 

pei "cat <<EOF > ${SECRET_STORE_WRAPPED_TOKEN}
{
  \"token\" : \"${WRAPPED_TOKEN}\"
}
EOF"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}

unset WRAPPED_TOKEN

echo "# 3.1- Expose the wrapped token:"
pei "export WRAPPED_TOKEN=\$(cat ${SECRET_STORE_WRAPPED_TOKEN} | jq -r '.token')"
echo ""
echo "# 3.2- Use the wrapped token to get the SecretID for the RoleID:"
pei "export SECRET_ID=\$(VAULT_TOKEN=\${WRAPPED_TOKEN} vault unwrap -format=json \\
  | jq -r '.data.secret_id')"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
printf '\r'; printf ' %0.s' {0..28}; printf '\n%.s' {1..2}


echo "# 4- Store the SecretID and the RoleID in the trusted entity:"
echo "# This simulates storing the app role and secret id in a secret store \\
# within the scope of the broker. These are the access credentials to \\
# exchange secrets with Vault and should not be exposed."
pei "cat <<EOF > ${SECRET_STORE_APP_ROLE_CREDS}
{
  \"role_id\" : \"${ROLE_ID}\",
  \"secret_id\" : \"${SECRET_ID}\"
}
EOF"

unset SECRET_ID
