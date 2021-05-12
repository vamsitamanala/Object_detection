function [u_rect,v_rect] = RectPoints(u,v,Q,Qn,adjust)
len = length(u);
P = [u v ones(len,1)];
P(:,1) = P(:,1);
P_rect = ((Qn/Q)*P')';P_rect = P_rect./P_rect(:,3);
u_rect = P_rect(:,1)-adjust;
v_rect = P_rect(:,2);
end