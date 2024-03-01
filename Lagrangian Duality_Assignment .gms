set i ’resource’ /r1*r5/;
set j ’item’ /i1*i10/;
Parameter b(i) 'available resources' / r1 28, r2 20, r3 27, r4 24, r5 19 /;
Table a(i,j) 'utilization of resource i by item j'
        i1  i2  i3  i4  i5  i6  i7  i8  i9 i10
   r1   12   8  25  17  19  22   6  22  20  25
   r2    5  15  15  14   7  11  14  16  17  15
   r3   21  24  13  24  12  16  23  20  15   5
   r4   23  17  10   6  24  20  15  10  19   9
   r5   17  20  15  16   5  13   7  16   8   5;
Table f(i,j) 'cost of assigning item j to resource i'
        i1  i2  i3  i4  i5  i6  i7  i8  i9 i10
   r1   16  26  30  47  18  19  33  37  42  31
   r2   38  42  15  21  26  11  11  50  24  19
   r3   48  17  14  22  14  18  47  32  17  42
   r4   22  32  28  39  37  23  25  12  44  17
   r5   31  42  31  40  16  15  29  31  44  41;

* standard MIP problem formulation
* solve as RMIP to get initial values for the duals

variables
cost ’objective variable’
x(i,j) ’assignments’
;
binary variable x;
equations
obj ’objective’
assign(j) ’assignment constraint’
resource(i) ’resource limitation constraint’
;
obj.. cost =e= sum((i,j), f(i,j)*x(i,j));
assign(j).. sum(i, x(i,j)) =e= 1;
resource(i).. sum(j, a(i,j)*x(i,j)) =l= b(i);
option optcr=0;
model genassign /obj,assign,resource/;
solve genassign minimizing cost using rmip;


* Lagrangian dual
* Let assign be the complicating constraint

parameter u(j);
variable bound;
equation LR ’lagrangian relaxation’;
LR.. bound =e= sum((i,j), (f(i,j)-u(j))*x(i,j))+sum(j, u(j))
model ldual /LR,resource/;

* subgradient iterations

set iter /iter1*iter20/;
scalar continue /1/;
parameter stepsize;
scalar theta /2/;
scalar noimprovement /0/;
scalar bestbound /-INF/;
parameter gamma(j);
scalar norm;
scalar upperbound;
parameter uprevious(j);
scalar deltau;
parameter results(iter,*);

u(j) = assign.m(j);
display u;

upperbound = sum(j, smax(i, f(i,j)));
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

gamma(j) = 1-sum(i,x.l(i,j));
norm = sum(j,sqr(gamma(j)));
stepsize = theta*(upperbound-bound.l)/norm;
results(iter,'norm') = norm;
results(iter,'step') = stepsize;


* update duals u

uprevious(j) = u(j);
u(j) = max(0, u(j)+stepsize*gamma(j));
display u;


* converged ?

deltau = smax(j,abs(uprevious(j)-u(j)));
results(iter,'deltau') = deltau;
if( deltau < 0.01,
display "Converged";
continue = 0;
);
);
display results;
