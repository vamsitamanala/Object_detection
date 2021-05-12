function M = PPM(coins_w,u,v)
len = length(u);
coins_w = coins_w(1:len,:);
a = [coins_w(:,1) coins_w(:,2) coins_w(:,3) ones(len,1) zeros(len,1) zeros(len,1) zeros(len,1) zeros(len,1) -u.*coins_w(:,1) -u.*coins_w(:,2) -u.*coins_w(:,3) -u];
b = [zeros(len,1) zeros(len,1) zeros(len,1) zeros(len,1) coins_w(:,1) coins_w(:,2) coins_w(:,3) ones(len,1) -v.*coins_w(:,1) -v.*coins_w(:,2) -v.*coins_w(:,3) -v];

A = zeros(len*2,12);
A(1:2:end,:) = a;
A(2:2:end,:) = b;

[~,~,Va] = svd(A);
M = Va(:,end);
M = [M(1:4)';M(5:8)';M(9:12)'];
end