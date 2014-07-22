%calculate distances between fish
%--------------------------------------------------------------------------
for i = 1:N
    for j = 1:N
        dp.x(i,j) = p.x(j) - p.x(i);
        dp.y(i,j) = p.y(j) - p.y(i);
        dp.theta(i,j) = npi2pi(rad2deg(atan2(dp.y(i,j), dp.x(i,j))));
        d(i,j) = sqrt( dp.x(i,j)^2 + dp.y(i,j)^2 );
    end
end

%calculate turning angles
%--------------------------------------------------------------------------
for i = 1:N
    for j = 1:N
        d_theta = v.theta(j) - v.theta(i);
        
        %repulsion zone (0 < d < r1)
        if d(i,j) > 0 && d(i,j) < r1
            plus90  = npi2pi(d_theta + 90);
            minus90 = npi2pi(d_theta - 90);
            if abs(plus90) < abs(minus90)
                beta(i,j) = plus90;
            else beta(i,j) = minus90;
            end
        end

        %parallel orientation zone (r1 <= d < r2)
        if d(i,j) >= r1 && d(i,j) < r2
            beta(i,j) = npi2pi(d_theta);        
        end
                
        %attraction zone (r2 <= d < r3)
        if d(i,j) >= r2 && d(i,j) < r3
            beta(i,j) = npi2pi(dp.theta(i,j) - v.theta(i));     
        end
    end
end


%apply priority rule to calc velocity vector
%--------------------------------------------------------------------------
%d_priority;
front_priority;
%side_priority;
%zs_priority;

%assign new velocity and position
%--------------------------------------------------------------------------
%velocity - average of neighbors based on priority rule / random searching
v.mag = gamrnd(4,1/3.3,1,N); %random on gamma distribution
%v.mag = new_vmag; %averaged from neighbors using priority rule OR search
v.x = v.mag.*cosd(v.theta);
v.y = v.mag.*sind(v.theta);

%position
p.x = p.x + delta_t * v.x;
p.y = p.y + delta_t * v.y;


%border patrol
%bounce off walls (geometric reflection)
%--------------------------------------------------------------------------
% for i = 1:N
%     if p.x(i) > T
%         v.x(i) = -v.x(i);
%         p.x(i) = T + v.x(i);
%         v.theta(i) = npi2pi(180 - v.theta(i)); %reflection
%     end
%     if p.x(i) < 0
%         v.x(i) = -v.x(i);
%         p.x(i) = 0 + v.x(i);
%         v.theta(i) = npi2pi(180 - v.theta(i));
%     end
%     if p.y(i) > T
%         v.y(i) = -v.y(i);
%         p.y(i) = T + v.y(i);
%         v.theta(i) = npi2pi(-v.theta(i));
%     end
%     if p.y(i) < 0
%         v.y(i) = -v.y(i);
%         p.y(i) = 0 + v.y(i);
%         v.theta(i) = npi2pi(-v.theta(i));
%     end
% end