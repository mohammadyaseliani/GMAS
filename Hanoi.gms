sets
i /1,2,3/;
alias(i,j,k,ip,jp,kp);
parameter arc(i,j,k,ip,jp,kp),netflow(i,j,k);
arc(i,j,k,ip,jp,kp)=0;
loop((i,j,k,ip,jp,kp)$(
(ord(i)<>ord(ip) and ord(j)=ord(jp) and ord(k)=ord(kp))
or
(ord(j)<>ord(jp) and ord(i)=ord(ip) and ord(k)=ord(kp) and ord(i)<>ord(j) and ord(i)<>ord(jp))
or
(ord(k)<>ord(kp) and ord(i)=ord(ip) and ord(j)=ord(jp) and ord(i)<> ord(k) and ord(j)<>ord(k) and ord(i)<>ord(kp) and ord(j)<>ord(kp))
),arc(i,j,k,ip,jp,kp)=1; );
netflow(i,j,k)=0;
netflow('1','1','1')=1;
netflow('3','3','3')=-1;
positive variables x(i,j,k,ip,jp,kp);
variable z;
equations flow, obj;
obj..z=e=sum((i,j,k,ip,jp,kp)$(arc(i,j,k,ip,jp,kp)=1),x(i,j,k,ip,jp,kp));
flow(i,j,k)..sum((ip,jp,kp)$(arc(i,j,k,ip,jp,kp)=1),x(i,j,k,ip,jp,kp))- sum((ip,jp,kp)$(arc(ip,jp,kp,i,j,k)=1),x(ip,jp,kp,i,j,k))=e=netflow(i,j,k);
model Hanoi /all/;
solve Hanoi using mip minimizing z;
display x.l, z.l;
