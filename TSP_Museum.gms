sets i / 1*15/ ;
alias (i,j);
parameters l(i,j);
Table adjacent(i,j)
         1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
1        0 1 1 0 0 1 0 0 0 0  0  0  0  0  0
2        1 0 0 1 0 0 0 0 0 0  0  0  0  0  0
3        1 0 0 0 0 0 0 1 0 0  0  0  0  0  0
4        0 1 0 0 1 0 0 0 1 0  0  0  0  0  0
5        0 0 0 1 0 1 0 0 1 1  0  0  0  0  0
6        1 0 0 0 1 0 1 0 0 0  0  0  0  0  0
7        0 0 0 0 0 1 0 1 0 0  1  0  0  0  0
8        0 0 1 0 0 0 1 0 0 0  0  1  0  0  0
9        0 0 0 1 1 0 0 0 0 0  0  0  1  0  0
10       0 0 0 0 1 0 0 0 0 0  0  0  0  1  0
11       0 0 0 0 0 0 1 0 0 1  0  0  0  0  1
12       0 0 0 0 0 0 0 1 0 0  0  0  0  0  1
13       0 0 0 0 0 0 0 0 1 0  0  0  0  1  0
14       0 0 0 0 0 0 0 0 0 1  0  0  1  0  1
15       0 0 0 0 0 0 0 0 0 0  1  1  0  1  0;
Variables z ; Positive variables u(i); Binary variables x(i,j);
Equations obj , eq1(i), eq2(j), subtour(i,j) ;
obj .. z =e= 0;
eq1(i) .. sum(j$(ord(j) <> ord(i) and adjacent(i,j)=1), x(i,j)) =e= 1 ;
eq2(j) .. sum(i$(ord(j) <> ord(i) and adjacent(i,j)=1), x(i,j)) =e= 1 ;
subtour(i,j)$(ord(i)<>ord(j) and ord(i)<>1 and ord(j)<>1 and adjacent(i,j)=1).. u(i)-u(j)+(card(i)-1)*x(i,j) =l= card(i)-2;
Model TSP /all/ ; option optcr=0; Solve TSP using MIP minimizing z ;