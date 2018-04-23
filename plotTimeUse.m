load timeUse.mat;
plot(Nx,timeUse(1,:),Nx,timeUse(2,:));
xlabel('Nx = L/dx');
ylabel('time used (s)');
title('time used by different kind of method');
legend('Explicit Finite Difference','Implicit Finite Difference');