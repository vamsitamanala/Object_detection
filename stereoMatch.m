function  [uC,vC] = stereoMatch(u,v,imageMatrix1n,imageMatrix2n,F,fig_h1,fig_h2)
u = round(u);v = round(v);
uC = zeros(size(u));
vC = zeros(size(v));
for ind=1:length(u)
    m = 50;
    xmin = 1;
    xmax = size(imageMatrix2n(:,:,1),2);
    ymin = 1;
    ymax = size(imageMatrix2n(:,:,1),1);
    I1 = (double(imageMatrix1n(:,:,1))+double(imageMatrix1n(:,:,2))+double(imageMatrix1n(:,:,3)))./3;
    I2 = (double(imageMatrix2n(:,:,1))+double(imageMatrix2n(:,:,2))+double(imageMatrix2n(:,:,3)))./3;
    a2 = (F'*[u(ind) v(ind) 1]')';
    y2 = @(x2) -(a2(1)*x2/a2(2)) - (a2(3)/a2(2));
    sumS = ones((xmax-m)-(xmin+m)+1,3).*1e3;
    count = 0;
    for x=xmin+m:xmax-m
        y = round(y2(x));
        if y<=ymin+m || y>=ymax-m
            continue;
        end
        sum = 0;
        for k=-m/2:m/2
            for j=-m/2:m/2
                sum = sum+(I1(v(ind)+k,u(ind)+j)-I2(y+k,x+j));
            end
        end
        count=count+1;
        sumS(count,1) = sum;
        sumS(count,2) = x;
        sumS(count,3) = y;
    end
    [minVal,minInd] = min(sumS(:,1)); %#ok
    uC(ind) = sumS(minInd,2);
    vC(ind) = sumS(minInd,3);
end
if length(u)==1
    figure(fig_h1);hold on;plot(u,v,'b*','MarkerSize',12);hold off;
    figure(fig_h2);hold on;fplot(y2,[xmin xmax],'g','linewidth',1);hold off;xlim([xmin xmax]);ylim([ymin ymax]);
    figure(fig_h2);hold on;plot(uC,vC,'b*','MarkerSize',12);hold off;
end
