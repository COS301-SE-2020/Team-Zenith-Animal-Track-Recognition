dataset="Training"
import random

import os 
import shutil
split =0.1 #size of test DO NOT SET TO ZERO

cwd = os.getcwd()


wdvalidation=os.path.join( os.path.join(  cwd , dataset),"validation")
wdtrain=os.path.join( os.path.join(  cwd , dataset),"train")

# print(fodervalidation)

def create_dir(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)
create_dir(wdvalidation)
create_dir(wdtrain)

fodervalidation = os.listdir(wdvalidation)
for i in fodervalidation:
    create_dir(os.path.join(wdtrain,i))
    
fodertrain = os.listdir(wdtrain)
for i in fodertrain:
    create_dir(os.path.join(wdvalidation,i))