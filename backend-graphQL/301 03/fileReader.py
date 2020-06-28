import os
import numpy as np
import tensorflow as tf
import PIL



from PIL import Image
cwd = os.getcwd()

cwd = cwd[:-6]
list1 = os.listdir(cwd + "Training Data/")
out = "charizard"

arr = [[]]
out = out + str(arr) + "\n\n"
for i in list1:
    wd = cwd + "Training Data\\" + i
    out = out + wd + "\n\t"
    list2 = os.listdir(wd)
    CLASS_NAMES =np.array(list2)
    for j in list2:
        out = out+"\t" + j + "\t"
        filewd = wd +"\\"+ j
        image = Image.open(filewd,"r")
        out = out + "\t" + str(image.format )+ "\t"+ str(image.mode )+ "\t"+ str(image.size )+ "\t"
        out = out + "\n"
    out = out + "\n"


print(out)


# import glob
# print(glob.glob("../home/adam/*.txt"))
