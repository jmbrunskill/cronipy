from flask import Flask
server = Flask(__name__)


@server.route("/")
def hello():
    return "The Web Server is working!"


if __name__ == "__main__":
    #By default Azure App Service expects the application to be listening on port 80
    server.run(host='0.0.0.0', port=80)
