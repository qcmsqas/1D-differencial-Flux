function [Cim] = implicitFinite(x,t,Xs,Cs,D,U)
dx = x(2)-x(1);
dt = t(2)-t(1);
Cim = zeros(size(t,2),size(x,2));
%set the initial state
[~,iXs]=min(abs(x-Xs));%find the point closest to Xs;
iXs= iXs(1);%if there is two points, choose the first one
Cim(1,iXs)=Cs;
%calculate the parameters of stepping, for speed up the hold program.
M1 = (-D*dt/dx/dx-U*dt/dx/2);
M2 = (-D*dt/dx/dx+U*dt/dx/2);
M3 = (2*D*dt/dx/dx+1);
MM1 = -U*dt/dx;
MM2 = (U*dt/dx+1);
%A is the matrix for A*Cn+1 = Cn except the first point(always 0);
A = zeros(size(x,2)-1,size(x,2)-1);%initial
%for the boundary condition of inflow: A(1,0) always be zeros.
A(1,1)=M3;
A(1,2)=M2;
%for the boundary condition of outflow;
A(end,end-1) = MM1;
A(end,end) = MM2;
for i=2:size(x,2)-2
    A(i,i-1)=M1;
    A(i,i+1)=M2;
    A(i,i) = M3;
end
B = (A^(-1))';%So, Cn+1 = Cn*B; Cn is a row vector.
for n=1:size(t,2)-1
    Cim(n+1,2:end)=Cim(n,2:end)*B;
    %we do not renew the first point of Cex,so it is always zero, 
    %for the boundary condition of zero point.
end