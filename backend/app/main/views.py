from flask import render_template, request, jsonify
from app.main import main
from app import db
from PIL import Image
import cv2
import numpy as np
import glob
import os
import time
# from face_id.predict import build_database_dict, recognize_face, detector_cv2, model
import face_recognition

@main.route("/")
@main.route("/<path:path>")
def home(path=None):
    return render_template("index.html")

@main.route("/upload_photo/<str:image_name>", methods=["GET", "POST"])
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
    database_names, database_encodings = build_database_dict()

# Second, build a database containing embeddings for all images
def build_database_dict(image_folder):
    database_names = []
    database_encodings = []
    for file in glob.glob(f"{image_folder}/*"):
        print("Adding file to database", file)
        database_name = os.path.splitext(os.path.basename(file))[0]

        known_image = face_recognition.load_image_file(file)
        image_encoding = face_recognition.face_encodings(known_image)[0]

        database_encodings.append(image_encoding)
        database_names.append(database_name)
    return np.array(database_names), database_encodings

database_names, database_encodings = build_database_dict("app/images/")
@main.route("/identify_face", methods=["GET", "POST"])
def identify_face():
    """
    Catch all home view used to render the react code. This is rendered server side to allow
    for other configurations such as csrf tokens, etc.
    :return: the rendered template
    """
    print("Identifying Face")
    start_time = time.time()
    file = request.files["image"]
    img = Image.open(file.stream)
    img = np.array(img)
    face_locations = face_recognition.face_locations(img)
    uploaded_image_encoding = face_recognition.face_encodings(img, face_locations)
    results = face_recognition.compare_faces(np.array(database_encodings), uploaded_image_encoding)
    print(results, database_names)
    photos_detected = database_names[np.array(results)]
    print(photos_detected)
    print(time.time() - start_time)
    return jsonify({"msg": "success", "photo_name": str(photos_detected)})
