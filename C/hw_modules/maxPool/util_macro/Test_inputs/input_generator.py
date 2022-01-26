import random
import sys

# Is sequence random?
print(random.randint(0,1))

# Pool_size
print(random.randint(1,min(dims)))

# Stride
print(random.randint(1,min(dims)))

num_dims = 3
dims = []
for i in range(num_dims):
    dims.append(random.randint(4,200))
    print(dims[i])
