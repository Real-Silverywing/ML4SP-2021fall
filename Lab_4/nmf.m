function [B,W,obj,k] = nmf(V,rank,max_iter,lambda)
% NMF - Non-negative matrix factorization
% [B,W,OBJ,NUM_ITER] = NMF(V,RANK,MAX_ITER,LAMBDA) 
% V - Input data.
% RANK - Rank size.
% MAX_ITER - Maximum number of iterations (default 50).
% LAMBDA - Convergence step size (default 0.0001). 
% B - Set of basis images.
% W - Set of basis coefficients.
% OBJ - Objective function output.
% NUM_ITER - Number of iterations run.

% Your code here
[D,N] = size(V);
K = rank;
B = rand(D,K);
%W = ones(K,N);
W1 = ones(1,N);
W2 = zeros(K-1, N);
W = [W1;W2];
end

