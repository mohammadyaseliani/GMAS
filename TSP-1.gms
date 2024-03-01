Sets i/w,y,b,r/;
alias(i,j);
parameters l(i,j);
Table l(i,j)
         w    y    b     r
w        0.0  10.0 17.0  15.0
y        20.0 0.0  19.0  18.0
b        50.0 44.0 0.0   25.0
r        45.0 40.0 20.0  0.0;
Variables z ;
Positive variables u(i);
Binary variables x(i,j);
Equations obj , eq1(i), eq2(j), subtour(i,j) ;
obj .. z =e= sum((i,j)$(ord(i)<>ord(j)), l(i,j)*x(i,j)) ;
eq1(i) .. sum(j$(ord(j) <> ord(i)), x(i,j)) =e= 1 ;
eq2(j) .. sum(i$(ord(j) <> ord(i)), x(i,j)) =e= 1 ;
subtour(i,j)$(ord(i)<>ord(j) and ord(i)<>1 and ord(j)<>1).. u(i)-u(j)+(card(i)-1)*x(i,j) =l= card(i)-2;
Model TSP /all/ ;
option optcr=0;
Solve TSP using MIP minimizing z ;
