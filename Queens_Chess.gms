sets i /1*8/, j/1*8/;
alias (i,ip);
alias (j,jp);
binary variable x(i,j);
variable z;
parameter domination(i,j,ip,jp);
domination(i,j,ip,jp)=0;
loop((i,j,ip,jp),
if (ord(i)=ord(ip) or ord(j)=ord(jp) or abs(ord(i)-ord(ip))=abs(ord(j)-ord(jp)), domination(i,j,ip,jp)=1;);
);
equations obj_fun, domination_all;
obj_fun..z=e=sum((i,j),x(i,j));
domination_all(i,j)..sum((ip,jp)$(domination(i,j,ip,jp)=1),x(ip,jp))=g=1;
model Untitled_26 /all/;
solve Untitled_26 minimizing z using mip;
display x.l;
