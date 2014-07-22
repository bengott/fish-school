%calculate distances between fish
%--------------------------------------------------------------------------
d = zeros(N,N); %pre-allocate
dp.x = zeros(N,N);
dp.y = zeros(N,N);
dp.theta = zeros(N,N);
for i = 1:N
    for j = 1:N
        dp.x(i,j) = p.x(j) - p.x(i);
        dp.y(i,j) = p.y(j) - p.y(i);
        dp.theta(i,j) = npi2pi(rad2deg(atan2(dp.y(i,j), dp.x(i,j))));
        d(i,j) = sqrt( dp.x(i,j)^2 + dp.y(i,j)^2 );
    end
end
%--------------------------------------------------------------------------

%calculate turning angles
%--------------------------------------------------------------------------
beta = zeros(N,N); %pre-allocate
for i = 1:N
    for j = 1:N
        angle = v.theta(j) - v.theta(i);
        
        %repulsion zone (0 < d < r1)
        if d(i,j) > 0 && d(i,j) < r1
            plus90  = npi2pi(angle + 90);
            minus90 = npi2pi(angle - 90);
            if abs(plus90) < abs(minus90)
                beta(i,j) = plus90;
            else beta(i,j) = minus90;
            end
        end

        %parallel orientation zone (r1 <= d < r2)
        if d(i,j) >= r1 && d(i,j) < r2
            beta(i,j) = npi2pi(angle);        
        end
                
        %attraction zone (r2 <= d < r3)
        if d(i,j) >= r2 && d(i,j) < r3
            beta(i,j) = npi2pi(dp.theta(i,j) - v.theta(i));     
        end
        
%         %searching zone (d >= r3)
%         if d(i,j) >= r3
%             beta(i,j) = npi2pi(360*rand);
%         end
    end
end
%--------------------------------------------------------------------------

%calculate resultant theta orientation
%--------------------------------------------------------------------------
%simple averaging model
% for i = 1:N
%     v.theta(i) = npi2pi((sum(beta(i,:)) - beta(i,i)) / (N-1));
% end

%averaging (with no searching unless all neighbors farther than r3)
% for i = 1:N
%     sum = 0;
%     counter = 0;
%     dmin = 2*T^2; %max distance in square tank of size TxT
%     
%     %find minumum neighbor distance for fish i
%     for j = 1:N
%         if i ~= j && d(i,j) < dmin
%             dmin = d(i,j);
%         end
%     end
%     
%     for j = 1:N
%         if i ~= j
%             if dmin <= r3
%                 if d(i,j) <= r3 %only use neighbors closer than r3
%                     sum = sum + beta(i,j);
%                     counter = counter + 1;
%                 end
%             else %if dmin > r3, use all neighbors (all searching zone)
%                 sum = sum + beta(i,j);
%                 counter = counter + 1;
%             end
%         end
%     end
%     v.theta(i) = npi2pi(v.theta(i) + npi2pi(sum/counter));
% end

%distance priority - average closest 4 neighbors (with dead zone)
% w = 30;
% closest4 = zeros(1,4); %pre-allocate for speed
% new_v.x = zeros(1,N); % temp vectors to hold new velocity
% new_v.y = zeros(1,N);
% for i = 1:N
%     index = 0;
%     sorted = sort(d(i,:));
%     for j = 1:N
%         %remove dead zone, searching zone, and self, and limit to 4
%         for k = 1:N
%             if index < 4 && k ~= i && abs(dp.theta(i,j)) < (180 - w)...
%                 && d(i,j) < r3 && d(i,j) == sorted(k)
%             closest4(index + 1) = j;
%             index = index + 1;
%             end
%         end
%     end
% 
%     if index > 0 %at least 1 neighbor visible
%         beta_avg = npi2pi(sum(beta(i,closest4(1:index)))/index);
%         %add randomness (normal distribution)
%         sigma = 15; %standard deviation = 15 degrees
%         alpha = beta_avg + sigma*randn(1);
% 
%         %calculate velocity vector
%         %should magnitude have some randomness too?
%         v.theta(i) = npi2pi(v.theta(i) + alpha);
% %         new_v.x(i) = sqrt(sum(v.x(closest4(1:index)).^2));
% %         new_v.y(i) = sqrt(sum(v.y(closest4(1:index)).^2));
%     
%     else %no neighbors in sight -> searching
%         beta_avg = npi2pi(360*rand);
%         alpha = beta_avg; %no need to add normal dist.
%         v.theta(i) = npi2pi(v.theta(i) + alpha);
% %         vmag = gamrnd(4,1/3.3,1,1); %random gamma if no neighbors
% %         new_v.x(i) = vmag.*cosd(v.theta(i));
% %         new_v.y(i) = vmag.*sind(v.theta(i));
%     end
% end

