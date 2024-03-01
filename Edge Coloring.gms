sets i /A,B,C,D,E,F,G/,t/1*16/;
alias(i,ip,is,it);
scalar m /1000/;
table match(i,ip)
         A B C D E F G
A        0 0 0 1 1 1 1
B        0 0 0 1 1 1 1
C        0 0 0 1 1 1 1
D        0 0 0 0 0 1 1
E        0 0 0 0 0 1 1
F        0 0 0 0 0 0 0
G        0 0 0 0 0 0 0;
binary variable x(t,i,ip),used(t); variable z;
equations obj, assign, conflict,check_used, continuity;
obj..z=e=sum(t,used(t));
assign(i,ip)$(ord(i)<ord(ip) and match(i,ip)=1)..sum(t,x(t,i,ip))=e=1;
conflict(i,ip,is,it,t)$(
ord(i)<ord(ip) and ord(is)<ord(it) and
((ord(i)=ord(is) and ord(ip)<>ord(it)) or (ord(ip)=ord(it) and ord(i)<>ord(is)) or ord(ip)=ord(is) or ord(i)=ord(it))
)..x(t,i,ip)+x(t,is,it)=l=1;
check_used(t)..m*used(t)=g=sum((i,ip)$(ord(i)<ord(ip)),x(t,i,ip));
continuity(t)$(ord(t)<card(t))..used(t)=g=used(t+1);
model tournament /all/;
solve tournament minimizing z using mip;
