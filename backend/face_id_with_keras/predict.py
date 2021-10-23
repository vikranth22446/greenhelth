import numpy as np
from numpy import genfromtxt
import pandas as pd
import os
import glob
import cv2

# from mtcnn.mtcnn import MTCNN

from face_id import utils

# from utils import LRN2D
from face_id.inception_blocks import *

gpus = tf.config.list_physical_devices('GPU')
if gpus:
  # Restrict TensorFlow to only allocate 1GB of memory on the first GPU
  try:
    tf.config.experimental.set_memory_growth(gpus[0], True)
  except RuntimeError as e:
    # Virtual devices must be set before GPUs have been initialized
    print(e)



# show the architecture of the network
model = faceRecoModel((96, 96, 3))
model.summary()
print("loaded model into memory")

# load weights(this process will take a few minutes)
weights = utils.weights
weights_dict = utils.load_weights()
print("loaded model weights dict")

for name in weights:
    if model.get_layer(name) != None:
        model.get_layer(name).set_weights(weights_dict[name])
    elif model.get_layer(name) != None:
        model.get_layer(name).set_weights(weights_dict[name])

detector_cv2 = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
# detector_mtcnn= MTCNN()


def crop_face(img, save_file_name="images/test_image.jpg", cv2_detection=False):
    # detect the face, you can change the scaleFactor according to your case
    if cv2_detection:
        faces = detector_cv2.detectMultiScale(img, scaleFactor=1.5, minNeighbors=5)
        for (x, y, w, h) in faces:

            # outline the face area by a blue rectangle
            cv2.rectangle(img, (x, y), (x + w, y + h), (255, 0, 0), 2)
            # save the cropped face image into the datasets folder
            cv2.imwrite(save_file_name, img[y : y + h, x : x + w])
            break
    else:
        pass
        # result=detector_mtcnn.detect_faces(img)
        # for person in result:
        #     x, y, w, h= person['box']
        #     cv2.imwrite(save_file_name, img[y:y+h,x:x+w])
        #     break


# First, encode one single image into embeddings
def image_to_embedding(image, model):
    image = cv2.resize(image, (96, 96))
    img = image[..., ::-1]
    img = np.around(np.transpose(img, (0, 1, 2)) / 255.0, decimals=12)
    x_train = np.array([img])
    embedding = model.predict_on_batch(x_train)
    return embedding


# Second, build a database containing embeddings for all images
def build_database_dict(image_folder):
    database = {}
    for file in glob.glob(f"{image_folder}/*"):
        print("Adding file to database", file)
        database_name = os.path.splitext(os.path.basename(file))[0]
        image_file = cv2.imread(file, 1)
        database[database_name] = image_to_embedding(image_file, model)
    return database


# Third, identify images by using the embeddings(find the minimum L2 euclidean distance between embeddings)
def recognize_face(face_image, database, model):
    # TODO can vectorize this computation if too slow
    cv2.imshow("face_img", face_image)
    embedding = image_to_embedding(face_image, model)
    minimum_distance = 200
    name = None

    for (database_name, database_embedding) in database.items():

        euclidean_distance = np.linalg.norm(embedding - database_embedding)
        print("Euclidean distance from %s is %s" % (database_name, euclidean_distance))
        if euclidean_distance < minimum_distance:
            minimum_distance = euclidean_distance
            name = database_name

    if minimum_distance < 0.8:
        return name, minimum_distance
    else:
        return None, None
