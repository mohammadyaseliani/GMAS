sets i "nodes" /1*4/ ;
alias (i,j);
Set k "vehicles" /1*6/;
set p "Product types" /1*3/;
set m "Number of compartments" /1*10/;
parameter Q /20/;
Table c(i,j)
         1  2   3   4
1        0  85  30  57
2        15 0   45  59
3        14 75  0   47
4        19 110 99  0;
table d(i,p)
         1       2       3
2        15      13      20
3        2       20      19
4        5       4       7;

binary variable x(i,j,k);
binary variable u(i,p,k);
binary variable y(p,k,m);
Positive variable h(i);
variable z;
Equations obj , eq1, eq2, eq3,eq5, eq4, eq6, eq7, eq8;
obj .. z =e= sum((i,j,k)$(ord(i)<>ord(j)),c(i,j)*x(i,j,k));
eq1(i,p)$(ord(i)>1)..sum(k,u(i,p,k))=e=1;
eq2(j,p,k)$(ord(j)>1)..u(j,p,k)=l=sum(i$(ord(i)<>ord(j)),x(i,j,k));
eq3(i,k)$(ord(i)>1)..sum(j$(ord(i)<>ord(j)),x(i,j,k))=l=1;
eq4(i,k)$(ord(i)>1)..sum(j$(ord(i)<>ord(j)),x(i,j,k))=e=sum(j$(ord(i)<>ord(j)),x(j,i,k));
eq5(i,j,k)$(ord(i)<>ord(j) and ord(i)<>1 and ord(j)<>1)..h(i)-h(j)+(card(i)-1)*x(i,j,k) =l= card(i)-2;
eq6(k,p).. sum(i$(ord(i)>1),d(i,p)*u(i,p,k))=l=Q;
eq7(k,m)..sum(p,y(p,k,m))=e=1;
eq8(p,k)..sum(i$(ord(i)>1),u(i,p,k))=l=card(i)*sum(m,y(p,k,m));
Model Untitled_96 /all/ ;
Solve Untitled_96 using MIP minimizing z ;

display z.l,x.l,u.l,y.l;
