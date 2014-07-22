%front priority - average frontmost 4 neighbors (with dead zone)
temp = zeros(1,N-1);
for i = 1:N
    index = 0;
    diff_front = abs(dp.theta(i,:));
    %remove self
    for j = 1:N
        if j ~= i
            index = index + 1;
            temp(index) = diff_front(j);
        end
    end
    diff_front = temp;
    sorted = sort(diff_front);
    %sorted = sort(abs(dp.theta(i,:)));
    
    index = 0;
    min_i = 1; %index into sorted array that yields frontmost dp.theta
    for k = 1:N-1
        for j = 1:N
            %remove dead zone, searching zone, and self, and limit to 4
            if index < 4 && j ~= i && abs(dp.theta(i,j)) < (180 - w)...
                    && d(i,j) < r3 && abs(dp.theta(i,j)) == sorted(min_i)
                index = index + 1;
                front4(index) = j;
                %increment min index -> index of next frontmost dp.theta
                min_i = min_i + 1;
            end
        end
    end
%         for k = 1:N
%             if index < 4 && k ~= i && abs(dp.theta(i,j)) < (180 - w)...
%                 && d(i,j) < r3 && abs(dp.theta(i,j)) == sorted(k)
%             front4(index + 1) = j;
%             index = index + 1;
%         end

    if index > 0 %at least 1 neighbor visible
        beta_avg = npi2pi(sum(beta(i,front4(1:index)))/index);
        %add randomness (normal distribution)
        sigma = 15; %standard deviation = 15 degrees
        alpha = beta_avg + sigma*randn(1);

        %calculate velocity vector
        v.theta(i) = npi2pi(v.theta(i) + alpha);
        avg_mag = mean(v.mag(front4(1:index)));
        %add randomness (normal distribution)
        sigma = .2; %standard deviation = .2 (need bio basis for this)
        new_vmag(i) = avg_mag + sigma*randn(1);
    
    else %no neighbors in sight -> searching
        beta_avg = npi2pi(360*rand);
        alpha = beta_avg; %no need to add normal dist.
        v.theta(i) = npi2pi(v.theta(i) + alpha);
        new_vmag(i) = gamrnd(4,1/3.3,1,1); %random on gamma if no neighbors
    end
end