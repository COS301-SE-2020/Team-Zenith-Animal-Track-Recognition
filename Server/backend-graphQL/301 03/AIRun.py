import os
import numpy as np
import matplotlib.pyplot as plt
import sys
import datetime

import tensorflow as tf


from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Conv2D, Flatten, Dropout, MaxPooling2D
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import datasets, layers, models
cwd = os.getcwd()
IMG_HEIGHT = 350
IMG_WIDTH = 350


probability_model= tf.saved_model.load('saved_model/mane/20200916,022303')



image_path=os.path.join(cwd, 'Za1gQIG1wJ89OaqIoyf4.jpeg')
# image_path= 'Za1gQIG1wJ89OaqIoyf4.jpg'
image = tf.keras.preprocessing.image.load_img(image_path,target_size=[IMG_HEIGHT, IMG_WIDTH])
input_arr = tf.keras.preprocessing.image.img_to_array(image)
input_arr = np.array([input_arr])  # Convert single image to a batch.
predictions = probability_model(input_arr)
print(predictions)