%front priority - average frontmost 4 neighbors (with dead zone)
% w = 30;
% front4 = zeros(1,4); %pre-allocate for speed
% for i = 1:N
%     index = 0;
%     sorted = sort(abs(dp.theta(i,:)));
%     for j = 1:N
%         %remove dead zone, searching zone, and self, and limit to 4
%         for k = 1:N
%             if index < 4 && k ~= i && abs(dp.theta(i,j)) < (180 - w)...
%                 && d(i,j) < r3 && abs(dp.theta(i,j)) == sorted(k)
%             front4(index + 1) = j;
%             index = index + 1;
%             end
%         end
%     end
% 
%     if index > 0 %at least 1 neighbor visible
%         beta_avg = npi2pi(sum(beta(i,front4(1:index)))/index);
%         %add randomness (normal distribution)
%         sigma = 15; %standard deviation = 15 degrees
%         alpha = beta_avg + sigma*randn(1);
% 
%         %calculate velocity vector
%         %should magnitude have some randomness too?
%         v.theta(i) = npi2pi(v.theta(i) + alpha);
% %         new_v.x(i) = sqrt(sum(v.x(closest4(1:index)).^2));
% %         new_v.y(i) = sqrt(sum(v.y(closest4(1:index)).^2));
%     
%     else %no neighbors in sight -> searching
%         beta_avg = npi2pi(360*rand);
%         alpha = beta_avg; %no need to add normal dist.
%         v.theta(i) = npi2pi(v.theta(i) + alpha);
% %         vmag = gamrnd(4,1/3.3,1,1); %random gamma if no neighbors
% %         new_v.x(i) = vmag.*cosd(v.theta(i));
% %         new_v.y(i) = vmag.*sind(v.theta(i));
%     end
% end

%d_priority;
front_priority;
%--------------------------------------------------------------------------

%assign new velocity and position
%--------------------------------------------------------------------------
%velocity - vmag random on gamma distribution 
vmag = gamrnd(4,1/3.3,1,N);
v.x = vmag.*cosd(v.theta);
v.y = vmag.*sind(v.theta);

%velocity - average of neigbors based on priority rule / random searching
% v.x = new_v.x;
% v.y = new_v.y;

%position
p.x = p.x + v.x; %v = d/t, assume t = 1 iteration (timestep)
p.y = p.y + v.y;
%--------------------------------------------------------------------------

%border patrol
%--------------------------------------------------------------------------
for i = 1:N
    if p.x(i) > T
        v.x(i) = -v.x(i);
        p.x(i) = T + v.x(i);
        v.theta(i) = npi2pi(180 - v.theta(i)); %reflection
    end
    if p.x(i) < 0
        v.x(i) = -v.x(i);
        p.x(i) = 0 + v.x(i);
        v.theta(i) = npi2pi(180 - v.theta(i));
    end
    if p.y(i) > T
        v.y(i) = -v.y(i);
        p.y(i) = T + v.y(i);
        v.theta(i) = npi2pi(-v.theta(i));
    end
    if p.y(i) < 0
        v.y(i) = -v.y(i);
        p.y(i) = 0 + v.y(i);
        v.theta(i) = npi2pi(-v.theta(i));
    end
end
%--------------------------------------------------------------------------