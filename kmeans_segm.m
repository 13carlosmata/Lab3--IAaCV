function [ segmentation, centers ] = kmeans_segm(image, K, L, seed)
%Converting into 2D arrays
[height,width,dim] = size(image);
Ivec = reshape(image,width*height, dim);

% Randomly initialize the K cluster centers
range = max(Ivec)-min(Ivec);
centers = zeros(K,dim);

for i=1:K
    centers(i,:) = rand()*(range/K) + (i-1)*range/K + min(Ivec);
end

% Compute all distances between pixels and cluster centers
distance = pdist2(single(Ivec),single(centers));    %Avoiding convertion to doubles

% Iterate L times
for i=1:L  
    % Assign each pixel to the cluster center for which the distance is minimum
    [~,index] = min(distance');
    % Recompute each cluster center by taking the mean of all pixels assigned to it
    for ii=1:K
        centers(ii,:) = mean(Ivec(index==ii,:),1);
    end
    % Recompute all distances between pixels and cluster centers
    distance = pdist2(single(Ivec),single(centers));   
end
[~,index] = min(distance');
segmentation = reshape(index,height,width);
end