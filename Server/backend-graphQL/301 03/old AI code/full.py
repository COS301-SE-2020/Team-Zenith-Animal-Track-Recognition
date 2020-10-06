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

redistabut=True
redistabut=not(redistabut)# comint out to matane files in posison
if(redistabut):
    import fileSplit


today = datetime.datetime.now()
date_time = today.strftime("%Y%m%d%H%M%S")






te = open('traningLog.txt','a')  # File where you need to keep the logs
te.write("\n\nstarted at "+date_time+"\n")

class Unbuffered:
    def __init__(self, stream):
        self.txt =""
        self.stream = stream
    def write(self, data):
        self.stream.write(data)
        self.stream.flush()
        self.txt =self.txt +data
        if self.txt[-1]=="\n":
            if ("Epoch"in self.txt):
                te.write(self.txt)
            if ("val_accuracy"in self.txt):
                te.write(self.txt)
            self.txt=""
        # te.write(data)    # Write the data of stdout here to a text file as well
    def flush(self):
        te.flush()
        pass
sys.stdout=Unbuffered(sys.stdout)
cwd = os.getcwd()

PATH = os.path.join(cwd, 'TrainingData350gray')
print(PATH)
train_dir = os.path.join(PATH, 'train')
validation_dir = os.path.join(PATH, 'validation')

total_train=0
total_val=0

for i in os.listdir(train_dir):
    temp=os.path.join(train_dir,i)
    total_train += len( os.listdir(temp))
for i in os.listdir(train_dir):
    temp=os.path.join(validation_dir,i)
    total_val += len( os.listdir(temp))
traningOnGoing =True


print("Total training images:", total_train)
print("Total validation images:", total_val)
MLlimit=30
MLstep=0
Tgroth=32
Tepochs=3
Tbatch_size = 32
TIMG_HEIGHT = 350
TIMG_WIDTH = 350
def plotImages(images_arr):
        fig, axes = plt.subplots(1, 5, figsize=(20, 20))
        axes = axes.flatten()
        for img, ax in zip(images_arr, axes):
            ax.imshow(img)
            ax.axis('off')
        plt.tight_layout()
        plt.show()
def trane(groth=32,epochs=10,batch_size = 32,IMG_HEIGHT = 350,IMG_WIDTH = 350):
    tryningAcaracy=0.0
    train_image_generator = ImageDataGenerator(rescale=1./255,
                                            horizontal_flip=True)
    validation_image_generator = ImageDataGenerator(
        rescale=1./255)  # Generator for our validation data
    train_data_gen = train_image_generator.flow_from_directory(batch_size=batch_size,
                                                            directory=train_dir,
                                                            shuffle=True,
                                                            target_size=(
                                                                IMG_HEIGHT, IMG_WIDTH),
                                                            class_mode='categorical')
    val_data_gen = validation_image_generator.flow_from_directory(batch_size=batch_size,
                                                                directory=validation_dir,
                                                                target_size=(
                                                                    IMG_HEIGHT, IMG_WIDTH),
                                                                class_mode='categorical')
    # sample_training_images, _ = next(train_data_gen)
    # sample_training_images, _ = next(train_data_gen
    # print(sample_training_images[0].shape)
    # plotImages(sample_training_images[:5])
    model = Sequential([
        Conv2D(32+groth, 3, padding='same', activation='relu',
            input_shape=(IMG_HEIGHT, IMG_WIDTH, 3)),
        MaxPooling2D(),
        Conv2D(64+groth, 3, padding='same', activation='relu'),
        MaxPooling2D(),
        Conv2D(128+groth, 3, padding='same', activation='relu'),
        MaxPooling2D(),
        Flatten(),
        Dense(512, activation='relu'),
        Dense(len( os.listdir(train_dir)))
    ])
    model.compile(optimizer='adam',
                loss=tf.keras.losses.BinaryCrossentropy(from_logits=True),
                metrics=['accuracy'])

    model.summary()

    history = model.fit(
        train_data_gen,
        steps_per_epoch=total_train // batch_size,
        epochs=epochs,
        validation_data=val_data_gen,
        validation_steps=total_val // batch_size
    )

    acc = history.history['accuracy']
    val_acc = history.history['val_accuracy']

    loss = history.history['loss']
    val_loss = history.history['val_loss']

    epochs_range = range(epochs)

    plt.figure(figsize=(8, 8))
    plt.subplot(1, 2, 1)
    plt.plot(epochs_range, acc, label='Training Accuracy')
    plt.plot(epochs_range, val_acc, label='Validation Accuracy')
    plt.legend(loc='lower right')
    plt.title('Training and Validation Accuracy')

    plt.subplot(1, 2, 2)
    plt.plot(epochs_range, loss, label='Training Loss')
    plt.plot(epochs_range, val_loss, label='Validation Loss')
    plt.legend(loc='upper right')
    plt.title('Training and Validation Loss')

    # plt.show()

    sentence="A"+str(val_acc[-1])+"E"+str(epochs)+"G"+str(groth)+"GS"
    sentence=sentence.replace("/", "")
    sentence='evoModel/'+date_time+"/"+sentence+"/"
    sentence=sentence.replace(" ", "")
    sentence=sentence.replace(":", "")
    model.save("M"+sentence)
    probability_model = tf.keras.Sequential([model, 
                                            tf.keras.layers.Softmax()])
    probability_model.save("P"+sentence) 
    if (tryningAcaracy<val_acc[-1]):
        tryningAcaracy=val_acc[-1]
        traningOnGoing=True
        return True
    else:
        return False

while traningOnGoing:
    traningOnGoing=False
    inproved=trane(groth=Tgroth+1,epochs=Tepochs,batch_size = Tbatch_size,IMG_HEIGHT = TIMG_HEIGHT,IMG_WIDTH = TIMG_WIDTH)
    if (inproved):
        Tgroth=Tgroth+1
    else:
        inproved=trane(groth=Tgroth-1,epochs=Tepochs,batch_size = Tbatch_size,IMG_HEIGHT = TIMG_HEIGHT,IMG_WIDTH = TIMG_WIDTH)
        if (inproved):
            Tgroth=Tgroth-1
    MLstep=MLstep+1
    if (MLlimit<=MLstep):
        traningOnGoing=False
        print("traning termanated")
else:
    print("traning concloded")





