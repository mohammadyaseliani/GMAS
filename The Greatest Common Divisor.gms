sets i /1, 2/;
Parameters a(i) /1 1038, 2 702/;
integer variables xp(i), xn(i);
variable z;
Equations obj, eq;
obj .. z =e= sum(i, a(i)*(xp(i)-xn(i))) ;
eq .. sum(i, a(i)*(xp(i)-xn(i))) =g= 1 ;
Model gcd /all/ ;
Solve gcd using mip minimizing z ;