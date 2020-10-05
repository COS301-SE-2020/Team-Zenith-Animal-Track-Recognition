import os 
cwd = os.getcwd()
dataset="TrainingData350gray"
wdvalidation=os.path.join( os.path.join(  cwd , dataset),"validation")
fodervalidation = os.listdir(wdvalidation)
with open('your_file.txt', 'w') as f:
    for item in fodervalidation:
        f.write("%s\n" % item)
print(fodervalidation)