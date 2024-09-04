%% Kinematic Simulation of land based robot
clear all; clc; close all;

% Simulation Parameters
dt = 0.1;
ts = 10;
t = 0:dt:ts;

%% Physical parameters of the vehicle
% For 2 wheel differential drive
a_dd = 0.05;
w_dd = 0.2;

% For Mecanum wheel drive
a_m = 0.5;
w_m = 0.4;
l_m = 0.6;

%% Initial Conditions
x0 = 0;
y0 = 0;
psi0 = 0;

eta(:,1) = [x0; y0; psi0];

%% Trajectory Calculation

% Two Wheel Differential Drive
    % omegaL = 0.5;
    % omegaR = 0.5;
    % 
    % omega = [omegaL;omegaR];
    % 
    % eta = TwoWheelDD(eta,[a_dd,w_dd],[5;0],t,dt);

% Onmi-Direction Drive
 %eta = Omni(eta,,,,t,dt);

% Mecanum Wheel Drive
    omega1 = 0.5;
    omega2 = 0.5;
    omega3 = 0.5;
    omega4 = 0.5;

    omega_m = [omega1;omega2;omega3;omega4];

    eta = Mecanum(eta,[a_m;l_m;w_m],omega_m,t,dt);

% Animation of motion
Animate(0.6,0.4,eta,t);

% Plotting trajectory 
figure
grid on
axis([-2 2 -2 2]);
plot(eta(1,1:length(t)),eta(2,1:length(t)));
xlabel('x');
ylabel('y');
hold off