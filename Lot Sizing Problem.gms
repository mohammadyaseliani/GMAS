SETs
i /1*5/
j /1*3/
nonnegative variable q(i,j);
nonnegative variable x(i,j);
binary variable y(i,j);
parameter d(i,j);
table d(i,j)
         1   2   3
1        5   20  10
2        50  6   1
3        10  15  7
4        20  20  20
5        30  5   25;

parameter s(i)
/1 50
2 300
3 200
4 600
5 500/;

parameter h(i)
/1 2
2 1
3 2.5
4 0.5
5 1/;

parameter a(i)
/1 2
2 3
3 2
4 1
5 2/;

variable z;

equations
obj
cons1
cons2
cons3
;

obj.. z=e=sum((i,j),h(i)*q(i,j))+sum((i,j),s(i)*y(i,j));
cons1(i,j).. q(i,j)+x(i,j)-q(i,j)=e=d(i,j);
cons2(j).. sum(i,a(i)*x(i,j))=l=350;
cons3(i,j).. x(i,j)=l=5000*y(i,j);


model Untitled_74 /all/

solve Untitled_74 using mip maximizing z;


display x.l,z.l;
