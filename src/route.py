
from flask import Flask

app = Flask(__name__)

@app.route('/')
def root_request():
    return "hello, world"


@app.route('/call/ai/records', methods=['POST'])
def ai_records():
    return {
        "code": 0,
        "msg": "成功"
    }


def route(port):
    app.run(host='0.0.0.0', port=port)
