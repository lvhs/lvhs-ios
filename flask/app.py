from flask import Flask,request
import os

app = Flask(__name__)

@app.route("/")
def index():
    return "index"

@app.route("/push",methods=['POST'])
def push():
    if request.method == 'POST':
        data = request.data
        group = request.args.get("group")
        app = request.args.get("app")
        path = request.args.get("path")
        os.system("""cd {};
                        ipa build;
                        dgate push {} {};
                  """.format(path,group,app))
        return 'success'

if __name__ == '__main__':
    app.run(port=8001)