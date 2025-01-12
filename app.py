# app.py
from flask import Flask, request, jsonify
import subprocess
import os

app = Flask(__name__)

def check_email_exists(email):
    """Checks if an email address exists using the check_if_email_exists CLI."""
    try:
        result = subprocess.run(
            ["./target/release/check_if_email_exists", email],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        return None

@app.route('/check-email', methods=['GET'])
def check_email():
    email = request.args.get('email')
    if not email:
        return jsonify(error="Email parameter is required"), 400

    result = check_email_exists(email)
    if result:
        return jsonify(result=result)
    else:
        return jsonify(error="Failed to check email"), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
