% function FeatureMatching(imageMatrix, points)
% use luminance Y = .2126 * R^gamma + .7152 * G^gamma + .0722 * B^gamma to match
clear all;close all;clc
load hammerRefPoints;
pointsRef = hammerRefPoints;
numPointsRef = length(pointsRef);
imageMatrix1 = imread('FinImage2Hammer.jpg','jpg');
imageMatrix = imageMatrix1;
I = double(imageMatrix);
imageMatrixRef = imread('Image2Hammer.jpg','jpg');
figure;imagesc(imageMatrixRef);title('Reference Image');
hold on;plot(pointsRef(:,1),pointsRef(:,2),'g*','MarkerSize',10);shg;
Iref = double(imageMatrixRef);
points = identifyCorners(imageMatrix,400,5);
numPoints = length(points);
intDiff = zeros(numPoints,1);
for ind=1:numPoints
    rowVal = points(ind,2);
    colVal = points(ind,1);
    tempDiff = zeros(numPointsRef,1);
    for indRef=1:length(pointsRef)
        rowValRef = pointsRef(indRef,2);
        colValRef = pointsRef(indRef,1);
        
        diffR = (Iref(rowValRef,colValRef,1) - I(rowVal,colVal,1))^2;
        diffG = (Iref(rowValRef,colValRef,2) - I(rowVal,colVal,2))^2;
        diffB = (Iref(rowValRef,colValRef,3) - I(rowVal,colVal,3))^2;
        
        
        tempDiff(indRef) = diffR+diffG+diffB;
        if tempDiff(indRef)==0
            a=1;
        end
    end
    [minVal,minInd] = min(tempDiff);
    intDiff(ind,1)=minVal;
    intDiff(ind,2)=minInd;
    intDiff(ind,3)=ind;
end
intDiff(intDiff(:,1)>9)=0;
pSelTemp = intDiff((intDiff(:,1)>0),:);
pSelTest = pSelTemp(:,3);
pSelRef = pSelTemp(:,2);
imageMatrixRefTemp = imageMatrixRef(1:1685,1:2380,:);
imageMatrixTemp = padarray(imageMatrix,[125 470]);
tempMatrix = [imageMatrixRefTemp imageMatrixTemp];
figure;imagesc(tempMatrix);title('Matched Features');
hold on;
for ind=1:length(pSelTest)
    plot(pointsRef(ind,1),pointsRef(ind,2),'g*','MarkerSize',10);shg;
end
hold on;plot(pointsRef(pSelRef,1),pointsRef(pSelRef,2),'g*','MarkerSize',10);shg;
subplot(122);imagesc(imageMatrix);title('Test Image');
hold on;plot(points(pSelTest,1),points(pSelTest,2),'g*','MarkerSize',10);shg;

return;






figure;imagesc(imageMatrix);axis('equal');
%% Hammer Base
imageMatrixD = double(imageMatrix);
imageMatrixRefD = double(imageMatrixRef);
imageMatrixG = (imageMatrixD(:,:,1).*0.2989)+(imageMatrixD(:,:,2).*0.5870)+(imageMatrixD(:,:,3).*0.1140);
imageMatrixRefG = (imageMatrixRefD(:,:,1).*0.2989)+(imageMatrixRefD(:,:,2).*0.5870)+(imageMatrixRefD(:,:,3).*0.1140);
I1 = imageMatrixRefG;
I2 = imageMatrixG;
searchWindow = 50;
% points = [5826 1976];
totalPoints = size(points,1);
intDiff = zeros(totalPoints,1);
count = 0;
for ind = 1:totalPoints
    count=count+1;
    for k=-searchWindow:searchWindow
        for j=-searchWindow:searchWindow
            if points(ind,2)+j<=4000 && points(ind,2)+j>0 && points(ind,1)+k<=6000 && points(ind,1)+k>0
                intDiff(count) = intDiff(count)+(I1(hammerBasePointRef(2)+j,hammerBasePointRef(1)+k) - I2(points(ind,2)+j,points(ind,1)+k))^2;
            end
        end
    end
