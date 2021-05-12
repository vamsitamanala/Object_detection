function [K,R,O,pPoint] = KRO_PPM(M)
M_n = inv(M(:, 1:3));
[U,B] = qr(M_n);
R = inv(U);
K = inv(B);
D = diag(sign(diag(K)));
K = K*D; %#ok
R = D*R; %#ok
O = -inv(R)*inv(K)*M(:,4);
pPoint = K(:,3)./K(3,3);
end