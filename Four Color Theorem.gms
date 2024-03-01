sets i /AN,CO,TA,MA,ZA,NA1,BO,ZI,MO,SA,SW,LE/, c/1*12/;
alias (i,j), (c,cp);
table adjacent(i,j)
         AN CO TA MA ZA NA1 BO ZI MO SA SW LE
AN       0  1  0  0  1  1   0  0  0  0  0  0
CO       0  0  1  0  1  0   0  0  0  0  0  0
TA       0  0  0  1  1  0   0  0  0  0  0  0
MA       0  0  0  0  1  0   0  0  1  0  0  0
ZA       0  0  0  0  0  1   0  1  1  0  0  0
NA1      0  0  0  0  0  0   1  0  0  1  0  0
BO       0  0  0  0  0  0   0  1  0  1  0  0
ZI       0  0  0  0  0  0   0  0  1  1  0  0
MO       0  0  0  0  0  0   0  0  0  0  1  0
SA       0  0  0  0  0  0   0  0  0  0  1  1
SW       0  0  0  0  0  0   0  0  0  0  0  0
LE       0  0  0  0  0  0   0  0  0  0  0  0
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