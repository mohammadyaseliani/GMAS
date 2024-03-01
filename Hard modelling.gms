SETs
i /1*4/

parameter c(i)
/1 3.5
2 5
3 0.8
4 4/;
binary variable y(i);

nonnegative variable x(i)
nonnegative variable w(i);
nonnegative variable w5;
nonnegative variable w6;
variable z;

equations
obj
cons1
cons2
cons3
cons4
cons5
cons6
cons7
cons8
cons9
cons10
cons11
cons12
cons13
cons14
cons15
cons16
cons17
cons18
cons19
cons20
;

obj.. z=e=sum(i,c(i)*w(i));
cons1.. w("1")=l=10000*y("1");
cons2.. w("1")=l=x("1")+10000*(1-y("1"));
cons3.. w("1")=g=x("1")-10000*(1-y("1"));
cons4.. w("2")=l=10000*y("2");
cons5.. w("2")=l=x("2")+10000*(1-y("2"));
cons6.. w("2")=g=x("2")-10000*(1-y("2"));
cons7.. w("4")=l=10000*y("4");
cons8.. w("4")=l=x("4")+10000*(1-y("4"));
cons9.. w("4")=g=x("4")-10000*(1-y("4"));
cons10.. y("1")+y("2")=g=2*y("3");
cons11.. y("3")=g=y("1")+y("2")-1;
cons12.. w("1")+w("2")+w("4")=g=2000;
cons13.. w("4")=l=200;
cons14.. 10*w("1")+1.2*w("2")+9*w5+0.9*1.2*w6=l=2800;
cons15.. w5=l=10000*y("3");
cons16.. w5=l=w("1")+10000*(1-y("3"));
cons17.. w5=g=w("1")-10000*(1-y("3"));
cons18.. w6=l=10000*y("3");
cons19.. w6=l=w("2")+10000*(1-y("3"));
cons20.. w6=g=w("2")-10000*(1-y("3"));

model Untitled_89 /all/

solve Untitled_89 using mip minimizing z;


display x.l,z.l,w.l,w5.l,w6.l,y.l;