end
vRlim = 1500; %threshold for R
Nval = 5; %minimum distance between peaks
imageMatrix1 = imread('FinImage2Hammer.jpg','jpg');
% [~,indSort] = sort(intDiff);
% pointsInd = indSort(1:1);

% hammerBasePoints = [points(pointsInd,1) points(pointsInd,2)];
[minVal, minInd] = min(intDiff);
hammerBasePoints = [points(minInd,1) points(minInd,2)];
hold on;plot(hammerBasePointRef(:,1),hammerBasePointRef(:,2),'g*','MarkerSize',12);shg;
plot(hammerBasePoints(:,1),hammerBasePoints(:,2),'b*','MarkerSize',12);shg;
rectangle('Position',[hammerBasePoints(1)-searchWindow hammerBasePoints(2)-searchWindow 2*searchWindow 2*searchWindow],'EdgeColor','r');shg
rectangle('Position',[hammerBasePointRef(1)-searchWindow hammerBasePointRef(2)-searchWindow 2*searchWindow 2*searchWindow],'EdgeColor','r');shg

%         
% imageMatrixG
% for indHRow=1:size(hammerBaseColor(:,:,1),1)
%     for indHCol=1:size(hammerBaseColor(:,:,1),2)
%         
%     end
% end
% 


% imageMatrixGray = double(rgb2gray(imageMatrix));
% hammerBaseGray = double(rgb2gray(hammerBaseColor));
% hammerBaseColorR = mean(hammerBaseColorDouble(:,:,1),'all');
% hammerBaseColorG = mean(hammerBaseColorDouble(:,:,2),'all');
% hammerBaseColorB = mean(hammerBaseColorDouble(:,:,3),'all');
% hammerBaseColorR = mean(hammerBaseColorDouble(1,2,1),'all');
% hammerBaseColorG = mean(hammerBaseColorDouble(1,2,2),'all');
% hammerBaseColorB = mean(hammerBaseColorDouble(1,2,3),'all');
% count=0;
% sum=0;
% IntDiff = zeros(numel(hammerBaseColor(:,:,1)),1);
% for indHR=1:size(hammerBaseColor(:,:,1),1)
%     for indHC=1:size(hammerBaseColor(:,:,1),2)
%         count=count+1;
%         hammerBaseColorR = hammerBaseD(indHR,indHC,1);
%         hammerBaseColorG = hammerBaseD(indHR,indHC,2);
%         hammerBaseColorB = hammerBaseD(indHR,indHC,3);
%         %         hammerBaseColorR = hammerBaseGray(indHR,indHC,1);
%         IntDiff(count) = inf;
%         for ind=1:length(points)
%             diffR = (hammerBaseColorR-imageMatrixD(points(ind,2),points(ind,1),1))^2;
%             diffG = (hammerBaseColorG-imageMatrixD(points(ind,2),points(ind,1),2))^2;
%             diffB = (hammerBaseColorB-imageMatrixD(points(ind,2),points(ind,1),3))^2;
%             diffR = (hammerBaseColorR-imageMatrixGray(points(ind,2),points(ind,1),1))^2;
%             IntDiffTemp = diffR+diffG+diffB;
%             %             IntDiffTemp = diffR;
%             if IntDiffTemp==0
%                 disp('check');
%             end
%             if IntDiffTemp<IntDiff(count)
%                 IntDiff(count) = IntDiffTemp;
%             end
%         end
%     end
% end
% % [minVal, minInd] = min(IntDiff);
% [~,indSort] = sort(IntDiff);
% pointsInd = indSort(1:10);
% % hammeBasePoints = [points(minInd,1) points(minInd,2)];
% hammeBasePoints = [points(pointsInd,1) points(pointsInd,2)];
% hold on;plot(hammeBasePoints(:,1),hammeBasePoints(:,2),'b*','MarkerSize',12);shg;
% % end