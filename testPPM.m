function error = testPPM(M,coins_w,u,v)
Pw_test = [coins_w(7,:) 1];
P_test = M*Pw_test';
P_test = P_test./P_test(3);
error = abs([u(7) v(7) 1]'-P_test);
end