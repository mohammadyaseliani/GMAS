sets i /1*8/, c/1*8/;
alias (i,j), (c,cp);
table adjacent(i,j)
      1 2 3 4 5 6 7 8
1     0 1 1 1 0 0 1 0
2     0 0 0 0 1 1 0 0
3     0 0 0 0 0 0 1 0
4     0 0 0 0 0 0 1 0
5     0 0 0 0 0 1 0 1
6     0 0 0 0 0 0 0 1
7     0 0 0 0 0 0 0 1
8     0 0 0 0 0 0 0 0;
binary variable x(i,c),used(c);
variable z;
equations obj, assign, collision,check_used, ordering;
obj..z=e=sum(c,used(c));
assign(i)..sum(c,x(i,c))=e=1;
collision(i,j,c)$(ord(i)<ord(j))..x(i,c)+x(j,c)=l=2-adjacent(i,j);
check_used(c)..card(c)*used(c)=g=sum(i,x(i,c));
ordering(c)$(ord(c)<card(c))..used(c)=g=used(c+1);
model Untitled_27 /all/;
solve Untitled_27 minimizing z using mip;
display x.l;
