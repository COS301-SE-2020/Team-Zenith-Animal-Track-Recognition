print("redistabuting files")

dataset="testA"
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

for i in fodervalidation:
    wdv = os.path.join(wdvalidation,i)
    wdt = os.path.join(wdtrain,i)
    temp = os.listdir(wdv)

    for j in temp:
        pfrom =os.path.join(wdv,j)
        pto=os.path.join(wdt,j)
        os.replace(pfrom,pto)

# print("step1\n\n\n\n")


fodertrain = os.listdir(wdtrain)
for i in fodertrain:
    wdv = os.path.join(wdvalidation,i)
    wdt = os.path.join(wdtrain,i)
    temp = os.listdir(wdt)

    for j in temp:
        if(random.random()<split):
            pfrom =os.path.join(wdt,j)
            pto=os.path.join(wdv,j)
            os.replace(pfrom,pto)
# print(fodertrain)
# for i in fodervalidation:
#     wd = cwd + dataset+"/validation/"+i
#     temp = os.listdir(wd)
#     for j in temp:
#         if(random.random()<split):
#             os.replace(cwd + dataset+"test/"+i+"/"+j,cwd + dataset+"validation/"+i+"/"+j)
        


print("redistabuting complet")





