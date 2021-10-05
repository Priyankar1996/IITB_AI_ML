import numpy as np
import pylab as pl
from PIL import Image as im
import csv

matrix = np.array(list(csv.reader(open('r.csv', "r"), delimiter=","))).astype("float32")  #read csv
reshaped_matrix = np.reshape(matrix,(85,128))  #resize Image object
reshaped_matrix = np.round(reshaped_matrix)
reshaped_matrix = reshaped_matrix.astype("uint8")
print(reshaped_matrix)
data = im.fromarray(reshaped_matrix)
data.save('gfg_dummy_pic.bmp')