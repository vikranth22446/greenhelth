from flask import render_template, request, jsonify
from app.main import main
from app import db
from PIL import Image
import cv2
import numpy as np
import time
from face_id.predict import build_database_dict, recognize_face, detector_cv2, model


@main.route("/")
@main.route("/<path:path>")
def home(path=None):
    return render_template("index.html")


database = build_database_dict("app/images/")


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
    img = Image.open(file.stream).convert("RGB")
    frame = np.array(img)
    frame = cv2.cvtColor(frame,cv2.COLOR_RGB2BGR)
    height, width, channels = frame.shape
    gray = cv2.cvtColor(frame.copy(), cv2.COLOR_BGR2GRAY)
    # cv2.imshow("gray", gray)
    # cv2.waitKey()
    faces = detector_cv2.detectMultiScale(gray, 1.3, 5)

    (x, y, w, h) = faces[0]
    face_image = frame[max(0, y) : min(height, y + h), max(0, x) : min(width, x + w)]
    
    photo_name, score = recognize_face(face_image, database, model)

    end_time = time.time()
    print("time taken", end_time - start_time)
    return jsonify({"msg": "success" if photo_name is not None else "failure", "photo_name": photo_name, "score": str(score)})
