set j/1*4/;
set t/1*8/;
parameter d(t)
/1       55
2        46
3        59
4        23
5        60
6        38
7        20
8        30/;
parameter w(j)
/1       135
2        140
3        190
4        188/;
table a(j,t)
         1       2       3       4       5       6       7       8
1        1       1       1       0       0       0       0       0
2        0       0       1       1       1       0       0       0
3        0       0       0       0       1       1       1       0
4        0       0       0       0       0       0       1       1;
variable z;
positive variable y(j);
equation
obj
eq1;
obj..z=e=sum(j,w(j)*y(j));
eq1(t)..sum(j,a(j,t)*y(j))=g=d(t);

model rostering /all/;
solve rostering using mip minimizing z;
display y.l,z.l;
