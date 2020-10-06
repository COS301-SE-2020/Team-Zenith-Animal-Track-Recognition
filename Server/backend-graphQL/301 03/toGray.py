import cv2

import os,glob

from os import listdir,makedirs

from os.path import isfile,join
path = 'C:/Users/Henco/Documents/GIT/Team-Zenith-Animal-Track-Recognition/Server/backend-graphQL/301 03/Training Data 350/train/Taurotragus oryx' # Source Folder
dstpath = 'C:/Users/Henco/Documents/GIT/Team-Zenith-Animal-Track-Recognition/Server/backend-graphQL/301 03/Training Data 350 gray/train/Taurotragus oryx' # Destination Folder
try:
    makedirs(dstpath)
except:
    print ("Directory already exist, images will be written in same folder")
# Folder won't used
files = [f for f in listdir(path) if isfile(join(path,f))] 
for image in files:
    try:
        img = cv2.imread(os.path.join(path,image))
        gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
        dstPath = join(dstpath,image)
        cv2.imwrite(dstPath,gray)
    except:
        print ("{} is not converted".format(image))
for fil in glob.glob("*.jpg"):
    try:
        image = cv2.imread(fil) 
        gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) # convert to greyscale
        cv2.imwrite(os.path.join(dstpath,fil),gray_image)
    except:
        print('{} is not converted')