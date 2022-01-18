import random
import sys

# Is sequence random?
print(random.randint(0,1))

# Row major form
print(random.randint(0,1))

num_dims = 3
print(num_dims)
dims = []
for i in range(num_dims):
    dims.append(random.randint(4,200))
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