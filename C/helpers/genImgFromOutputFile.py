import numpy as np
import pylab as pl
from PIL import Image as im
import csv

def genImgFromOutputFile(csv_file_name):
  with open(csv_file_name, 'r+') as fp:
    # read an store all lines into list
    lines = fp.readlines()
    # move file pointer to the beginning of a file
    fp.seek(0)
    # truncate the file
    fp.truncate()
    # start writing lines except the first line
    # lines[2:] from line 3 to last line
    fp.writelines(lines[4:])
  matrix = np.array(list(csv.reader(open(csv_file_name, "r"), delimiter=","))).astype("float32")  #read csv
  reshaped_matrix = np.reshape(matrix,(83,126))  #resize Image object
  reshaped_matrix = np.round(reshaped_matrix)
  reshaped_matrix = reshaped_matrix.astype("uint8")
  data = im.fromarray(reshaped_matrix)
  data.save('result.png')

genImgFromOutputFile("../../students/deval/convolution/bin/r.csv")
