function prob = mixture_prob(imag, K, L, mask)

%  Let I be a set of pixels and V be a set of K Gaussian components in 3D (R,G,B).
%  Store all pixels for which mask=1 in a Nx3 matrix
%  Randomly initialize the K components using masked pixels
%  Iterate L times
%     Expectation: Compute probabilities P_ik using masked pixels
%     Maximization: Update weights, means and covariances using masked pixels
%  Compute probabilities p(c_i) in Eq.(3) for all pixels I.