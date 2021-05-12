function imageMatrixN = RectPixels(imageMatrix,Q,Qn,uSize)
max_row = 4000;
max_col = 6000;
vSize = [1 7500]; %rows
vn = repelem((vSize(1):vSize(2))',uSize(2)-uSize(1)+1);
un = repmat((uSize(1):uSize(2))',vSize(2)-vSize(1)+1,1);
mult = 0:(1/64):1;len = round(length(un)*mult);lenDiff = diff(len);
indOrgTotal = numel(imageMatrix(:,:,1));
sizeO = size(imageMatrix(:,:,1));
imageMatrixN = zeros(vSize(2),uSize(2),3);
indNewTotal = numel(imageMatrixN(:,:,1));
sizeN = size(imageMatrixN(:,:,1));
for ind=1:length(len)-1
    st = len(ind)+1;en = len(ind+1);
    Pn = [un(st:en) vn(st:en) ones(lenDiff(ind),1)];
    P = ((Q/Qn)*Pn')';
    P = P./P(:,3);
    P = round(P);
    delRows = [find(P(:,1)>max_col);find(P(:,1)<=0);find(P(:,2)>max_row);find(P(:,2)<=0)];
    delRows = unique(delRows);
    P(delRows,:)=[];
    Pn(delRows,:)=[];
%     Pn(:,1) = Pn(:,1)-uSize(1)+1;
    indOrgR = sub2ind(sizeO,P(:,2),P(:,1));
    indOrgG = indOrgR+indOrgTotal;
    indOrgB = indOrgG+indOrgTotal;
    indNewR = sub2ind(sizeN,Pn(:,2),Pn(:,1));
    indNewG = indNewR+indNewTotal;
    indNewB = indNewG+indNewTotal;
    imageMatrixN(indNewR) = imageMatrix(indOrgR);
    imageMatrixN(indNewG) = imageMatrix(indOrgG);
    imageMatrixN(indNewB) = imageMatrix(indOrgB);
    clear Pn P delRows indOrgR indOrgG indOrgB indNewR indNewG indNewB;
end
imSt = find(any(imageMatrixN(:,:,1)),1);
imEnd = find(any(fliplr(imageMatrixN(:,:,1))),1);
imageMatrixN(:,1:imSt-1,:)=[];
imageMatrixN(:,end-imEnd+1:end,:)=[];
imageMatrixN = uint8(imageMatrixN);
figure;imagesc(imageMatrixN);axis('equal');
end