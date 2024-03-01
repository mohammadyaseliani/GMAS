sets i /1*14/;
parameter r(i) /1 1,2 1, 3 1, 4 0, 5 1, 6 1, 7 1, 8 0, 9 1, 10 1, 11 0, 12 0, 13 0, 14 0/;
binary variables x(i), c(i);
variable z;
equations obj, calc_c1, calc_c2, red, green;
obj..z=e=sum(i$(ord(i)<card(i)),c(i));
calc_c1(i)$(ord(i)<card(i))..c(i)=g=x(i)-x(i+1);
calc_c2(i)$(ord(i)<card(i))..c(i)=g=x(i+1)-x(i);
red..sum(i,r(i)*x(i))=e=sum(i,r(i)*(1-x(i)));
green..sum(i,(1-r(i))*x(i))=e=sum(i,(1-r(i))*(1-x(i)));
model necklace /all/;
solve necklace using mip minimizing z;
display c.l,x.l;
