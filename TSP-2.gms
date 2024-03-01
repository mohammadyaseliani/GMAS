Sets i/A,B,C,D,E/;
alias(i,j);
parameters l(i,j);
Table l(i,j)
         A     B       C      D      E
A        0     2       10000  12     5
B        2     0       4      8      10000
C        10000 4       0      3      3
D        12    8       3      0      10
E        5     10000   3      10     0;
Positive variables u(i);
Binary variables x(i,j);
variable z;
Equations obj , eq1(i), eq2(j), subtour(i,j) ;
obj .. z =e= sum((i,j)$(ord(i)<>ord(j)), l(i,j)*x(i,j)) ;
eq1(i) .. sum(j$(ord(j) <> ord(i)), x(i,j)) =e= 1 ;
eq2(j) .. sum(i$(ord(j) <> ord(i)), x(i,j)) =e= 1 ;
subtour(i,j)$(ord(i)<>ord(j) and ord(i)<>1 and ord(j)<>1).. u(i)-u(j)+(card(i)-1)*x(i,j) =l= card(i)-2;
Model TSP /all/ ;
option optcr=0;
Solve TSP using MIP minimizing z ;
DISPLAY x.l, z.l;
