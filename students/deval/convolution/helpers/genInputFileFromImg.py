import numpy as np
import pylab as pl
from PIL import Image as im
import csv

def genInputFileFromImg(data_type,row_major,image_file_name,csv_file_name):
  #Load image variable
  img = Image.open(image_file_name)
  #Convert to numpy array
  imageToMatrice = np.asarray(img)
  original_stdout = sys.stdout
  #open csv file in write mode
  with open(csv_file_name, 'w') as f:
    sys.stdout = f
    #print console output to file
    print(data_type)
    print(row_major)
    print(imageToMatrice.ndim)
    #Uncomment for space separated data
    #print(imageToMatrice.shape[0],imageToMatrice.shape[1],imageToMatrice.shape[2])
    #Uncomment for comma separated data
    print(imageToMatrice.shape[0],",",imageToMatrice.shape[1],",",imageToMatrice.shape[2],sep='')
    for i in range(imageToMatrice.shape[0]):
      for j in range(imageToMatrice.shape[1]):
        #Uncomment for space separated data
        #print(imageToMatrice[i][j][0],imageToMatrice[i][j][1],imageToMatrice[i][j][2])
        #Uncomment for comma separated data
        print(imageToMatrice[i][j][0],",",imageToMatrice[i][j][1],",",imageToMatrice[i][j][2],sep='')
    sys.stdout = original_stdout

if __name__ == '__main__':
  genInputFileFromImg(10,1,"E:\iitb\ra_project_mpd\ai_accelerator_new\IITB_AI_ML-master\IITB_AI_ML-master\students\deval\convolution\helpers\cat_original.jpg","E:\iitb\ra_project_mpd\ai_accelerator_new\IITB_AI_ML-master\IITB_AI_ML-master\students\deval\convolution\bin\a.csv")