function F = EpipolarLines(u1,v1,u2,v2,imageMatrix1,imageMatrix2,opt)
size1 = size(imageMatrix1(:,:,1));
size2 = size(imageMatrix2(:,:,1));
len = length(u1);
P1 = [u1 v1 ones(len,1)];
P2 = [u2 v2 ones(len,1)];
u1_bar = sum(u1)/len; u2_bar = sum(u2)/len;
v1_bar = sum(v1)/len; v2_bar = sum(v2)/len;
s1 = sqrt(2)/((sum(sqrt(((u1-u1_bar).^2)+((v1-v1_bar).^2))))*(1/len));
s2 = sqrt(2)/((sum(sqrt(((u2-u2_bar).^2)+((v2-v2_bar).^2))))*(1/len));
gamma1 = [s1 0 -s1*u1_bar;0 s1 -s1*v1_bar;0 0 1];
gamma2 = [s2 0 -s2*u2_bar;0 s2 -s2*v2_bar;0 0 1];
P1_norm = (gamma1*P1')';
P2_norm = (gamma2*P2')';
u1_tilda = P1_norm(:,1); u2_tilda = P2_norm(:,1);
v1_tilda = P1_norm(:,2); v2_tilda = P2_norm(:,2);
Y_norm = [u1_tilda.*u2_tilda u1_tilda.*v2_tilda u1_tilda v1_tilda.*u2_tilda v1_tilda.*v2_tilda v1_tilda u2_tilda v2_tilda ones(len,1)];
[~,~,Vy] = svd(Y_norm);
F_norm = Vy(:,end);
F_norm = [F_norm(1:3)';F_norm(4:6)';F_norm(7:9)'];
[Uf,Sf,Vf] = svd(F_norm);
Sf(3,3) = 0;
F_star = Uf*Sf*Vf';
F = gamma1'*F_star*gamma2;
a1 = (F*P2')';
a2 = (F'*P1')';
if opt
    cols = {'g','m','b','r'};
    colours = (repmat(cols',ceil(len/4),1))';
    xmin1 = 1;xmax1 = size1(2);ymin1 = 1;ymax1 = size1(1);
    xmin2 = 1;xmax2 = size2(2);ymin2 = 1;ymax2 = size2(1);
    figure;imagesc(imageMatrix1);axis('equal');fig_h1 = gcf;title('Epipolar Lines Image 1');
    figure;imagesc(imageMatrix2);axis('equal');fig_h2 = gcf;title('Epipolar Lines Image 2');
    for ind = 1:len
        y1 = @(x1) -(a1(ind,1)*x1/a1(ind,2)) - (a1(ind,3)/a1(ind,2));
        figure(fig_h1);hold on;plot(u1(ind),v1(ind),[colours{ind} '+'],'linewidth',2,'MarkerSize',15);hold off;axis([xmin1 xmax1 ymin1 ymax1]);
        figure(fig_h1);hold on;fplot(y1,[xmin1 xmax1],colours{ind},'linewidth',2);hold off;axis([xmin1 xmax1 ymin1 ymax1]);
        error1(ind) = (((y1(u1(ind)))-v1(ind))/v1(ind))*100; %#ok
        
        y2 = @(x2) -(a2(ind,1)*x2/a2(ind,2)) - (a2(ind,3)/a2(ind,2));
        figure(fig_h2);hold on;plot(u2(ind),v2(ind),[colours{ind} '+'],'linewidth',2,'MarkerSize',15);hold off;axis([xmin2 xmax2 ymin2 ymax2]);
        figure(fig_h2);hold on;fplot(y2,[xmin2 xmax2],colours{ind},'linewidth',2);hold off;axis([xmin2 xmax2 ymin2 ymax2]);
        error2(ind) = (((y2(u2(ind)))-v2(ind))/v2(ind))*100; %#ok
    end
%     error1 %#ok
%     error2 %#ok
end