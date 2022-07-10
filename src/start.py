import sys

from flask import Flask

app = Flask(__name__)


@app.route('/')
def root_request():
    return "hello, world"


if __name__ == '__main__':
    print(f"Arguments count: {len(sys.argv)}")
    port = 2022
    if len(sys.argv) > 1:
        port = int(sys.argv[1])
    app.run(host='0.0.0.0', port=port)
