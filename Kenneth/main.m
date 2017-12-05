%{
Kenneth Lau K.W.- Lab3
Image Analysis and Computer Vision - DD2423
Image Segmentation
%}

addpath('../../DD2423_Lab_Files/Functions');
addpath('../bildat_lab3');

close all;


%%  2 K-means clustering
% Question 1 ,2, 3, 4

K = 6;               % number of clusters used
L = 50;              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

[segm, centers] = kmeans_segm(I, K, L, seed);
figure
subplot(1,2,1); imshow(mean_segments(Iback, segm));
subplot(1,2,2); imshow(overlay_bounds(Iback, segm));
pause;

%% 3 Mean-shift segmentation
% Question 5, 6

scale_factor = 0.5;       % image downscale factor
spatial_bandwidth = 5.0;  % spatial bandwidth
colour_bandwidth = 5.0;   % colour bandwidth
num_iterations = 40;      % number of mean-shift iterations
image_sigma = 1.0;        % image preblurring scale

I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = mean_shift_segm(I, spatial_bandwidth, colour_bandwidth, num_iterations);

figure
subplot(1,2,1); imshow(mean_segments(Iback, segm));
subplot(1,2,2); imshow(overlay_bounds(Iback, segm));
pause;

%% 4 Normalized Cut
% Question 5, 6

colour_bandwidth = 15.0; % color bandwidth
radius = 10;              % maximum neighbourhood distance
ncuts_thresh = 0.2;      % cutting threshold
min_area = 200;          % minimum area of segment
max_depth = 8;           % maximum splitting depth
scale_factor = 0.4;      % image downscale factor
image_sigma = 2.0;       % image preblurring scale

I = imread('tiger2.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
subplot(1,2,1); imshow(mean_segments(Iback, segm));
subplot(1,2,2); imshow(overlay_bounds(Iback, segm));

%% 5 Segmentation using graph cuts

scale_factor = 0.5;          % image downscale factor
area = [ 80, 110, 570, 300 ]; % image region to train foreground with
K = 16;                      % number of mixture components
alpha = 8.0;                 % maximum edge cost
sigma = 10.0;                % edge cost decay factor

I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
area = int16(area*scale_factor);
[ segm, prior ] = graphcut_segm(I, area, K, alpha, sigma);

Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);
subplot(2,2,1); imshow(Inew);
subplot(2,2,2); imshow(I);
subplot(2,2,3); imshow(prior);
