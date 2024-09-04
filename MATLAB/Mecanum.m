function [eta] = Mecanum(eta,Vehicle_parameters,omega,t,dt)
    for i = 1:length(t)
    psi = eta(3,i);
    J_psi = [cos(psi) -sin(psi) 0;
             sin(psi) cos(psi) 0;
             0 0 1];
    % Wheel configuration matrix
    a = Vehicle_parameters(1);
    lw = Vehicle_parameters(2)/2;
    dw = Vehicle_parameters(3)/2;
    
    W = (a/4)*[1 1 1 1;
         1 -1 1 -1;
         -1/(dw-lw) -1/(dw-lw) 1/(dw-lw) 1/(dw-lw)];
    
    % Velocity input command
    zeta(:,i) = W*omega;

    % Pose in Ground frame
    eta_dot(:,i) = J_psi*zeta(:,i);
    eta(:,i+1) = eta(:,i) + dt*eta_dot(:,i);
    end