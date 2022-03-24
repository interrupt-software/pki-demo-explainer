from flask import Flask
from flask import render_template
from flask import send_from_directory
from flask import stream_with_context
import os
from time import sleep
from multiprocessing import Process

app = Flask(__name__, static_url_path='')

import ssl_client
# import ssl_server

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/one')
def one():
    return render_template('page1.html')

@app.route('/two', methods=['GET'])
def two():
    return render_template('page2.html')

@app.route('/three', methods=['GET'])
def three():
    return render_template('page3.html')

@app.route('/four', methods=['GET'])
def four():
    return render_template('page4.html')

@app.route('/five', methods=['GET'])
def five():
    return render_template('page5.html')

@app.route('/six', methods=['GET'])
def six():
    return render_template('page6.html')

@app.route('/seven', methods=['GET'])
def seven():
    return render_template('page7.html')

@app.route('/eight', methods=['GET'])
def eight():
    return render_template('page8.html')

@app.route('/nine', methods=['GET'])
def nine():
    return render_template('page9.html')

@app.route('/ten', methods=['GET'])
def ten():
    return render_template('page10.html')

@app.route('/eleven', methods=['GET'])
def eleven():
    return render_template('page11.html')

@app.route('/root_token', methods=['GET'])
def root_token():
    return send_from_directory(app.static_folder, 'js/vault-unseal.json')

@app.route('/get_ssl_ca_data')
def get_ssl_ca_data():
    return ssl_client.ssl_data()

@app.route('/get_ssl_domain_data')
def get_ssl_domain_data():
    return ssl_client.conn()

@app.route('/send_ssl_message')
def send_ssl_message():
    return ssl_client.send_ssl_message(b"This is a test.")

# Need to work on async startup of the SSL Server
# TO DO: 
# 1- Build Async module library
# 2- Remove global logging as to not pollute ssl logs
# 
# ssl_server_running = False

# @app.route('/start_ssl_server')
# def start_ssl_server():
#     global ssl_server_running

#     my_ssl_server = Process (
#       target=ssl_server.run(),
#       daemon=True
#     )

#     if (ssl_server_running == False):
#         my_ssl_server.start()
#     return 

@app.route('/get_ssl_server_data')
def get_ssl_server_data():
    def generate():
        basedir = os.path.abspath(os.path.dirname(__file__))
        data_file = os.path.join(basedir, 'static/logs/server.log')
        with open(data_file, 'r') as f:
            for line in (f.readlines() [-6:]):
                yield line

    return app.response_class(generate(), mimetype='text/plain')

