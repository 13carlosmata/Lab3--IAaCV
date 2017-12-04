%{
Kenneth Lau K.W.- Lab3
Image Analysis and Computer Vision - DD2423
Image Segmentation
%}

addpath('../../DD2423_Lab_Files/Functions');
addpath('../../DD2423_Lab_Files/Images-m');
addpath('../bildat_lab3');

close all;


%%  2 K-means clustering

image = imread('orange.jpg');

K = 20;
L = 50;
seed = 14;

[segmentation, centers] = kmeans_segm(image, K, L, seed);
figure
imshow(mean_segments(image, segmentation));
% imshow(overlay_bounds(image, segmentation));