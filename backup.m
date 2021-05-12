% imageMatrixGray = double(rgb2gray(imageMatrix));
% hammerBaseGray = double(rgb2gray(hammerBaseColor));
% hammerBaseColorR = mean(hammerBaseColorDouble(:,:,1),'all');
% hammerBaseColorG = mean(hammerBaseColorDouble(:,:,2),'all');
% hammerBaseColorB = mean(hammerBaseColorDouble(:,:,3),'all');
% hammerBaseColorR = mean(hammerBaseColorDouble(1,2,1),'all');
% hammerBaseColorG = mean(hammerBaseColorDouble(1,2,2),'all');
% hammerBaseColorB = mean(hammerBaseColorDouble(1,2,3),'all');
count=0;
sum=0;
IntDiff = zeros(numel(hammerBaseColor(:,:,1)),1);
for indHR=1:size(hammerBaseColor(:,:,1),1)
    for indHC=1:size(hammerBaseColor(:,:,1),2)
        count=count+1;
        hammerBaseColorR = hammerBaseColorDouble(indHR,indHC,1);
        hammerBaseColorG = hammerBaseColorDouble(indHR,indHC,2);
        hammerBaseColorB = hammerBaseColorDouble(indHR,indHC,3);
        %         hammerBaseColorR = hammerBaseGray(indHR,indHC,1);
        IntDiff(count) = inf;
        for ind=1:length(points)
            diffR = (hammerBaseColorR-imageMatrixDouble(points(ind,2),points(ind,1),1))^2;
            diffG = (hammerBaseColorG-imageMatrixDouble(points(ind,2),points(ind,1),2))^2;
            diffB = (hammerBaseColorB-imageMatrixDouble(points(ind,2),points(ind,1),3))^2;
            diffR = (hammerBaseColorR-imageMatrixGray(points(ind,2),points(ind,1),1))^2;
            IntDiffTemp = diffR+diffG+diffB;
            %             IntDiffTemp = diffR;
            if IntDiffTemp==0
                disp('check');
            end
            if IntDiffTemp<IntDiff(count)
                IntDiff(count) = IntDiffTemp;
            end
        end
    end
end
% [minVal, minInd] = min(IntDiff);
[~,indSort] = sort(IntDiff);
pointsInd = indSort(1:10);
% hammeBasePoints = [points(minInd,1) points(minInd,2)];
hammeBasePoints = [points(pointsInd,1) points(pointsInd,2)];
hold on;plot(hammeBasePoints(:,1),hammeBasePoints(:,2),'b*','MarkerSize',12);shg;
% end





