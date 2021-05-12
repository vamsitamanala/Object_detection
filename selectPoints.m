wind = 80;
count = 0;button=0;
while button~=97
    button=0;
    figure(fig_h1);[u,v,button] = ginput(1);
    while button ~=110
        [u,v,button] = ginput(1);
    end
    button = 0;
    axis([u-wind u+wind v-wind v+wind]);
    figure(fig_h2);[u,v,button] = ginput(1);
    while button ~=110
        [u,v,button] = ginput(1);
    end
    button = 0;
    axis([u-wind u+wind v-wind v+wind]);
    
    figure(fig_h1);[u,v,button] = ginput(1);
    while button ~=110
        [u,v,button] = ginput(1);
    end
    count=count+1;
    u1(count) = u;
    v1(count) = v;
    button = 0;
    figure(fig_h2);[u,v,button] = ginput(1);
    while button ~=110
        [u,v,button] = ginput(1);
    end
    u2(count) = u;
    v2(count) = v;
    button = 0;
    figure(fig_h2);axis tight;
    figure(fig_h1);axis tight;
end
if size(u1,2)~=1
    u1 = u1';u2 = u2';v1 = v1';v2 = v2';
end
save points u1 u2 v1 v2;
