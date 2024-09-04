function [eta] = Steering(eta,Vehicle_Parameters,omega,t,dt)
    for i = 1:length(t)
    psi = eta(3,i);
    j_psi = [cos(psi) -sin(psi) 0;
             sin(psi) cos(psi) 0;
             0 0 1];

    % Wheel configuration matrix 
    a = Vehicle_Parameters(1);
    d = 0;
    l = Vehicle_Parameters(2)/2;

    sig = d^2 +l^2 +1;

    W = [(l^2 + 1)/sig (d*l)/sig;
         (d*l)/sig (d^2 + 1)/sig;
         -d/sig l/sig];

    % Velocity input command
    zeta(:,i) = W*[a*omega(1)*cos(omega(2)*t(:,i));
                   a*omega(1)*sin(omega(2)*t(:,i))];

    % Pose in Ground frame
    eta_dot(:,i) = j_psi*zeta(:,i);
    eta(:,i+1) = eta(:,i) + dt*eta_dot(:,i);
    end
