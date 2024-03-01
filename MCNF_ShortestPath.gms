SETs
i /1*5/
alias (i,j)
parameter b(i)
/1 1
2 0
3 0
4 0
5 -1/;

parameter c(i,j);
table c(i,j)
         1       2      3        4      5
1        0       2      2        3      1000
2        1000    0      1000     1000   5
3        1000    4      0        1000   3
4        1000    1000   1        0      0
5        1000    1000   1000     1000   0;

parameter u(i,j);
table u(i,j)
         1     2    3    4   5
1        0     1    1    1   0
2        0     0    0    0   1
3        0     1    0    0   1
4        0     0    1    0   1
5        0     0    0    0   0;
BINARY variable x(i,j);
variable z;

equations
obj
cons1
cons2
;

obj.. z=e=sum((i,j),c(i,j)*x(i,j));
cons1(i).. sum(j$(ord(j)<>ord(i)), x(i,j))-sum(j$(ord(j)<>ord(i)),x(j,i))=e=b(i);
cons2(i,j).. x(i,j)=l=u(i,j);

model Untitled_96 /all/

solve Untitled_96 using mip minimizing z;


display x.l,z.l;
