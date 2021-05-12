function points = identifyCorners(imageMatrix,Rlim,Nval)
%change im2double function
% chage rgb2gay function

figure;imagesc(imageMatrix);title('Test Image');
imageMatrixG = rgb2gray(imageMatrix);
figure;imagesc(imageMatrixG);colormap('gray');title('Grayscale Image');

gFilt = fspecial('gaussian',9,3);
imageMatrixBlur = conv2(imageMatrixG,gFilt,'same');
figure;imagesc(imageMatrixBlur);colormap('gray');title('Blur Image');

imageMatrixB = edge(imageMatrixBlur,'sobel'); %do it without the matlab function, using the filter directly
figure;imagesc(imageMatrixB);colormap('gray');title('Sobel Edge Detection');




I = im2double(imageMatrixB);
xDerivSobel = [-1 0 1;-2 0 2;-1 0 1];
yDerivSobel = [1 2 1;0 0 0;-1 -2 -1];
Ix = conv2(I,xDerivSobel,'same');
Iy = conv2(I,yDerivSobel,'same');
orI = atan2(Iy,Ix);
figure;imagesc(Ix);colormap('gray');title('Ix');
figure;imagesc(Iy);colormap('gray');title('Iy');
Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;
sizeRow = size(I,1);
sizeCol = size(I,2);
R = zeros(size(I));
pxWind = 1;
for indRow = 1+pxWind:sizeRow-pxWind
    for indCol = 1+pxWind:sizeCol-pxWind
        Sx2 = sum(Ix2(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        Sy2 = sum(Iy2(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        Sxy = sum(Ixy(indRow-pxWind:indRow+pxWind,indCol-pxWind:indCol+pxWind),'all');
        M = [Sx2 Sxy;Sxy Sy2];
        R(indRow,indCol) = det(M) - 0.04*(trace(M)^2);
    end
end
figure;imagesc(R);title('Corner Response');colorbar;shg;
Rnew = R;
Rnew(Rnew<Rlim) = 0;
figure;imagesc(Rnew);title('Points with R>Rlim');colormap('gray');colorbar;
rowPeaks = findPeaks(Rnew,1,Nval);
colPeaks = findPeaks(rowPeaks,2,Nval);
finalPeaks = colPeaks;
indFinalPeaks = find(finalPeaks);
[row,col] = ind2sub(size(I),indFinalPeaks);
pxOrnt = zeros(size(I));
pxOrnt(indFinalPeaks) = orI(indFinalPeaks);
figure;imagesc(imageMatrix);title('Corner Points');
hold on;plot(col,row,'g*','MarkerSize',10);shg;
points = [col row];