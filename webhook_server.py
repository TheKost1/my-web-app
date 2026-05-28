from flask import Flask, request, jsonify
import subprocess
import logging
import os
from datetime import datetime

app = Flask(__name__)

# Настройка логирования
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Путь к скрипту обновления
UPDATE_SCRIPT = r"C:\nginx\html\index\update.bat"
DEPLOY_PATH = r"C:\nginx\html\index"

@app.route('/webhook', methods=['POST'])
def webhook():
    """Обработка webhook от GitHub"""
    try:
        # Проверяем, что запрос от GitHub
        data = request.json
        if data and 'ref' in data:
            branch = data['ref'].split('/')[-1]
            logger.info(f"Received webhook for branch: {branch}")
            
            # Обновляем только для main/master
            if branch in ['main', 'master']:
                logger.info("Triggering deployment...")
                result = subprocess.run(
                    [UPDATE_SCRIPT], 
                    capture_output=True, 
                    text=True,
                    shell=True
                )
                
                if result.returncode == 0:
                    logger.info(f"Deployment successful: {result.stdout}")
                    return jsonify({"status": "success", "message": "Deployed successfully"}), 200
                else:
                    logger.error(f"Deployment failed: {result.stderr}")
                    return jsonify({"status": "error", "message": result.stderr}), 500
            else:
                logger.info(f"Ignoring branch: {branch}")
                return jsonify({"status": "ignored", "message": f"Branch {branch} ignored"}), 200
        else:
            # Проверка health
            return jsonify({"status": "ok", "message": "Webhook server is running"}), 200
            
    except Exception as e:
        logger.error(f"Webhook error: {str(e)}")
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Endpoint для проверки здоровья сервера"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "deploy_path": DEPLOY_PATH,
        "script_exists": os.path.exists(UPDATE_SCRIPT)
    }), 200

if __name__ == '__main__':
    logger.info("Starting webhook server on port 8080")
    app.run(host='0.0.0.0', port=8080, debug=False)