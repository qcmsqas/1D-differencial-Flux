%This is the main file, run this for all the results
%Setting the parameters:
L = 55;
tmax = 60;
U = 0.5;
D = 1.6;
Xs = 8;
Cs = 20;
Xflux = 36;
Xmonitor=[4 8 16 24 32 54];%plot the concentration at these positions;
Tmonitor=[0,15,30,45,60];%plot the concentration at these times;
%get error for different dx;
ddx = [0.25,1/3,0.5,2/3,1,2,3,4,5,6,8,10].^(-1);
err = zeros(1,size(ddx,2));
ddt = ddx*0;
for i = 1:size(ddx,2)
    %parameters for meshing
    dx = ddx(i);
    dt = 0.8*min([dx/U,dx*dx*0.5/D]);%to keep stable.
    ddt(i)=dt;
    %mesh the space and time
    x = 0:dx:L;
    t = 0:dt:tmax;
    tic
    [Cex] = explicitFinite(x,t,Xs,Cs/dx,D,U);
    toc
    tic
    [Cim] = implicitFinite(x,t,Xs,Cs/dx,D,U);
    toc
    err(i) = (sum((Cex(end,2:end)-Cim(end,2:end)).^2)/(size(x,2)-1)).^0.5;
end

figure();
loglog(ddt.*ddx,err,'o-');
title('RMSE between Implicit and Explicit VS \deltax\deltat)');
xlabel('\deltax\deltat');
ylabel('RMSE between two methods');

figure();
hold on;
lgd = cell(1,size(Tmonitor,2));
for i=1:size(Tmonitor,2)
    [~,it] = min(abs(t-Tmonitor(i)));
    it =it(1);
    plot(x,Cex(it,:));
    lgd{i} = ['time=' num2str(Tmonitor(i)) 's'];
end
[~,it] = min(abs(t-Tmonitor(2)));
ymax = max(Cex(it,:));
ylim([0,ymax]);
legend(lgd);
xlabel('x (m), position along the river');
ylabel('C (Kg/m), concentration');
title('concentration at different time');
%plot total mass at different time;
figure();
mass = sum(Cim,2)*dx;
plot(t,mass);
xlabel('time (s)');
ylabel('total mass (Kg)');
title('total mass VS time');
t2 = 0:dt:3*tmax;
[Cex2] = explicitFinite(x,t2,Xs,Cs,D,U);
figure();
mass2 = sum(Cex2,2)*dx;
plot(t2,mass2);
xlabel('time (s)');
ylabel('total mass (Kg)');
title('total mass VS time');

%plot flux at xflux
figure();
[~,iflux] = min(abs(x-Xflux));
iflux = iflux(1);
flux = Cex(:,iflux)*U-(Cex(:,iflux+1)-Cex(:,iflux-1))*D/(2*dx);
plot(t,flux');
xlabel('time (s)');
ylabel(['flux (Kg/s) at ' num2str(Xflux) 'm']);
title(['flux VS time at x=' num2str(Xflux) 'm']);
figure();
flux2 = Cex2(:,iflux)*U-(Cex2(:,iflux+1)-Cex2(:,iflux-1))*D/(2*dx);
plot(t2,flux2');
xlabel('time (s)');
ylabel(['flux (Kg/s) at ' num2str(Xflux) 'm']);
title(['flux VS time at x=' num2str(Xflux) 'm']);

%3D plot of the Concertration
figure();
[X,T]=meshgrid(x,t);
mesh(X,T,Cex);
zlim([0,5]);
set(gca,'Clim',[0,3]);
view(2);
colorbar;
xlim([0,55]);
ylim([0,60]);
xlabel('x (m), position along the river');
ylabel('t (s), time');
%cm = ([0:128;128:-1:0;ones(1,129)*0]/128)';
cm = hot(256);
colormap(cm);
ylabel(colorbar,'concentration','fontsize',12);
title('2D color plot of the solution');

[~,iXs]=min(abs(x-Xs));%find the point closest to Xs;
iXs= iXs(1);%if there is two points, choose the first one
figure();
subplot(1,2,1);
plot(x(iXs-2:iXs+2),Cex(1,iXs-2:iXs+2), ...
     x(iXs-2:iXs+2),Cex(2,iXs-2:iXs+2), ...
     x(iXs-2:iXs+2),Cex(3,iXs-2:iXs+2));
xlabel('x (m), position along the river');
ylabel('C (Kg/m), concentration');
legend('Step0','Step1','Step2');
title('explicit finite difference');
subplot(1,2,2);
plot(x(iXs-2:iXs+2),Cim(1,iXs-2:iXs+2), ...
     x(iXs-2:iXs+2),Cim(2,iXs-2:iXs+2), ...
     x(iXs-2:iXs+2),Cim(3,iXs-2:iXs+2));
xlabel('x (m), position along the river');
ylabel('C (Kg/m), concentration');
legend('Step0','Step1','Step2');
title('implicit finite difference');
 
test;
plotTimeUse;