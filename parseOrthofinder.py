import numpy as np 
import pandas as pd
import os
import datetime

x = datetime.datetime.now()
x = x.strftime("%b_%d")
x = "Results_"+str(x)
cwd = os.getcwd()
path = os.path.join(cwd,x)

num = 1
while os.path.isdir(path) == True:
	path = os.path.join(cwd,x+"_"+str(num))
	num = num+1
else: 
	os.mkdir(path)
	os.chdir(path)	

genecount = os.path.join(cwd,"Orthogroups.GeneCount.tsv")
df = pd.read_csv(genecount, sep='\t')
df=df.drop(['Total'],axis=1)
df.set_index('Orthogroup', inplace=True)
df = df.mask(df>1,1).reset_index()
df =df.set_index('Orthogroup')
df.loc[:,'Total'] = df.sum(axis=1)
df = df[df.Total > 0] #Removing all values less than one
df = df[df.Berghia_stephanieae >0] #Removing all orthogroups that don't contain Berghia. 

grp = os.path.join(cwd,"species_grouping.csv")
grp = pd.read_csv(grp)

for i in np.arange(len(grp.Header)): #Removes the .pep and .pep.fa suffix
	if str(grp.Header[i]).endswith(".pep"):
		grp.Header[i] = str(grp.Header[i])[:-4]
	elif str(grp.Header[i]).endswith(".pep.fa"):
		grp.Header[i] = str(grp.Header[i])[:-7]
df.columns = df.columns.str.replace(r".pep$",'')
##Organizing which orthogroups belong to which species
newdf = pd.DataFrame()
for column in df: 
	col = df[df[column]>0]
	print(str(column))
	col.to_csv(str(column)+"_orthogroups.txt", columns=[], header=False)

row = 0

distances = []
print(len(grp))
for i in np.arange(len(grp)):
	group = grp.iloc[i].Grouping
	if group == "Metazoa":
		distances.append(13)
	elif group == "Eumetazoa":
		distances.append(12)
	elif group == "Parahoxozoa":
		distances.append(11)
	elif group == "Bilateria":
		distances.append(10)
	elif group == "Nephrozoa":
		distances.append(9)
	elif group == "Protostomia":
		distances.append(8)
	elif group == "Spiralia":
		distances.append(7)
	elif group == "Platytrochozoa":
		distances.append(6)
	elif group == "Lophotrochozoa":
		distances.append(5)
	elif group == "Mollusca":
		distances.append(4)
	elif group == "Gastropoda":
		distances.append(3)
	elif group == "Heterobranchia":
		distances.append(2)
	elif group == "Nudibranchia":
		distances.append(1)
	else:
		distances.append(0)
		
print(distances)
print(len(distances))
grp['Distances']=distances
for index in df.iterrows():
	furthest = "1"
	for column in df:
		species = str(column)
		grouping = grp.loc[grp["Header"]==species]
		if grouping.Grouping =="Animalia":
			furthest = "Animalia"
			break
		elif grouping.Grouping =="Eumetazoa":
			furthest = "Eumetazoa"
			break
		

	row = row +1
	
newdf.to_csv("test.csv")
	
	
		
	

	
