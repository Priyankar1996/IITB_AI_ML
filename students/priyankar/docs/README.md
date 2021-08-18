# TRANSPOSE CONVOLUTION (DECONVOLUTION):

## STEPS INVOLVED:
        1. Start off by creating an intermediate grid having the original input's cells
            spaced apart with a step-size set to the stride.
        
        2. Extend the edges of the intermediate image with additional cells with value '0'.
           We add a maximum amount of these so that the kernels in the top-left covers one
           of the top cells.

        3. If padding is set to a value, we remove that many number of intermediate rings
           from around the grid.(Is it always 1 in this case?)

        3. Finally the kernel is moved across the intermediate grid in step sizes of 1 and
           will always be 1. The stride in this case determines the span of the original cells
           in the grid.

## FINDING THE OUTPUT SIZE
$$outputSize = (inputSize - 1)*stride - 2*padding + (kernelSize - 1) + 1$$

## EXAMPLES        
### TRANSPOSE CONVOLUTION WITH STRIDE = 2, NO PADDING
![alt text](https://1.bp.blogspot.com/-gPveB7oT1Vg/XkrIy4QHSrI/AAAAAAAAArI/0PfOm20NFaMWJmgrrgxXLLXiL45jwoKngCEwYBhgL/s1600/appendix_C_eg_5.png)

### TRANSPOSE CONVOLUTION WITH STRIDE = 1, NO PADDING
![alt text](https://1.bp.blogspot.com/-Nt-tQOs7O-I/XkrI1VHkwPI/AAAAAAAAArQ/S-_cWK9vY94vlLaNVRTZ7jInYvaUxypYACEwYBhgL/s1600/appendix_C_eg_6.png)

### TRANSPOSE CONVOLUTION WITH STRIDE = 1, PADDING = 1
![alt text](https://1.bp.blogspot.com/-bVWdYb2CLX4/XkrI1i27G4I/AAAAAAAAArQ/mlykCrbvqQoCaXPK-Oh4tqGi04RpukqbACEwYBhgL/s1600/appendix_C_eg_7.png)

## REFERENCES
http://makeyourownneuralnetwork.blogspot.com/2020/02/calculating-output-size-of-convolutions.html