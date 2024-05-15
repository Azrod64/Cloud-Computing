import os
import sys
import json
import logging
import traceback
import requests


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

if __name__ != '__main__':
    app.logger.info('Polytech Example page v{}'.format(version))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def index(path):
    print("Avant call_hello")
    hello_message = call_hello(request.args.get('user'))
    #hello_message = {'greeting': 'test'}
    print("Après call_hello")
    return render_template(
        'index.html',
        headers=request.headers,
        version=version,
        **hello_message
    )


def call_hello(name):
    print("Début call_hello")
    url = '{}/hello?name={}'.format(os.environ['MICROSERVICE_URL'], name)
    app.logger.info('Je tente de contacter :  {}'.format(url))

    result = requests.get(url)
    app.logger.info('Contacted the API successfully, http status code {}'.format(result.status_code))
    print("Fin call_hello")
    return result.json()
