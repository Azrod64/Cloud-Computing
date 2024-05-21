import os
import sys
import json
import logging
import traceback
import requests

from time import sleep  # Importez cette ligne pour utiliser la fonction sleep()

from flask import Flask, request, render_template, send_from_directory, Response
from logging.config import dictConfig
 
version = '0.0.2' 

dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

app = Flask(__name__)

# Enregistrez la fonction de démarrage de l'application en tant que fonction principale
if __name__ != '__main__':
    app.logger.info('Polytech Example page v{}'.format(version))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

@app.route('/hello')
def call_hello():
    name = request.args.get('name', 'default_name')
    print('Dans mon microservice, le nom est : ', name)
    response = {'greeting': name}
    return response
