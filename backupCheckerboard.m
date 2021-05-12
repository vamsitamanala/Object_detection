clear all;close all;clc
I = checkerboard;
sizeRow = size(I,1);
sizeCol = size(I,2);
figure;imagesc(I);colormap('gray');title('Original Image');
xDerivSobel = [-1 0 1;-2 0 2;-1 0 1];
yDerivSobel = [1 2 1;0 0 0;-1 -2 -1];
Ix = conv2(I,xDerivSobel,'same');
Iy = conv2(I,yDerivSobel,'same');
figure;imagesc(Ix);colormap('gray');title('Ix');
figure;imagesc(Iy);colormap('gray');title('Iy');
Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;
R = zeros(size(I));
pxWind = 1;
for indRow = 1+pxWind:sizeRow-pxWind
    for indCol = 1+pxWind:sizeCol-pxWind
        Sx2 = sum(Ix2(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        Sy2 = sum(Iy2(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        Sxy = sum(Ixy(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        M = [Sx2 Sxy;Sxy Sy2];
        R(indRow,indCol) = det(M) - 0.04*(trace(M)^2); %change to 0.06
    end
end
figure;imagesc(R);title('Corner Response');colorbar;shg
Rlim = 100;
R(R<Rlim) = 0;
figure;imagesc(R);title('Points with R>Rlim');colormap('gray');colorbar;
rowPeaks = findPeaks(R,1,1);
colPeaks = findPeaks(rowPeaks,2,1);
finalPeaks = colPeaks;
[row,col] = ind2sub(size(I),find(finalPeaks));
figure;imagesc(I);title('Corner Points');colormap('gray')
hold on;plot(col,row,'g*','MarkerSize',10);shg;
return;