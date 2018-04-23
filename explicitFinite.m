function [Cex] = explicitFinite(x,t,Xs,Cs,D,U)
dx = x(2)-x(1);
dt = t(2)-t(1);
Cex = zeros(size(t,2),size(x,2));
%set the initial state
[~,iXs]=min(abs(x-Xs));%find the point closest to Xs;
iXs= iXs(1);%if there is two points, choose the first one
Cex(1,iXs)=Cs;
%calculate the parameters of stepping, for speed up the hold program.
M1 = (D*dt/dx/dx+U*dt/dx/2);
M2 = (D*dt/dx/dx-U*dt/dx/2);
M3 = (-2*D*dt/dx/dx+1);
MM1 = U*dt/dx;
MM2 = (-U*dt/dx+1);
for n=1:size(t,2)-1
    Cex(n+1,2:end-1)=M1*Cex(n,1:end-2)+M2*Cex(n,3:end)+M3*Cex(n,2:end-1);%renew the C except the boundary.
    Cex(n+1,end) = MM1*Cex(n,end-1)+MM2*Cex(n,end);%calculate the last C for the boundary condition of outflow point
    %we do not renew the first point of Cex,so it is always zero, 
    %for the boundary condition of zero point.
end