SETs
i /1*4/
alias (i,j)
parameter b(i)
/1 0
2 0
3 0
4 0/;

parameter c(i,j);
table c(i,j)
         1      2           3        4
1        0      0           0        0
2        0      0           0        0
3        0      0           0        0
4        -1     0           0        0;

parameter u(i,j);
table u(i,j)
         1      2    3    4
1        0      1    4    0
2        0      0    2    3
3        0      0    0    2
4        10000  0    0    0;
nonnegative variable x(i,j);
variable z;

equations
obj
cons1
cons2
;

obj.. z=e=sum((i,j),c(i,j)*x(i,j));
cons1(i).. sum(j$(ord(i)<>ord(j)), x(i,j))-sum(j$(ord(i)<>ord(j)),x(j,i))=e=b(i);
cons2(i,j).. x(i,j)=l=u(i,j);

model Untitled_98 /all/

solve Untitled_98 using lp minimizing z;


display x.l,z.l;
