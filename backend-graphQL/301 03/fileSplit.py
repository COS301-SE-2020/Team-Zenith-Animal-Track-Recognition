print("redistabuting files")

dataset="Training Data 350"
import random

import os 
import shutil
split =0.1 #size of test DO NOT SET TO ZERO

cwd = os.getcwd()


wdvalidation=os.path.join( os.path.join(  cwd , dataset),"validation")
fodervalidation = os.listdir(wdvalidation)
wdtrain=os.path.join( os.path.join(  cwd , dataset),"train")

# print(fodervalidation)

for i in fodervalidation:
    wdv = os.path.join(wdvalidation,i)
    wdt = os.path.join(wdtrain,i)
    temp = os.listdir(wdv)

    for j in temp:
        pfrom =os.path.join(wdv,j)
        pto=os.path.join(wdt,j)
        os.replace(pfrom,pto)

print("step1\n\n\n\n")


fodertrain = os.listdir(cwd + dataset+"/train")
print(fodertrain)
for i in fodervalidation:
    wd = cwd + dataset+"/validation/"+i
    temp = os.listdir(wd)
    for j in temp:
        if(random.random()<split):
            os.replace(cwd + dataset+"test/"+i+"/"+j,cwd + dataset+"validation/"+i+"/"+j)
        


print("redistabuting complet")





