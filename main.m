%{
Lab 3 - Image Analysis and Computer Vision
    Carlos Mata
    Kenneth Lau
%}
clear all 
close all 
%clc

addpath('DD2423_Lab_Files/Functions');
addpath('DD2423_Lab_Files/Images-m');

addpath('bildat_lab3');


%% Questoin 1
% --> from kmeans_example.m

K = 6;               % number of clusters used
L = 20;              % number of iterations
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
I_o = overlay_bounds(Iback, segm);
figure;
subplot(1,3,1)
imshow(Iback)
subplot(1,3,2)
imshow(Inew);
subplot(1,3,3)
imshow(I_o);

[segm6,centers6] = kmeans_segm(I, 6, L, seed);



%% Quesion 2
L_r = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50];
A = [];
B = [];
C = [];
for i=1:size(L_r,2)
    [segm,centers] = kmeans_segm(I, K, L_r(i), seed);
    a = mean(centers(1));
    b = mean(centers(2));
    c = mean(centers(3));
    A = [A;a];
    B = [B;b];
    C = [C;c];
end


figure
subplot(1,3,1); plot(L_r,A);
subplot(1,3,2); plot(L_r,B);
subplot(1,3,3); plot(L_r,C);
suptitle('Changes on the convergence with different L values')
%% Question 3

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

K_r = [5,6];
figure
subplot(1,3,1)
imshow(Iback)
title('Original');
for i=1:size(K_r,2)
    [segm,centers] = kmeans_segm(I, K_r(i), L, seed);
    I_o = overlay_bounds(Iback, segm);
    subplot(1,3,i+1);
    imshow(I_o);
    title(['K: ', int2str(K_r(i))]);
end


Inew = mean_segments(Iback, segm);
I_o = overlay_bounds(Iback, segm);
figure;
subplot(1,3,1)
imshow(Iback)
subplot(1,3,2)
imshow(Inew);
subplot(1,3,3)
imshow(I_o);

%% Quesion 4

I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

K = 6;
L = 15;
[segm,centers] = kmeans_segm(I, K, L, seed);
Inew = mean_segments(Iback, segm);
I_o = overlay_bounds(Iback, segm);

figure;
subplot(1,3,1)
imshow(Iback)
subplot(1,3,2)
imshow(Inew);
subplot(1,3,3)
imshow(I_o);
suptitle(['Tiger1 - K: ',int2str(K),' - L: ', int2str(L)])

%%      Question 5 and 6
S_BW = [4,8,15];
C_BW = [2,15];

I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);
figure
ind = 1;
for i=1:size(S_BW,2)
    for j=1:size(C_BW,2)
        segm = mean_shift_segm(I, S_BW(i), C_BW(j), 20);  
        Inew = mean_segments(Iback, segm);
        I_o = overlay_bounds(Iback, segm);
        subplot(3,4,ind)
        imshow(Inew);
        title(['S: ', int2str(S_BW(i)), ' C: ', int2str(C_BW(j))]);
        ind = ind+1;
        subplot(3,4,ind);
        imshow(I_o);
        title(['S: ', int2str(S_BW(i)), ' C: ', int2str(C_BW(j))]);
        ind = ind + 1;
    end  
end

%%  Question 7

colour_bandwidth = 20; % color bandwidth
radius = 6;              % maximum neighbourhood distance
ncuts_thresh = 0.2;      % cutting threshold
min_area = 200;          % minimum area of segment
max_depth = 8;           % maximum splitting depth
scale_factor = 0.4;      % image downscale factor
image_sigma = 2.0;       % image preblurring scale

I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);
%%
rango = [2,6,12,20];
ind = 1;figure;
for i=1:size(rango,2)
    segm = norm_cuts_segm(I,colour_bandwidth , rango(i), ncuts_thresh, min_area, max_depth);
    Inew = mean_segments(Iback, segm);
    Io = overlay_bounds(Iback, segm);
    subplot(2,4,ind);
    ind = ind+1;
    imshow(Inew)
    subplot(2,4,ind)
    ind = ind+1;
    imshow(Io);
    title(int2str(rango(i)));
end

%%

colour_bandwidth = 11; % color bandwidth
radius = 10;              % maximum neighbourhood distance
ncuts_thresh = 0.2;      % cutting threshold
min_area = 200;          % minimum area of segment
max_depth = 8;           

segm = norm_cuts_segm(I,colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
Io = overlay_bounds(Iback, segm);

figure
subplot(1,2,1);
imshow(Inew)
subplot(1,2,2)
imshow(Io);
suptitle(['tiger2 - radius: ', int2str(radius),' - Cbw: ', int2str(colour_bandwidth), '- TH: ', num2str(ncuts_thresh),' - Area: ', num2str(min_area), ' - Depth: ', num2str(max_depth)])

%% 



