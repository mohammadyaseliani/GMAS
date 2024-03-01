set i /1*4/;
alias (i,j);
positive variable x(i,j);
variable z;
table u(i,j)
         1       2       3       4
1        0       1       4       0
2        0       0       2       3
3        0       0       0       2
4        0       0       0       0;
equations
obj
eq1
eq2
;
obj..z=e=sum(j$(ord(j)>1),x("1",j));
eq1(i)$(ord(i)>1 and ord(i)<4).. sum(j,x(i,j))-sum(j,x(j,i))=e=0;
eq2(i,j)..x(i,j)=l=u(i,j);
model Untitled_96 /all/;
Solve Untitled_96 using lp maximizing z ;
display x.l,z.l;




