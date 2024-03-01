sets i/1*4/ , j/1*6/;
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
binary VARIABLE x(j);
variable z;
equations
obj
eq1;
obj..z=e=sum(j,c(j)*x(j));
eq1(i)..sum(j,a(i,j)*x(j))=g=1;

model cover /all/;
cover.optCr = 0;
solve cover using mip minimuzing z;
display x.l, z.l, eq1.m;