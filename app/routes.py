import os
from flask import Blueprint, jsonify, send_from_directory, current_app

main = Blueprint('main', __name__)

@main.route('/apps', methods=['GET'])
def get_apps():
    apps_dir = current_app.config['APP_REPO_PATH']
    apps = []
    for filename in os.listdir(apps_dir):
        if filename.endswith('.apk'):
            # Assuming you have a way to determine the package name
            package_name = "com.example." + filename.replace('.apk', '').lower()  # This is an example and may need to be adjusted
            app_info = {
                'name': filename,
                'packageName': package_name,  # Add the packageName here
                'icon': f'/static/icons/{filename}.png',
                'url': f'/download/{filename}',
                'description': f'Description for {filename}'
            }
            apps.append(app_info)
    return jsonify(apps)

@main.route('/download/<filename>', methods=['GET'])
def download_app(filename):
    return send_from_directory(current_app.config['APP_REPO_PATH'], filename)
