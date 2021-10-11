import numpy as np
from PIL import Image as im
import csv

def genImgFromOutputFile(csv_file_name):
  #load file to numpy array
  matrix = np.loadtxt(csv_file_name,skiprows=4,delimiter=',')
  #reshape the matrix
  reshaped_matrix = np.reshape(matrix,(matrix.shape[0],matrix.shape[1]))  #resize Image object
  #round off float numbers
  reshaped_matrix = np.round(reshaped_matrix)
  #convert pixel values to 8 bit color
  reshaped_matrix = reshaped_matrix.astype("uint8")
  #save image in png format
  data = im.fromarray(reshaped_matrix)
  data.save("../../students/deval/convolution/bin/result.png")

genImgFromOutputFile("../../students/deval/convolution/bin/r.csv")