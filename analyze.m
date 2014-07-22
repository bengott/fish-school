%polarization
sv = [sum(v.x); sum(v.y)];
angle = zeros(1,N);
for i = 1:N
    vo = [v.x(i); v.y(i)];
    angle(i) = acosd(dot(sv,vo)/(norm(sv)*norm(vo)));
end
pol(s,t) = mean(angle);

%expanse
a(s,t) = sqrt( mean((p.x - mean(p.x)).^2 + (p.y - mean(p.y)).^2) );
