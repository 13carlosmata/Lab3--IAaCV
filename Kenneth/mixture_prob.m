function prob = mixture_prob(I, K, L, mask)
% I be a set of pixels from the image
% Let V be a set of K Gaussian components in 3D (R,G,B)
% Set up the mask pixels
V = [];
mask_pixels = [];
Ivec = single(reshape(I, size(I,1)*size(I,2), 3));

%  Store all pixels for which mask=1 in a Nx3 matrix
mask = single(reshape(mask, size(mask,1)*size(mask,2), 1));
for i = 1:size(Ivec,1)
    if mask(i) ~= 0
        mask_pixels = [mask_pixels; Ivec(i,:)];
    end
end

%  Randomly initialize the K components using masked pixels
%  i.e. the means (same as kmean segmentation)
color_range = max(Ivec) - min(Ivec);
centers = single(zeros(K,size(I,3)));
for i = 1:K
    centers(i,:) = rand()*(color_range/K) + (i-1)*color_range/K + min(Ivec);
end
%  i.e. the convariance, and omega(w)
covariance = cell(K,1);
ran_covariance = cov(mask_pixels);
omega = rand(1, K);
omega = omega / sum(omega);
for i=1:K
    covariance{i} = ran_covariance;
end

%  Iterate L times for expectation-maximization
for iteration = 1:L
%     Expectation: Compute probabilities P_ik using masked pixels
    for i = 1:K
        diff = bsxfun(@minus, mask_pixels, centers(i,:));
        V(i,:) = 1/sqrt((2*pi)^3 * det(covariance{i})) ...
            .* exp(sum(-0.5*bsxfun(@times, diff, (covariance{i} \ diff')'),2));

        omega_V(i,:) = omega(i).*V(i,:);
    end
    sum_omega_V = sum(omega_V,1);
    
%     Maximization: Update weights, means and covariances using masked pixels
    for i = 1:K
        p_ik(i,:) = omega_V(i,:)./sum_omega_V;

        omega(i,1) = sum(p_ik(i,:),2)./size(V,2);
        centers(i,:) = sum(bsxfun(@times,p_ik(i,:)',mask_pixels),1)/sum(p_ik(i,:),2);
        diff = bsxfun(@minus,mask_pixels,centers(i,:));
        covariance{i} = bsxfun(@times,diff,p_ik(i,:)')'*diff/sum(p_ik(i,:),2);
    end

end

%  Compute probabilities p(c_i) in Eq.(3) for all pixels I.
gau_compo = [];
for i=1:K
    diff = bsxfun(@minus, Ivec, centers(i,:));
    gau_compo(i,:) = 1/sqrt((2*pi)^3 * det(covariance{i})) ...
        .* exp(sum(-0.5*bsxfun(@times, diff, (covariance{i} \ diff')'),2));

        omega_gau(i,:) = omega(i).*gau_compo(i,:);
end

prob = sum(omega_gau,1);