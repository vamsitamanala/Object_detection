function plotCordSys(O,R,fig_h,st)
R = R.*0.5;
figure(fig_h);hold on;quiver3(O(1),O(2),O(3),R(1,1)',R(1,2)',R(1,3)',['b' st]);
figure(fig_h);hold on;quiver3(O(1),O(2),O(3),R(2,1)',R(2,2)',R(2,3)',['b' st]);
figure(fig_h);hold on;quiver3(O(1),O(2),O(3),R(3,1)',R(3,2)',R(3,3)',['k' st]);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
view(84.954,23.964);grid on;
end