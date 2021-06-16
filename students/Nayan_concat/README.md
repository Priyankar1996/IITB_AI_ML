Implementation of concat tensors .

Tested for 2 dimension large tensors ( > 1024 words)
Tested for 3 dimension small tensors ( < 1024 words)
Tested for 4 dimension small tensors ( < 1024 words)


dimensions: d0 d1 d2 ..... dx ...... dn-1

both same major => 
1. start with 0 index 
2. find the unequal dimension => dx
3. switch tensor
4. find start and end indices for copy
5. request elements required to copy
    1. If > 1024 request 1024 at a time copy.
6. copy all the values till dx starting from d0/dn-1 depending column/row major from both tensor to result 
7. incement result_start goto 3

we copy tensor from index_start : index_end 

index_start calc:-
row major:-
increment [d0:dx] 
column major:- 
increment [dx:dn-1]

index_end calc:-
row major:-
index_start[0:dx] max(dx+1) ...... max(dn-1)
column major:-
max(d0) max (d1) .... index_start[dx:dn-1] 

IS == index_start
IE == index_end
RS == result_start
RE == result_end

Example  1
row major
A dim B dim  result dim   
3 4   3 5 -> 3 9
0 1

dx = 1

IS IE    RS RE
00 03 -> 00 03
00 04 -> 04 08
10 13 -> 10 13
10 14 -> 14 18
20 23 -> 20 23
20 24 -> 24 28

Example 2
row major
3 4   5 4 -> 84
1 0

00 23 -> 00 23 
00 43 -> 30 73 

Example 3
row major
2 3 5 6   2 4 5 6 -> 2 7 5 6
0 1 0 0

0000 0245 -> 0000 0245
0000 0345 -> 0300 0645 
1000 0245 -> 1000 1245
1000 1345 -> 1300 1645

Example 4
column major
2 3 5 6   2 4 5 6 -> 2 7 5 6
0 1 0 0

0000 1200 -> 0000 1200
0000 1300 -> 0300 1600
0010 1210 -> 0010 1210
0010 1310 -> 0310 1610
0020 1220 -> 0020 1220
0020 1320 -> 0320 1620
...
