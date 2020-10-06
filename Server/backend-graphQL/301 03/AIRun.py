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
IMG_HEIGHT = 500
IMG_WIDTH = 500

modilName='P/A0.4583333432674408E6G0S'

probability_model= tf.saved_model.load(modilName)
asseatorName= modilName+".txt"
with open(asseatorName) as f:
    content = f.readlines()
# you may also want to remove whitespace characters like `\n` at the end of each line
content = [x.strip() for x in content] 
# print(content)


# image_path=os.path.join(cwd, 'IMG_4557.JPG')
image_path=os.path.join(cwd, sys.argv[1])
# image_path= 'Za1gQIG1wJ89OaqIoyf4.jpg'
image = tf.keras.preprocessing.image.load_img(image_path,target_size=[IMG_HEIGHT, IMG_WIDTH])
input_arr = tf.keras.preprocessing.image.img_to_array(image)
input_arr = np.array([input_arr])  # Convert single image to a batch.
predictions = probability_model(input_arr)
# print(tf.strings.as_string (predictions[0]))

sys.stdout.flush()
send=[]
for anmil in content:
    A=[]
    A.append(anmil)
    x = content.index(anmil)
    t=predictions[0].numpy()
    
    A.append(t[x])
    send.append(A)
print(send)