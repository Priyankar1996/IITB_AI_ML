# **Implementation of convolution**

## **Testing Status**
3/8/21 No Tests yet

## **2D convolution**

### **Inputs**
input __SRC__ dim = H * W * C  
kernal __K__ dim = KH * KW * C //* KC  
stride __S__ = [SH, SW]  
padding __P__:
* PHU, PHD, PWL, PWR  
* PH = PHU + PHD  
* PW = PWL + PWR  

output __DST__ dim = ( GIF[(H + PH - KH)/SH] + 1) * ( GIF[(W + PW - KW)/SH] + 1) //* KC  
refer [this](https://d2l.ai/chapter_convolutional-neural-networks/padding-and-strides.html) for detailed calculations

### **Algorithm #0**
Assuming ROW MAJOR and 0-indexed memory: 
1. __Start__
2. __(i, j)__ <- (0, 0).
3. Retrieve the submatrix __S(i, j)__ = __SRC__[i : i+KH-1][j : j+KW-1][0 : C-1].  
/*   
    4. For each filter in __K__ (c = 0, 1, ..., KC-1), define __Kc__ = __K__[0 : KH-1][0 : KW-1][0 : C-1][c]. Obtain dot products <__Kc__, __Sc__> and store in the corresponding channel of the output.  
*/
4. Obtain dot product <__S(i, j)__, __K__> and store
5. (i, j) <- (i, j+SW)  
if j+SW>=W, (i, j) <- (i+SH, 0)  
if i+SH<H, goto step 2 else step 5.
6. __Done__

Change steps 4, 5 for COLUMN MAJOR as any update to i is instead made to j and vice versa.

### **Implementation #0**


### __Next steps__
1. Remove dependancy on assumption 2a: if kernel is too big, solve using different parts of the kernel.
2. Add padding support
1. Reuse overlap btw current and next src windows (slide in a zig-zag fashion)
2. Write to mempool only after accumulating as many output values as possible
2. Utilise any BLASE libraries?
