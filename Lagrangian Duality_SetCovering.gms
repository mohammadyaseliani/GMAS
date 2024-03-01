set i ’place’ /1*4/;
set j ’element’ /1*6/;

parameter c(j)
/1       6
2        7
3        11
4        5
5        8
6        8/;
table a(i,j)
         1       2       3       4       5       6
1        1       0       1       0       0       1
2        0       1       0       1       1       0
3        1       1       1       0       0       0
4        0       0       1       0       1       0;
* standard MIP problem formulation
* solve as RMIP to get initial values for the duals

variables
cost ’objective variable’
x(j) ’cover’
;
binary variable x;
equations
obj ’objective’
cover(i) ’covering constraint’
;
obj.. cost =e= sum(j,c(j)*x(j));
cover(i).. sum(j, a(i,j)*x(j)) =g= 1;
option optcr=0;
model genassign /obj,cover/;
solve genassign minimizing cost using rmip;


* Lagrangian dual
* Let assign be the complicating constraint

parameter u(i);
variable bound;
equation LR ’lagrangian relaxation’;
LR.. bound =e= sum(j,(c(j)-sum(i,u(i)*a(i,j)))*x(j))+sum(i,u(i));
model ldual /LR,cover/;

* subgradient iterations

set iter /iter1*iter20/;
scalar continue /1/;
parameter stepsize;
scalar theta /2/;
scalar noimprovement /0/;
scalar bestbound /-INF/;
parameter gamma(i);
scalar norm;
scalar upperbound;
parameter uprevious(i);
scalar deltau;
parameter results(iter,*);

u(i) = cover.m(i);
display u;

parameter upperbound
/20/;

loop(iter$continue,
option optcr=0;
option limrow = 0;
option limcol = 0;
ldual.solprint = 0;
solve ldual minimizing bound using mip;
results(iter,'dual obj') = bound.l;
if (bound.l > bestbound,
bestbound = bound.l;
display bestbound;
noimprovement = 0;
else
noimprovement = noimprovement + 1;
if (noimprovement > 1,
theta = theta/2;
noimprovement = 0;
);
);
results(iter,'noimprov') = noimprovement;
results(iter,'theta') = theta;

gamma(i) = 1-sum(j,a(i,j)*x.l(j));
norm = sum(i,sqr(gamma(i)));
stepsize = theta*(abs(upperbound-bound.l))/norm;
results(iter,'norm') = norm;
results(iter,'step') = stepsize;


* update duals u

uprevious(i) = u(i);
u(i) = max(0, u(i)+stepsize*gamma(i));
display u;


* converged ?

deltau = smax(i,abs(uprevious(i)-u(i)));
results(iter,'deltau') = deltau;
if( deltau < 0.01,
display "Converged";
continue = 0;
);
);
display results;
