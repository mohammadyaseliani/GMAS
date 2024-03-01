sets i/1*6/;
set j/1*5/;
table c(i,j)
         1       2       3       4       5
1        6       2       1       3       5
2        4       10      2       6       1
3        3       2       4       1       3
4        2       0       4       1       4
5        1       8       6       2       5
6        3       2       4       8       1;
parameter f(j)
/1       2
2        4
3        5
4        3
5        3/;
variable z;
binary variable x(i,j);
binary variable y(j);
equations
eq1
eq2
obj
;
obj..z=e=sum((i,j),c(i,j)*x(i,j))-sum(j,f(j)*y(j));
eq1(i)..sum(j,x(i,j))=e=1;
eq2(i,j)..x(i,j)-y(j)=l=0;

model ufl /all/;
solve ufl using rmip maximizing z;
display x.l,y.l,z.l,eq1.m;
