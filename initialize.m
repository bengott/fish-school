%initialize school

%parameters
N = 8; %school size
T = 100; %tank size
BL = 1; %body length
delta_t = .5; %time step
r1 = .5*BL;
r2 = 5*BL;
r3 = 10*BL;
w = 30; %dead angle omega

%pre-allocate variables that will be used later
d = zeros(N,N); 
dp.x = zeros(N,N);
dp.y = zeros(N,N);
dp.theta = zeros(N,N);
beta = zeros(N,N);
new_vmag = zeros(1,N);
closest4 = zeros(1,4);
front4 = zeros(1,4);
side4 = zeros(1,4);

%generate random initial positions (in middle of large tank)
m = T/2 - 4.5;
n = T/2 + 4.5;
p.x = m + (n-m)*rand(1,N);
p.y = m + (n-m)*rand(1,N);

%generate random initial velocity vectors
v.theta = 360*rand(1,N);
v.mag = gamrnd(4,1/3.3,1,N); %random on gamma distribution
v.x = v.mag.*cosd(v.theta);
v.y = v.mag.*sind(v.theta);

%generate non-random initial positions and velocities (for testing)
% p.x = T/2 - N/2:T/2 + N/2 - 1;
% p.y(1:N) = T/2;
% 
% v.theta(1:N) = 100;
% v.mag(1:N) = 1;
% 
% p.x(1) = 1;
% p.y(1) = 1;
% v.theta(1) = 45;
% 
% v.x = v.mag.*cosd(v.theta);
% v.y = v.mag.*sind(v.theta);