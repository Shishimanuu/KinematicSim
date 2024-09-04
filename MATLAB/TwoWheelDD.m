function [eta] = TwoWheelDD(eta,Vehicle_Parameters,omega,t,dt)
    for i = 1:length(t)
    psi = eta(3,i);
    j_psi = [cos(psi) -sin(psi) 0;
             sin(psi) cos(psi) 0;
             0 0 1];

    % Wheel configuration matrix 
    a = Vehicle_Parameters(1);
    d = Vehicle_Parameters(2)/2;

    W = [a/2 a/2;
         0 0;
        -a/(2*d) a/(2*d)];

    % Velocity input command
    zeta(:,i) = W*omega;

    % Pose in Ground frame
    eta_dot(:,i) = j_psi*zeta(:,i);
    eta(:,i+1) = eta(:,i) + dt*eta_dot(:,i);
end
