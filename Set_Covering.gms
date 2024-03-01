sets i/1*4/;
sets j/1*6/;
parameter a(i,j);
table a(i,j)
         1       2       3       4       5       6
1        1       0       1       0       0       1
2        0       1       0       1       1       0
3        1       1       1       0       0       0
4        0       0       1       0       1       0;
parameter c(j)
/1       6
2        7
3        11
4        5
5        8
6        8/;
nonnegative variable x(j);
variable z;

equations
obj
cons1
;

obj..z=e=sum(j,c(j)*x(j));
cons1(i).. sum(j, a(i,j)*x(j))=g=1;

model Untitled_96 /all/;
solve Untitled_96 using mip minimizing z

display x.l, z.l;