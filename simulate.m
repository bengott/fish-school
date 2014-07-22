clear
T = 100; %number of iterations per simulation
S = 10; %number of simulations to run

%initialize analysis variables
pol = zeros(S,T);
a = zeros(S,T);
pol_avg = zeros(1,S);
a_avg = zeros(1,S);

tic
for s = 1:S
    initialize;
    for t = 1:T
        draw
        %pause(.1);
        think; 
        analyze;
        
%         figure(2);
%         subplot(2,1,1); plot(1:t,pol(s,1:t));
%         title('polarization'); xlim([1 T]); ylim([0 90]);
%         subplot(2,1,2); plot(1:t,a(s,1:t));
%         title('expanse'); xlim([1 T]);
    end
    pol_avg(s) = mean(pol(s,:));
    a_avg(s) = mean(a(s,:));
    
    figure(3);
    subplot(2,1,1); plot(1:s,pol_avg(1:s), 1:s,pol_avg(1:s),'o');
    title('polarization'); xlim([1 S]); ylim([0 90]);
    subplot(2,1,2); plot(1:s,a_avg(1:s), 1:s,a_avg(1:s),'o');
    title('expanse'); xlim([1 S]);
    toc
end
polarization = mean(pol_avg)
expanse = mean(a_avg)
