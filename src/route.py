from flask import Flask, request

import logging
logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

@app.route('/')
def root_request():
    return "hello, world"


@app.route('/call/ai/msg/<action>', methods=['POST'])
def call_msg(action):
    app.logger.info(action)
    app.logger.info(request.data)
    assert action in ['robot', 'voice', 'call', 'duration']

    return {
        "code": 0,
        "msg": "成功"
    }


def route(port):
    app.run(host='0.0.0.0', port=port)
