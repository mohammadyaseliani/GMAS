variables obj_val;
positive variables y1,y2,z;
equations eq1,eq2,eq3,eq4,obj_fun;
eq1..-y1+y2-4*z=l=0;
eq2..2*y1+y2-14*z=l=0;
eq3..y2-6*z=l=0;
eq4..y1+3*y2+4*z=e=1;
obj_fun..obj_val=e=-2*y1+y2+2*z;
model linear /all/;
solve linear min obj_val using lp;
display y1.l,y2.l,z.l