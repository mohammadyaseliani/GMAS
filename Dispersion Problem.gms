sets i /1*7/;
alias(i,ip);
scalar f /3/, M /1000/;
table d(i,ip)
         1 2  3  4  5  6  7
1        0 20 18 6  18 3  21
2        0 0  10 18 13 7  25
3        0 0  0  13 17 12 15
4        0 0  0  0  15 24 9
5        0 0  0  0  0  16 5
6        0 0  0  0  0  0  17
7        0 0  0  0  0  0  0;
binary variables x(i); positive variable z; variable obj;
equations allocation, distance, calc_obj;
allocation..sum(i,x(i))=e=f;
distance(i,ip)$(ord(i)<ord(ip))..z=l=d(i,ip)+M*(1-x(i))+M*(1-x(ip));
calc_obj.. obj =e= z;
model dispersion /all/;
solve dispersion using mip maximizing obj;
