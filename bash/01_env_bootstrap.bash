export DEMO_MAGIC=" /root/demo-magic"
export BASH_HOME="/root/www/bash"
export CERTS_HOME="${BASH_HOME}/certs"
export APP_HOME="${BASH_HOME}/app"

# We make the assumption that the Vault token is
# exposed to the script owner. This example is here
# to express the requirement in the enviornment.
#export VAULT_TOKEN="s.XTHfFBq5GFBQyIdXJwiastSd"
export VAULT_ADDR="http://127.0.0.1:8200"

export RootName="hashicat"
export CommonName="hashicat.io"
export CA_ttl="24h"
export RootCAName="${RootName}-ca-root"
export CARoleName="${RootName}-ca-role"

export InterimCAName="${RootName}-ca-intermediate"
export IntCA_ttl="12h"
export Cert_ttl="8h"
export IntRoleName="${RootName}-int-role"

# For PKI distribution
export ROLE_NAME="pki-broker-role"
export ROLE_POLICY="pki-broker-policy"
export SECRET_ID_NUM_USES=0
export TOKEN_NUM_USES=0
export SECRET_STORE_APP_ROLE_CREDS="${BASH_HOME}/.app_role_creds"
export SECRET_STORE_WRAPPED_TOKEN="${BASH_HOME}/.wrapped_token"

## Build assets directories
mkdir -p ${CERTS_HOME}
chmod 755 ${CERTS_HOME}
mkdir -p ${APP_HOME}
chmod 755 ${APP_HOME}
