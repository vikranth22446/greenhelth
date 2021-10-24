import requests
import time
with open('test_images/daniel_won_test2.jpg', 'rb') as f:
    start_time = time.time()

    r = requests.post("http://20.83.127.0:3000/identify_face", files={'image': f.read()})
    print(r.json())
    print(time.time() - start_time)

with open('test_images/obama.jpeg', 'rb') as f:
    start_time = time.time()

    r = requests.post("http://20.83.127.0:3000/identify_face", files={'image': f.read()})
    print(r.json())
    print(time.time() - start_time)

with open('test_images/random_guy.jpeg', 'rb') as f:
    start_time = time.time()
    r = requests.post("http://20.83.127.0:3000/identify_face", files={'image': f.read()})
    print(r.json())
    print(time.time() - start_time)

with open('test_images/yousef2.jpg', 'rb') as f:
    start_time = time.time()

    r = requests.post("http://20.83.127.0:3000/identify_face", files={'image': f.read()})
    print(r.json())
    print(time.time() - start_time)


# import face_recognition
# known_image = face_recognition.load_image_file("obama.jpeg")
# unknown_image = face_recognition.load_image_file("app/images/Obama.jpg")

# biden_encoding = face_recognition.face_encodings(known_image)[0]
# unknown_encoding = face_recognition.face_encodings(unknown_image)[0]

# # face_locations = face_recognition.face_locations(rgb_frame)
# # face_encodings = face_recognition.face_encodings(rgb_frame, face_locations)

# results = face_recognition.compare_faces([biden_encoding], unknown_encoding)
# face_distances = face_recognition.face_distance([biden_encoding], unknown_encoding)
# print(results)