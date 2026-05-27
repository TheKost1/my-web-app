from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    subprocess.run(["C:\Users\Admin\source\repos\semenar6\AdminIS\my-web-app\update.bat"])
    return "OK", 200

if __name__ == '__main__':
    app.run(port=8080)