from flask import Flask, render_template, request, redirect, url_for, flash
import socket
import boto3
import json
from datetime import datetime
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'dev-secret-key')

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ.get('FEEDBACK_BUCKET', 'feedback-app-submissions-l00203120')

@app.route('/')
def home():
    hostname = socket.gethostname()
    return render_template('index.html', hostname=hostname)

@app.route('/submit', methods=['POST'])
def submit_feedback():
    try:
        feedback = request.form.get('feedback', '').strip()
        
        if not feedback:
            flash('Please enter feedback.', 'error')
            return redirect(url_for('home'))
        
        feedback_data = {
            'timestamp': datetime.utcnow().isoformat(),
            'feedback': feedback,
            'pod': socket.gethostname()
        }
        
        filename = f"feedback-{datetime.utcnow().strftime('%Y%m%d-%H%M%S-%f')}.json"
        
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=json.dumps(feedback_data, indent=2),
            ContentType='application/json'
        )
        
        flash('Feedback submitted!', 'success')
        
    except Exception as e:
        app.logger.error(f"Error: {str(e)}")
        flash('Error submitting feedback.', 'error')
    
    return redirect(url_for('home'))

@app.route('/health')
def health():
    return {'status': 'healthy', 'pod': socket.gethostname()}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
