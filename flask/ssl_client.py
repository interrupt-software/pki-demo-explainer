#!/usr/bin/python3

import json
import socket
import ssl
import os

server_address = ('127.0.0.1', 10443)
server_sni_hostname = 'app1.dev.hashicat.io'
client_cert = 'client.crt'
client_key  = 'client.key'
client_certs = 'ca_bundle.crt'

def send_ssl_message(message):
    context = None
    s = None
    result = None

    try:
        context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH, cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')
    try: 
        context.load_cert_chain(certfile=client_cert, keyfile=client_key)
    except:
        raise ValueError('"certFile" and "keyFile" must indicate the valid certificate and key files.')
    try: 
        context.load_verify_locations(cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        conn = context.wrap_socket(s, server_side=False, server_hostname=server_sni_hostname)
        conn.connect(server_address)
    except (ConnectionError) as e:
        print("SSL exception. {}".format(e.args[-1]))

    try:
        result = json.dumps(conn.getpeercert(), indent=2, sort_keys=True)
    except:
        raise ValueError('"Unable to find peer certificate information."')
    finally:
        conn.send(message)
        conn.close()

    return result

def conn():
    context = None
    s = None
    result = None

    try:
        context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH, cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')
    try: 
        context.load_cert_chain(certfile=client_cert, keyfile=client_key)
    except:
        raise ValueError('"certFile" and "keyFile" must indicate the valid certificate and key files.')
    try: 
        context.load_verify_locations(cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        conn = context.wrap_socket(s, server_side=False, server_hostname=server_sni_hostname)
        conn.connect(server_address)
    except (SSLError) as e:
        print("SSL exception. {}".format(e.args[-1]))
    finally:
        result = json.dumps(conn.getpeercert(), indent=2, sort_keys=True)
        conn.send(b"Asking for peer certificate info.")
        conn.close()

    return result

def ssl_data():
    context = None
    s = None
    result = None

    try:
        context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH, cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')
    try: 
        context.load_cert_chain(certfile=client_cert, keyfile=client_key)
    except:
        raise ValueError('"certFile" and "keyFile" must indicate the valid certificate and key files.')
    try: 
        context.load_verify_locations(cafile=client_certs)
    except:
        raise ValueError('"caFile" must indicate a valid PEM file.')

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        conn = context.wrap_socket(s, server_side=False, server_hostname=server_sni_hostname)
        conn.connect(server_address)
    except (SSLError) as e:
        print("SSL exception. {}".format(e.args[-1]))
    finally:
        result = json.dumps(context.get_ca_certs(), indent=2, sort_keys=True)
        conn.send(b"Asking for CA certificate info.")
        conn.close()

    return result
    
