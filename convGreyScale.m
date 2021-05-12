function I = convGreyScale(Im)
Im = double(Im);
% I = (Im(:,:,1).^2+Im(:,:,2).^2+Im(:,:,3).^2)./9;
I = (Im(:,:,1)+Im(:,:,2)+Im(:,:,3))./3;
% I = uint8(I);
end