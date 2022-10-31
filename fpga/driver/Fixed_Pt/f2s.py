import sys

fptr = open(sys.argv[1],'r')

values = []
for line in fptr:
    if ('#' in line):
        continue
    val = line.strip().split(",")
    values.extend(val)

total = len(values)>>3
print((total>>16)&255)
print((total>>8)&255)
print(total&255)
for val in values:
    print(val)
