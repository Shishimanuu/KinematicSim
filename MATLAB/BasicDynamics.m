%% Dynamic model of a land based robot

clear all;clc;close all;

%% Simulation Parameters
dt = 0.1;       % unit step
ts = 30;        % simulation time
t = 0:dt:ts;    % time span

%% Initial conditions
eta0 = [0;0;0];     % initial pose of the vehicle
zeta0 = [0;0;0];    % initial vector of input commands

eta(:,1) = eta0;
zeta(:,1) = zeta0;

%% Robot Parameters
m = 10;     % mass of the vehicle
Iz = 1;     % moment of inertia of the vehicle

xbc = 0; ybc = 0;   % coordinates of mass center

%% State propagation
for i = 1:length(t)
    u = zeta(1,i); v = zeta(2,i); r = zeta(3,i);

    % Inertia Matrix
    D = [m 0 -m*ybc;
         0 m m*xbc;
         -m*ybc m*xbc Iz+m*(xbc^2 + ybc^2)];
    
    n_v = [m*r*(v + xbc*r);
           m*r*(u - ybc*r);
           m*r*(xbc*u + ybc*v)];

    % Input Vector
    tau(:,i) = [1;1;0.1];
    b = 1;

    % Jacobian Matrix
    psi = eta(3,i);
    J_eta = [cos(psi) -sin(psi) 0;
             sin(psi) cos(psi) 0;
             0 0 1];

    zeta_dot(:,i) = inv(D)*(tau(:,i) - n_v - b*zeta(:,i));
    zeta(:,i+1) = zeta(:,i) + dt*zeta_dot(:,i); % Velocity update

    eta(:,i+1) = eta(:,i) + dt*(J_eta*(zeta(:,i) + dt*zeta_dot(:,i))); % Pose update 
end

%% Animation
Animate(0.6,0.4,eta,t);