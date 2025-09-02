from flask import Flask, jsonify
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

requests_total = Counter('requests_total', 'Total HTTP requests', ['endpoint'])

@app.route('/health')
def health():
    requests_total.labels('/health').inc()
    return jsonify(status='ok')

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/')
def index():
    requests_total.labels('/').inc()
    return 'Hello from DevOps Project 2!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
