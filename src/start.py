import sys

from route import route

if __name__ == '__main__':
    port = 2022
    if len(sys.argv) > 1:
        port = int(sys.argv[1])
    route(port)
