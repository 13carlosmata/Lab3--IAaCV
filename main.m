%{
Lab 3 - Image Analysis and Computer Vision
    Carlos Mata
    Kenneth Lau
%}
addpath('DD2423_Lab_Files/Functions');
addpath('DD2423_Lab_Files/Images-m');

addpath('bildat_lab3');


% --> from kmeans_example.m

K = 8;               % number of clusters used
L = 10;              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

[segm,centers] = kmeans_segm(I, K, L, seed);

Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

figure;
subplot(1,3,1)
imshow(Iback)
subplot(1,3,2)
imshow(Inew);
subplot(1,3,3)
imshow(I)

%imwrite(Inew,'result/kmeans1.png')
%imwrite(I,'result/kmeans2.png')