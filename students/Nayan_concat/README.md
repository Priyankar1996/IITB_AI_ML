# Implementation of concat tensors .

Tested for 2 dimension large tensors ( > 1024 words)  
Tested for 3 dimension small tensors ( < 1024 words)  
Tested for 4 dimension small tensors ( < 1024 words)  


## Algorithm
dimensions: d0 d1 d2 ..... dx ...... dn-1

1.  start with 0 index 
2. find the unequal dimension => dx
3. switch tensor
4. find start and end indices for copy
5. request elements required to copy
    1. If > 1024 request 1024 at a time copy.
6. copy all the values till dx starting from d0/dn-1 depending column/row major from both tensor to result 
7. incement result_start goto 3

we copy tensor from index_start : index_end 

### index_start calc:-
**row major**:-</br>
increment [d0:dx] </br>
**column major**:- </br>
increment [dx:dn-1]</br>

### index_end calc:- 
row major:-</br>
index_start[0:dx] max(dx+1) ...... max(dn-1)</br>
column major:-</br>
max(d0) max (d1) .... index_start[dx:dn-1] </br>

IS == index_start</br>
IE == index_end</br>
RS == result_start</br>
RE == result_end</br>

#### Example  1
row major</br>
A dim B dim  result dim   </br>
3 4   3 5 -> 3 9</br>
0 1</br>

dx = 1</br>

IS IE -> RS RE</br>
00 03 -> 00 03</br>
00 04 -> 04 08</br>
10 13 -> 10 13</br>
10 14 -> 14 18</br>
20 23 -> 20 23</br>
20 24 -> 24 28</br>

#### Example 2
row major</br>
3 4   5 4 -> 84</br>
1 0</br>

00 23 -> 00 23 </br>
00 43 -> 30 73 </br>

#### Example 3
row major</br>
2 3 5 6   2 4 5 6 -> 2 7 5 6</br>
0 1 0 0</br>

0000 0245 -> 0000 0245 </br>
0000 0345 -> 0300 0645 </br>
1000 0245 -> 1000 1245</br>
1000 1345 -> 1300 1645</br>

#### Example 4
column major</br>
2 3 5 6   2 4 5 6 -> 2 7 5 6</br>
0 1 0 0</br>

0000 1200 -> 0000 1200</br>
0000 1300 -> 0300 1600</br>
0010 1210 -> 0010 1210</br>
0010 1310 -> 0310 1610</br>
0020 1220 -> 0020 1220</br>
0020 1320 -> 0320 1620</br>
...</br>
