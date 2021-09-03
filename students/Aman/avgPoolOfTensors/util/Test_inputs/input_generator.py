import random
import sys

print(random.randint(0,1))
# Is sequence random?

data_type = random.randint(11,11)
if (data_type == 8):
    data_type = data_type - random.randint(1,8)
if (data_type == 9):
    data_type = data_type + random.randint(1,2)
print(data_type)

print(random.randint(0,1))
# Row major form

num_dims = random.randint(1,8)
print(num_dims)
dims = []
max_range = [200000,632,92,35,20,13,10,8]
for i in range(num_dims):
    dims.append(random.randint(2,max_range[num_dims-1]))
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