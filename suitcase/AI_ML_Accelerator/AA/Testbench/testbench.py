import sys
import os
import random

ri = int(input())
rk = int(input())
ci = int(input())
ck = int(input())
chi = int(input())
cho = int(input())
scale_val = int(input())
shift_val = int(input())
pad = int(input());
pool = int(input());
relu = int(input());
CT = int(input());
concat = int(input());

f = open("octaveInFile.txt",'w')
f.write(str(ri)+"\n")
f.write(str(rk)+"\n")
f.write(str(ci)+"\n")
f.write(str(ck)+"\n")
f.write(str(chi)+"\n")
f.write(str(cho)+"\n")
f.write(str(scale_val)+"\n")
f.write(str(shift_val)+"\n")
f.write(str(pad)+"\n")
f.write(str(pool)+"\n")
f.write(str(relu)+"\n")
f.write(str(CT)+"\n")
f.write(str(concat)+"\n")

for i in range(ri*ci*chi+rk*ck*chi*cho):
    f.write(str(random.randint(-128,127))+"\n")

f.close()

if (concat != 0):
    tmp_val = "cct_file.txt "
else:
    tmp_val = ""
octaveCMD = "octave octaveFile < octaveInFile.txt > "+tmp_val+"octaveOutFile.txt "
print(octaveCMD)
os.system(octaveCMD)
