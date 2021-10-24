from flask import render_template, request, jsonify
from flask.globals import current_app
from app.main import main
from app import db
from PIL import Image
import cv2
import numpy as np
import glob
import os
import time
from app.models.user import History
# from face_id.predict import build_database_dict, recognize_face, detector_cv2, model
import face_recognition
from app.models.user import User
@main.route("/")
@main.route("/<path:path>")
def home(path=None):
    return render_template("index.html")

database_names, database_encodings = None, None
@main.route("/upload_photo/<string:image_name>", methods=["GET", "POST"])
def upload_photo(image_name):
    """
    Catch all home view used to render the react code. This is rendered server side to allow
    for other configurations such as csrf tokens, etc.
    :return: the rendered template
    """
    print("Identifying Face")
    start_time = time.time()
    file = request.files["image"]
    img = Image.open(file.stream)
    img.save(os.path.join("app/images", image_name))

    print("Rebuilding face database")
    global database_names, database_encodings 
    database_names, database_encodings = build_database_dict("app/images/")

# Second, build a database containing embeddings for all images
def build_database_dict(image_folder):
    database_names = []
    database_encodings = []
    users = User.query.all()
    for user in users:
        photo_name = user.photo_name
        full_path = os.path.join(image_folder, photo_name)
        print(full_path, user.student_name)
    
        known_image = face_recognition.load_image_file(full_path)
        image_encoding = face_recognition.face_encodings(known_image)[0]

        database_encodings.append(image_encoding)
        database_names.append(photo_name)
    return np.array(database_names), database_encodings

# database_names, database_encodings = build_database_dict("app/images/")
@main.route("/initialize_db", methods=["GET", "POST"])
def initialize_db():
    global database_names, database_encodings 
    database_names, database_encodings = build_database_dict("app/images")
    return jsonify({"status": 200, "names": [name for name in database_names]})

@main.route("/identify_face", methods=["GET", "POST"])
def identify_face():
    """
    Catch all home view used to render the react code. This is rendered server side to allow
    for other configurations such as csrf tokens, etc.
    :return: the rendered template
    """
    global database_names, database_encodings 
    if database_encodings is None:
        database_names, database_encodings = build_database_dict("app/images")
    print("Identifying Face")
    start_time = time.time()
    file = request.files["image"]
    img = Image.open(file.stream)
    img = np.array(img)
    face_locations = face_recognition.face_locations(img)
    uploaded_image_encoding = face_recognition.face_encodings(img, face_locations)
    results = face_recognition.compare_faces(np.array(database_encodings), uploaded_image_encoding)
    # distances = face_recognition.face_distance(np.array(database_encodings), uploaded_image_encoding)
    # photo_based_on_distance = database_names[np.argmin(distances)]
    # print(photo_based_on_distance)

    photos_detected = database_names[np.array(results)]
    green_badges_detected = []
    users = []
    usernames = []
    for photo in photos_detected:
        item = User.query.filter_by(photo_name=photo).first()
        users.append(users)
        usernames.append(item.student_name)
        green_badges_detected.append(item.green_badge)
        history_obj = History(student_id=item.student_id, status=item.green_badge)
        db.session.add(history_obj)
    db.session.commit()
    return jsonify({"msg": "success", "usernames": usernames, "green_badge_approved": green_badges_detected})

def dump_datetime(value):
    """Deserialize datetime object into string form for JSON processing."""
    if value is None:
        return None
    return [value.strftime("%Y-%m-%d"), value.strftime("%H:%M:%S")]

@main.route("/get_history", methods=["GET", "POST"])
def get_history():
    all_history = History.query.all()
    results = []
    status = []
    for history in all_history:
        detected_time = history.detected_time
        new_datetime = dump_datetime(detected_time)
        history_status = history.status
        status.append(history_status)
        results.append(new_datetime)
    return jsonify({"times": results, "status": status})
