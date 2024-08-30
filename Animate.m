%% Animation of motion
function [] = Animate(l,w,eta,t)
% Coordinates of Robot
Rco = [-l/2 -l/2 l/2 l/2 -l/2;
        w/2 -w/2 -w/2 w/2 w/2];
% Animation
figure
for i = 1:length(t)
psi = eta(3,i);
r_psi = [cos(psi) -sin(psi);
         sin(psi) cos(psi)];
pose = r_psi*Rco;
fill(pose(1,:)+eta(1,i),pose(2,:)+eta(2,i),'g');
hold on, grid on
axis([-3 10 -2 10]);
plot(eta(1,1:i),eta(2,1:i));
xlabel('x');
ylabel('y');
pause(0.05);
hold off
end
