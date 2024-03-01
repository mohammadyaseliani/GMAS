sets i "nodes" /1*10/ ;
alias (i,j);
Set k "vehicle types" /1,2/;
parameter c(k) "cost per minute" /1 60, 2 150/;
parameter f(k) "fixed cost" /1 10, 2 50/;
parameter m(k) "number of vehicles available" /1 5, 2 3/;
parameter q(i) /1 0, 2 4, 3 6, 4 5, 5 4, 6 7, 7 3, 8 5, 9 4, 10 4/;
parameter cap(k) /1 4, 2 17/;
Table t(i,j)
         1 2 3  4  5 6 7 8 9 10
1        0 2 4  5  4 6 2 4 4 7
2        2 0 2  3  4 6 4 6 7 9
3        4 2 0  5  7 9 7 8 8 11
4        5 3 5  0  4 7 7 9 9 10
5        4 4 7  4  0 2 3 6 6 6
6        6 6 9  7  2 0 4 6 6 4
7        2 4 7  7  3 4 0 3 3 4
8        4 6 8  9  6 6 3 0 1 4
9        4 7 8  9  6 6 3 1 0 3
10       7 9 11 10 6 4 4 4 3 0;

parameter num_used(k);
binary variable x(i,j,k);
positive variable y(i,j);
variable z;
Equations obj , eq1, eq2, eq3, eq4, eq5left, eq5right;
obj .. z =e= sum((k,j)$(ord(j)>1),f(k)*x('1',j,k))+sum((i,j,k)$(ord(i)<>ord(j)), t(i,j)*c(k)/60*x(i,j,k)) ;
eq1(j)$(ord(j)>1)..sum((i,k)$(ord(i)<>ord(j)), x(i,j,k))=e=1;
eq2(j,k)$(ord(j)>1)..sum(i$(ord(i)<>ord(j)), x(i,j,k))-sum(i$(ord(i)<>ord(j)), x(j,i,k))=e=0;
eq3(k)..sum(j$(ord(j)>1), x('1',j,k))=l=m(k);
eq4(j)$(ord(j)>1)..sum(i,y(i,j))-sum(i,y(j,i))=e=q(j);
eq5left(i,j)$(ord(i)<>ord(j)).. y(i,j)=g=q(j)*sum(k,x(i,j,k));
eq5right(i,j)$(ord(i)<>ord(j)).. y(i,j)=l=sum(k,(cap(k)-q(i))*x(i,j,k));
Model VRP /all/ ;
option optcr=0;
Solve VRP using MIP minimizing z ;
num_used(k)= sum(j$(ord(j)>1),x.l('1',j,k));
display num_used;