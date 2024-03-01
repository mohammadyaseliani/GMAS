sets i/2,3,6,7,9,11/;
alias (i,j);
table c(i,j)
         2 3 6 7     9    11
2        0 1 4 6.5   4    8.1
3        0 0 5 7.4   5    11.8
6        0 0 0 2.4   3.9  7.9
7        0 0 0 0     1.5  5.5
9        0 0 0 0     0    4.1
11       0 0 0 0     0    0;
binary variable x(i,j); variable z;
equations obj, assign;
obj..z=e=sum((i,j)$(ord(i)<ord(j)),c(i,j)*x(i,j));
assign(i)..sum(j$(ord(j)>ord(i)),x(i,j))+sum(j$(ord(j)<ord(i)),x(j,i))=e=1;
model general_maching /all/;
solve general_maching min z using mip;
display z.l, x.l;