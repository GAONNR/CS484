image1 = imread('RISHLibrary1.jpg');
image2 = imread('LaddObservatory2.jpg');
C = corner(rgb2gray(image2), 1000);
imshow(image2);
hold on
plot(C(:,1),C(:,2),'r*');