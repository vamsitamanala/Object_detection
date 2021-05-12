  clear all;close all;clc; %#ok
%% Options
optPlotOrig = 1;
optEpiOrig = 1;
optCalcPPM = 1;
optCalcRectPPM = 1;
optPlotRectCord = 1;
optRectPixels = 0;
optEpiRect = 0;
optIdentCorners = 0;
optFeatMatch = 0;
%% Reading Image
imageMatrix1 = imread('FinImage1.JPG');
imageMatrix2 = imread('FinImage2.JPG');
if optPlotOrig
    figure;imagesc(imageMatrix1);axis('equal');fig_h1 = gcf;title('Original Image 1');
    figure;imagesc(imageMatrix2);axis('equal');fig_h2 = gcf;title('Original Image 2');
end
%% Initializing Data
load coins;
val = 8;
u1 = u1(1:val);v1 = v1(1:val);u2 = u2(1:val);v2 = v2(1:val);
coins_w = [47 429 0;245 346 0;350 206 0;106 112 0;228 -140 60;112 -175 60;84 -290 100;220 -360 100].*1e-3;
%% Calculating Epipolar Lines on Original Images
if optEpiOrig
    F = EpipolarLines(u1,v1,u2,v2,imageMatrix1,imageMatrix2,0);
end
%% Calculating PPM
if optCalcPPM
    M1 = PPM(coins_w,u1,v1);
    M2 = PPM(coins_w,u2,v2);
    PPMerror1 = testPPM(M1,coins_w,u1,v1)
    PPMerror2 = testPPM(M2,coins_w,u2,v2) 
    [K1,R1,O1,pPoint1] = KRO_PPM(M1);
    [K2,R2,O2,pPoint2] = KRO_PPM(M2);
end
%% Calculating Rectified PPM
if optCalcRectPPM
    Kn = (K1+K2)./2;
    Kn(1,2)=0;
    Kn(1,3) = Kn(1,3)+0.2;
    Xn = O1-O2;
    Yn = cross(R1(3,:)',Xn);
    Zn = cross(Xn,Yn);
    Rn = [Xn'/norm(Xn);Yn'/norm(Yn);Zn'/norm(Zn)];
    Qn = Kn*Rn;
    Q1 = K1*R1;Q2 = K2*R2;
    M1n = (Qn/Q1)*M1;
    M2n = (Qn/Q2)*M2;
    [K1n,R1n,O1n,pPoint1n] = KRO_PPM(M1n);
    [K2n,R2n,O2n,pPoint2n] = KRO_PPM(M2n);
end
%% Plotting Cordinate Systems
if optPlotRectCord
    figure;fig_h=gcf;
    plotCordSys(O1,R1,fig_h,'-');
    plotCordSys(O2,R2,fig_h,'-');
    plotCordSys(O1n,R1n,fig_h,'--');
    plotCordSys(O2n,R2n,fig_h,'--');
    figure(fig_h);hold on;plot3(coins_w(:,1),coins_w(:,2),coins_w(:,3),'ko','MarkerSize',12);hold off 
end
%% Calculating Rectified Pixels
if optRectPixels
    imageMatrix1n = RectPixels(imageMatrix1,Q1,Qn,[1 11].*1e3);
    imageMatrix2n = RectPixels(imageMatrix2,Q2,Qn,[1 11].*1e3);
end
%% Calculating Epipolar Lines on Rectified Images
%if optEpiRect
    %[u1_rect,v1_rect] = RectPoints(u1(1:8),v1(1:8),Q1,Qn,0);
    %[u2_rect,v2_rect] = RectPoints(u2(1:8),v2(1:8),Q2,Qn,0);
%     rowDiff = v1_rect-v2_rect
    %F = EpipolarLines(u1,v1,u2,v2,imageMatrix1n,imageMatrix2n,0);
%end
%% Identifying Corners
%if optIdentCorners
   % points = identifyCorners(imageMatrix1);
%end
%% Feature Matching
if optFeatMatch
    FeatureMatching(imageMatrix1, points)
end
%% Stereo Matching
% if 0
% %     window=80;figure(fig_h1);shg;[u,v]=ginput(1);
%     u = u1_rect(5);v = v1_rect(5);
%     [uC,vC] = stereoMatch(u,v,imageMatrix1n,imageMatrix2n,F,fig_h1,fig_h2);
%     dispar = u-uC;
% end
%  3D Reconstruction
 if 1
     coinNum = 2;
     P1 = [u1(coinNum) v1(coinNum) 1]';
     P2 = [u2(coinNum) v2(coinNum) 1]';
     PWTest = coins_w(coinNum,:)'.*1e3;
     PW = calc3DRecon(P1,P2,M1,M2);PW = PW.*1e3;
     error3DRecon = PWTest-PW 
 end