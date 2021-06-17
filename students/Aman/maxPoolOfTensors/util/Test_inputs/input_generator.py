import random
import sys

print(random.randint(0,1))
# Is sequence random?

data_type = random.randint(0,11)
if (data_type == 8):
    data_type = data_type - random.randint(1,8)
if (data_type == 9):
    data_type = data_type + random.randint(1,2)
print(data_type)

print(random.randint(0,1))
# Row major form

num_dims = random.randint(1,6)
print(num_dims)
dims = []
for i in range(num_dims):
    dims.append(random.randint(4,random.randint(4,60/num_dims)))
    print(dims[i])

print(random.randint(1,min(dims)))
# Pool_size

print(random.randint(1,min(dims)))
# Stride

print(random.randint(0,1))
# Mode

a = []
for i in range(num_dims):
    if (random.randint(0,1)):
        a.append(i)

num_dims_to_pool = len(a)
if (len(a)>0):
    print(num_dims_to_pool)
    for element in a:
        print(element)
else:
    print(1)
    print(0)