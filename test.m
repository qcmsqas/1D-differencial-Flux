L = 55;
tmax = 60;
U = 0.5;
D = 1.6;
Xs = 8;
Cs = 20;
dx = 1;
dt = 0.8*min([dx/U,dx*dx*0.5/D]);%to keep stable.
%mesh the space and time
x = 0:dx:L;
t = 0:dt:tmax;
[Cex1] = explicitFinite(x,t,Xs,Cs,D,U);
[Cim1] = implicitFinite(x,t,Xs,Cs,D,U);
dx2 = 0.2;
dt2 = 0.8*min([dx2/U,dx2*dx2*0.5/D]);%to keep stable.
%mesh the space and time
x2 = 0:dx2:L;
t2 = 0:dt2:tmax;
[Cex2] = explicitFinite(x2,t2,Xs,Cs/dx2,D,U);
[Cim2] = implicitFinite(x2,t2,Xs,Cs/dx2,D,U);
[Cim3] = implicitFinite(x2,t2,Xs,Cs,D,U);
plot(x,Cim1(end,:),x2,Cim2(end,:),x2,Cim3(end,:));
xlabel('x (m)');
ylabel('concentration');
legend('Cs=20,dx=1','Cs=100,dx=0.2','Cs=20,dx=0.2');