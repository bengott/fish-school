%zone-specific priority
%replulsion = distance, parallel = side, attraction = front priority

R = zeros(1,4);
P = zeros(1,4);
A = zeros(1,4);
zs4 = zeros(1,4);
 
for i = 1:N
    iR = 0;
    iP = 0;
    iA = 0;
    iZS = 0;

    %find indices (j values) of neighbors in each zone
    for j = 1:N
        if j ~= i && abs(dp.theta(i,j)) < (180 - w)...
                && d(i,j) < r1 && iR < 4
            iR = iR + 1;
            R(iR) = j;
        end
        if j ~= i && abs(dp.theta(i,j)) < (180 - w)...
                && d(i,j) >= r1 && d(i,j) < r2 && iP < 4
            iP = iP + 1;
            P(iP) = j;
        end
        if j ~= i && abs(dp.theta(i,j)) < (180 - w)...
            && d(i,j) >= r2 && d(i,j) < r3 && iA < 4
            iA = iA + 1;
            A(iA) = j;
        end
    end

    %distance priority in repulsion zone
    %actually, if neighbor j is in R zone, it will always get selected
    %it would matter if we were weighting neighbors by distance...
    if iR > 0
        zs4(1:iR) = R(1:iR);
        iZS = iR;
    end

    %apply side priority in parallel zone
    min_i = 1; %index into sortedP that yields sidemost dp.theta
    if iZS < 4 && iP > 0
        sortedP = sort(abs(abs(dp.theta(i,P(1:iP))) - 90));
        for k = 1:iP
            for j = 1:iP
                if iZS < 4 && abs(abs(dp.theta(i,P(j))) - 90) == sortedP(min_i)
                    iZS = iZS + 1;
                    zs4(iZS) = P(j);
                    %increment min index -> index of next sidemost angle 
                    min_i = min_i + 1;
                end
            end
        end
    end
    
    %apply front priority in attraction zone
    min_i = 1; %index into sortedA that yields frontmost dp.theta
    if iZS < 4 && iA > 0
        sortedA = sort(abs(dp.theta(i,A(1:iA))));
        for k = 1:iA
            for j = 1:iA
                if iZS < 4 && abs(dp.theta(i,A(j))) == sortedA(min_i)
                    iZS = iZS + 1;
                    zs4(iZS) = A(j);
                    %increment min index -> index of next frontmost dp.theta
                    min_i = min_i + 1;
                end
            end
        end
    end

    %calculate resultant turning angle alpha
    if iZS > 0 %at least 1 neighbor sensed
        beta_avg = npi2pi(sum(beta(i,zs4(1:iZS)))/iZS);
        %add randomness (normal distribution)
        sigma = 15; %standard deviation = 15 degrees
        alpha = beta_avg + sigma*randn(1);

        %calculate velocity vector
        v.theta(i) = npi2pi(v.theta(i) + alpha);
        avg_mag = mean(v.mag(zs4(1:iZS)));
        %add randomness (normal distribution)
        sigma = .2; %standard deviation = .2 (need bio basis for this)
        new_vmag(i) = avg_mag + sigma*randn(1);
    
    else %no neighbors in sensory range -> searching
        beta_avg = npi2pi(360*rand);
        alpha = beta_avg; %no need to add normal dist.
        v.theta(i) = npi2pi(v.theta(i) + alpha);
        new_vmag(i) = gamrnd(4,1/3.3,1,1); %random on gamma if no neighbors
    end
end