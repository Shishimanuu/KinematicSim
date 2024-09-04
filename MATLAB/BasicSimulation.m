%% Basic Kinematic Simulation of land based robot

%% Simulation Parameters
dt = 0.1;
ts = 10;
t = 0:dt:ts;

%% Initial Conditions
x0 = 0;
y0 = 0;
psi0 = 0;

eta(:,1) = [x0; y0; psi0];

%% Trajectory calculation
   for i = 1:length(t)
    psi = eta(3,i);
    j_psi = [cos(psi) -sin(psi) 0;
             sin(psi) cos(psi) 0;
             0 0 1];
    

    % Velocity input command
    u = 0.1;
    v = 0.1;
    r = 0;

    zeta = [u;v;r];

    % Pose in Ground frame
    eta_dot(:,i) = j_psi*zeta;
    eta(:,i+1) = eta(:,i) + dt*eta_dot(:,i);
   end    

% Animation of motion
Animate(0.6,0.4,eta,t);

% Plotting trajactory
axis([-2 2 -2 2]);
plot(eta(1,1:length(t)),eta(2,1:length(t)));
xlabel('x');
ylabel('y');
