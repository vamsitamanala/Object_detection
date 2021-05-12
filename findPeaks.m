function peakVal = findPeaks(R,opt,Nval)
% opt=1 for row wise peaks
% opt=2 for column wise peaks
% Nval is minimum distance between peaks
peakVal = zeros(size(R));
riseFlag = 1;
sizeRow = size(R,1);
sizeCol = size(R,2);
if opt==1
    for indRow = 1:sizeRow
        peakInd = -inf;
        for indCol = 1:sizeCol-1
            oldVal = R(indRow,indCol);
            newVal = R(indRow,indCol+1);
            minDist = indCol-peakInd;
            if oldVal<newVal && minDist>Nval
                riseFlag = 1;
            end
            if newVal<oldVal && riseFlag == 1
                peakVal(indRow,indCol) = oldVal;
                riseFlag=0;
                peakInd = indCol;
            end
        end
    end
    figure;imagesc(peakVal);title('Row Peaks');colormap('gray');colorbar;
elseif opt==2
    for indCol = 1:sizeCol
        peakInd = -inf;
        for indRow = 1:sizeRow-1
            oldVal = R(indRow,indCol);
            newVal = R(indRow+1,indCol);
            minDist = indRow-peakInd;
            if oldVal<newVal && minDist>Nval
                riseFlag = 1;
            end
            if newVal<oldVal && riseFlag == 1
                peakVal(indRow,indCol) = oldVal;
                riseFlag=0;
                peakInd = indRow;
            end
        end
    end
    figure;imagesc(peakVal);title('Column Peaks');colormap('gray');colorbar;
end