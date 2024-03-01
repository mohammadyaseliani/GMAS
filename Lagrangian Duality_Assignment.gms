set i ’tasks’ /i1*i3/;
set j ’servers’ /j1*j2/;
parameter b(j) ’available resources’ /
j1 13
j2 11
/;
table c(i,j) ’cost coefficients’
         j1 j2
i1        9 2
i2        1 2
i3        3 8
;
table a(i,j) ’resource usage’
         j1 j2
i1        6 8
i2        7 5
i3        9 6
;
*--------------------------------------------------------------------
* standard MIP problem formulation
* solve as RMIP to get initial values for the duals
*--------------------------------------------------------------------
variables
cost ’objective variable’
x(i,j) ’assignments’
;
binary variable x;
equations
obj ’objective’
assign(i) ’assignment constraint’
resource(j) ’resource limitation constraint’
;
obj.. cost =e= sum((i,j), c(i,j)*x(i,j));
assign(i).. sum(j, x(i,j)) =e= 1;
resource(j).. sum(i, a(i,j)*x(i,j)) =l= b(j);
option optcr=0;
model genassign /obj,assign,resource/;
solve genassign minimizing cost using rmip;

*---------------------------------------------------------------------
* Lagrangian dual
* Let assign be the complicating constraint
*---------------------------------------------------------------------
parameter u(i);
variable bound;
equation LR ’lagrangian relaxation’;
LR.. bound =e= sum((i,j), c(i,j)*x(i,j))
+ sum(i, u(i)*[1-sum(j,x(i,j))]);
model ldual /LR,resource/;
*---------------------------------------------------------------------
* subgradient iterations
*---------------------------------------------------------------------
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

u(i) = assign.m(i);
display u;

parameter initx(i,j) / i1.j1 1, i2.j2 1, i3.j2 1 /;
upperbound = sum[(i,j), c(i,j)*initx(i,j)];
display upperbound;

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

gamma(i) = 1-sum(j,x.l(i,j));
norm = sum(i,sqr(gamma(i)));
stepsize = theta*(upperbound-bound.l)/norm;
results(iter,'norm') = norm;
results(iter,'step') = stepsize;

*
* update duals u
*
uprevious(i) = u(i);
u(i) = max(0, u(i)+stepsize*gamma(i));
display u;

*
* converged ?
*
deltau = smax(i,abs(uprevious(i)-u(i)));
results(iter,'deltau') = deltau;
if( deltau < 0.01,
display "Converged";
continue = 0;
);
);
display results;
