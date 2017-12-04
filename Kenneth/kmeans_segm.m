function [ segmentation, centers, diffs ] = kmeans_segm(image, K, L, seed)

scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

image = imresize(image, scale_factor);
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
image = imfilter(image, h);

[img_dimx, img_dimy, layer] = size(image);
Ivec = single(reshape(image, img_dimx*img_dimy, layer));
rng(seed);

% Randomly initialize the K cluster centers
col_range = max(Ivec) - min(Ivec);
centers = single(zeros(K,layer));
for i = 1:K
    centers(i,:) = rand()*(col_range/K) + (i-1)*col_range/K + min(Ivec);
end

dist = pdist2(Ivec, centers, 'euclidean');
diffs = sum(sum(dist));
for i = 1:L
% Iterate L times
	% Assign each pixel to the cluster center for which the distance is minimum
	[~,index] = min(dist');
	% Recompute each cluster center by taking the mean of all pixels assigned to it
	for j = 1:K
		centers(j, :) = mean(Ivec(index == j, :), 1);
	end
	% Recompute all distances between pixels and cluster centers
	dist = pdist2(Ivec, centers, 'euclidean');
    diffs = [diffs sum(sum(dist))];
end

[~,index] = min(dist');
segmentation = reshape(index, img_dimx, img_dimy);

%{
% To show the convergence
plot(1:size(diffs,2),log(diffs)); title('Difference of pixels to centers');
ylabel('Log(total sum of all distances)'); xlabel('Iteration');
%}
