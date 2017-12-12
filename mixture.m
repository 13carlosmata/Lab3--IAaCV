function prob = mixture prob(image, K, L, mask)
% Let I be a set of pixels and V be a set of K Gaussian components in 3D (R,G,B).
V = [];
weights = [];
[ height_i, width_i, depth_i ] = size(I);
[ height_m, width_m, depth_m ] = size(mask);
Ivec = reshape(I, height_i*width_i, depth_i);
maskvec = reshape(mask, height_m*width_m, depth_m);

% Store all pixels for which mask=1 in a Nx3 matrix
for i=1:size(Ivec,1)
    if maskvec(i)==1
        weights = [weights;Ivec(i,:)];        
    end
end

% Randomly initialize the K components using masked pixels
range = max(Ivec) - min(Ivec);
mean = zeros(K,size(I,3));
cov=cell(K,1);

for i=1:K
    mean(i,:) = rand()*(range/K) + (i-1)*range/K + min(Ivec);
end

% Iterate L times

for j=1:L
% Expectation: Compute probabilities P_ik using masked pixels
    for i=1:K
        diff = bsxfun(@minus, weights, mean(i,:));
        g_1 = 1 /sqrt((2*pi)^3 * det(cov{i}));
        g_2 = exp(-0.5*sum((diff'.*cov{i}\diff'),1));
        g_k(i,:) = g_1.*g_2;
        p_1(i,:) = weights(i).*g_k(i,:);
    end
    for i=1:k
        p_ik(i,:) = p_1(k)./sum(p_1,1);
    end
    % Maximization: Update weights, means and covariances using masked pixels    
    for i=1:k
        centers(i,:) = sum(bsxfun(@times,p_ik(i,:)',mask_pixels),1)/sum(p_ik(i,:),2);
        w_k(i )= sum(p_ik(i,:),2)./size(p_ik,2);
        mean(i,:) = sum(p_ik(i,:),2.*maskvec)/sum(p_ik(i,:),2);
        diff = bsxfun(@minus,maskvec,mean(i,:));
        covariance{i} = bsxfun(@times,diff,p_ik(i,:)')'*diff/sum(p_ik(i,:),2);
    end    
end

% Compute probabilities p(c_i) in Eq.(3) for all pixels I.
for i=1:K
    diff = bsxfun(@minus, Ivec, mean(i,:));
    g_1 = 1 /sqrt((2*pi)^3 * det(cov{i}));
    g_2 = exp(-0.5*sum((diff'.*cov{i}\diff'),1));
    g_k(i,:) = g_1.*g_2;
    p_1(i,:) = weights(i).*g_k(i,:);
end
prob = sum(p_1,1);

end