from flask import Flask, request, Response
import subprocess
import os

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    # Запускаем update.bat, указывая полный путь и shell=True
    bat_path = r"C:\nginx\html\index\update.bat"
    result = subprocess.run([bat_path], shell=True, capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print(result.stderr)
        return "Update failed", 500
    return "OK", 200

if __name__ == '__main__':
    # Слушаем все интерфейсы, порт 8080
    app.run(host='0.0.0.0', port=8080)