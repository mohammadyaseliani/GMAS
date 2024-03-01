set i ’item’ /1*6/;
set j ’facility’ /1*5/;

Table c(i,j) 'assignement of item i to facility j'
         1       2       3       4       5
1        6       2       1       3       5
2        4       10      2       6       1
3        3       2       4       1       3
4        2       0       4       1       4
5        1       8       6       2       5
6        3       2       4       8       1;
parameter f(j)
/1       2
2        4
3        5
4        3
5        3/;
* standard MIP problem formulation
* solve as RMIP to get initial values for the duals
binary variable y(j);
variables
profit ’objective variable’
x(i,j) ’assignments’
;
binary variable x;
equations
obj ’objective’
assign(i) ’assignment constraint’
condition(i,j) ’a location must be selected’
;
obj.. profit =e= sum((i,j), c(i,j)*x(i,j))-sum(j,f(j)*y(j));
assign(i).. sum(j, x(i,j)) =e= 1;
condition(i,j).. x(i,j)=l=y(j);
option optcr=0;
model genassign /obj,assign,condition/;
solve genassign maximizing profit using rmip;


* Lagrangian dual
* Let assign be the complicating constraint

parameter u(i);
variable bound;
equation LR ’lagrangian relaxation’;
LR.. bound =e= sum((i,j), (c(i,j)-u(i))*x(i,j))+sum(i, u(i))-sum(j,f(j)*y(j));
model ldual /LR,condition/;

* subgradient iterations

set iter /iter1*iter20/;
scalar continue /1/;
parameter stepsize;
scalar theta /2/;
scalar noimprovement /0/;
scalar bestbound /INF/;
parameter gamma(i);
scalar norm;
scalar lower_bound;
parameter uprevious(i);
scalar deltau;
parameter results(iter,*);

u(i) = assign.m(i);
display u;

parameter lower_bound
/20/;

loop(iter$continue,
option optcr=0;
option limrow = 0;
option limcol = 0;
ldual.solprint = 0;
solve ldual maximizing bound using mip;
results(iter,'dual obj') = bound.l;
if (bound.l < bestbound,
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

gamma(i) = 1-sum(j,x.l(i,j));
norm = sum(i,sqr(gamma(i)));
stepsize = theta*(abs(lower_bound-bound.l))/norm;
results(iter,'norm') = norm;
results(iter,'step') = stepsize;


* update duals u

uprevious(i) = u(i);
u(i) = max(0, u(i)-stepsize*gamma(i));
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
