from flask import Flask

app = Flask(__name__)


@app.route('/')
def root_request():
    return "hello, world"


@app.route('/call/ai/msg/robot', methods=['POST'])
def robot_msg():
    return {
        "code": 0,
        "msg": "成功"
    }


@app.route('/call/ai/msg/voice', methods=['POST'])
def voice_msg():
    return {
        "code": 0,
        "msg": "成功"
    }


@app.route('/call/ai/msg/call', methods=['POST'])
def call_msg():
    return {
        "code": 0,
        "msg": "成功"
    }


@app.route('/call/ai/msg/duration', methods=['POST'])
def duration_msg():
    return {
        "code": 0,
        "msg": "成功"
    }


def route(port):
    app.run(host='0.0.0.0', port=port)
