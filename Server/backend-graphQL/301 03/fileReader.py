import numpy as np
import os
import PIL
import sys
import tensorflow as tf

from PIL import Image

AUTOTUNE = tf.data.experimental.AUTOTUNE
stderr_fileno = sys.stderr
cwd = os.getcwd()

cwd = cwd[:-6]
list1 = os.listdir(cwd + "Training Data/")
out = "charizard"

arr = [[]]
out = out + str(arr) + "\n\n"
CLASS_NAMES = np.array(list1)
try:
    ip = ip + 100
except:
    stderr_fileno.write(str(CLASS_NAMES))


for i in list1:
    wd = cwd + "Training Data\\" + i
    out = out + wd + "\n\t"
    list2 = []
    list2.append(i)
    temp = os.listdir(wd)

    for j in temp:
        list2.append(j)
    #animals = list(i.glob('*.jpg'))

    for j in list2:
        if j != i:
            temp_arr = [i, j]
            out = out+"\t" + str(temp_arr) + "\t"
            filewd = wd + "\\" + j
            image = Image.open(filewd, "r")
            out = out + "\t" + str(image.format) + "\t" + \
                str(image.mode) + "\t" + str(image.size) + "\t"
            out = out + "\n"
    out = out + "\n"


print(out)


# import glob
# print(glob.glob("../home/adam/*.txt"))


