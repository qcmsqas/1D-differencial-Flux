L = 55;
tmax = 60;
U = 0.5;
D = 1.6;
Xs = 8;
Cs = 20;
dx = 0.1;
dt = 0.8*min([dx/U,dx*dx*0.5/D]);%to keep stable.
%mesh the space and time
x = 0:dx:L;
t = 0:dt:tmax;
tic
[Cex1] = explicitFinite(x,t,Xs,Cs,D,U);
toc
tic
[Cim1] = implicitFinite(x,t,Xs,Cs,D,U);
toc