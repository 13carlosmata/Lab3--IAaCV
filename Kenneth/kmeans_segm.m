function [ segmentation, centers ] = kmeans_segm(image, K, L, seed)

[height, width, depth] = size(image);
Ivec = single(reshape(image, height*width, depth));
rng(seed);

% Randomly initialize the K cluster centers
color_range = max(Ivec) - min(Ivec);
centers = single(zeros(K,depth));
for i = 1:K
    centers(i,:) = rand()*(color_range/K) + (i-1)*color_range/K + min(Ivec);
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
segmentation = reshape(index, height, width);

%{
% To show the convergence
plot(1:size(diffs,2),log(diffs)); title('Difference of pixels to centers');
ylabel('Log(total sum of all distances)'); xlabel('Iteration');
%}
