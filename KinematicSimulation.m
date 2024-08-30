%% Kinematic Simulation of land based robot
clear all; clc; close all;

%% Simulation Parameters
dt = 0.1;
ts = 10;
t = 0:dt:ts;

%% Physical parameters of the vehicle

a = 0.3;
w = 0.4;
l = 0.6;

%% Initial Conditions
x0 = 0;
y0 = 0;
psi0 = 0;

eta(:,1) = [x0; y0; psi0];

%% Trajectory Calculation
% if(Vehicle == 1)
% Two Wheel Differential Drive
    omegaL = 0.5;
    omegaR = 0.5;

    omega_DD = [omegaL;omegaR];

    eta = TwoWheelDD(eta,[a;w],omega_DD,t,dt);

% Onmi-Direction Drive
 %eta = Omni(eta,,,,t,dt);

% Mecanum Wheel Drive
    % omega1 = 1.5;
    % omega2 = -1.5;
    % omega3 = 1.5;
    % omega4 = -1.5;
    % 
    % omega_M = [omega1;omega2;omega3;omega4];
    % 
    % eta = Mecanum(eta,[a;l;w],omega_M,t,dt);
    
    % eta = Steering(eta,[a;l],[1;pi/20],t,dt);
% Animation of motion
Animate(l,w,eta,t);

% Plotting trajectory 
figure
grid on
axis([-2 2 -2 2]);
plot(eta(1,1:length(t)),eta(2,1:length(t)));
xlabel('x');
ylabel('y');
hold off