import hvac
import os

VAULT_ADDR =  os.environ.get('VAULT_ADDR', 'http://192.168.56.104:8200')
VAULT_TOKEN =  os.environ.get('VAULT_TOKEN', 'root')

client = hvac.Client(
    url=VAULT_ADDR,
    token=VAULT_TOKEN,
    verify=True,
)

# print(client.is_authenticated())

generate_certificate_response = client.secrets.pki.generate_certificate(
   name='dev-python-dot-com',
   common_name='app1.dev.hashicat.io',
   mount_point='interrupt-ca-intermediate'
)

rr = generate_certificate_response

print(rr)

f = open("server.crt","w+")
f.write(rr['data']['certificate'])
f.close()

f = open("server.key","w+")
f.write(rr['data']['private_key'])
f.close()

rr = generate_certificate_response

f = open("client.crt","w+")
f.write(rr['data']['certificate'])
f.close()

f = open("client.key","w+")
f.write(rr['data']['private_key'])
f.close()
