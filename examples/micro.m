clear all;
numSpots = 7744;
spotSize = 16*16;
Xoffset=920;
Yoffset=18640;
sgma_obj = sgma;
ker = poly_dot;

thumbs = zeros(16,16,numSpots);
dataset = zeros(spotSize,numSpots);
m = dlmread('Slide40.txt','\t');
X=m(:,1);
Y=m(:,2);

X = X - Xoffset*ones(size(X));
Y = Y - Yoffset*ones(size(Y));

pic = imread('slide40_532_nm.tif','tiff');

Y=floor(Y/10); %compensate for 10nm/pixel
X=floor(X/10); 

refimg=zeros(size(pic));
figure(3);
colormap(hot);

% extract spots from image
for j=1:size(Y,1),
   thumbs(:,:,j) = pic(Y(j)-7:Y(j)+8,X(j)-7:X(j)+8);
   refimg(Y(j),X(j)) = 6500;
   pic(Y(j),X(j)) = 0;
   dataset(:,j) = reshape(thumbs(:,:,j),spotSize,1);
   %pause(.03);
   %image(thumbs(:,:,j));
end

%perform SGMA

[T,basisvecsindex,error_sequence,trace_K] = train(sgma_obj,ker, dataset);
for i=1:9,
	subplot(3,3,i);
	image(thumbs(:,:,basisvecsindex(i)));
end

%range = [100:500];
%pic = pic(range,range);
%refimg = refimg(range,range);

figure(1)
colormap(gray)
image(pic)
%figure(2)
%colormap(hot)
%image(refimg)

