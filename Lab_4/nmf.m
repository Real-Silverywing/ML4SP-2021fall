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
% initialize 
[D,N] = size(V);
K = rank;
B = rand(D,K);
W = rand(K,N);
W = W./sum(W);
k = 0;
%obj
old_obj = compute_objective(V, B, W);

%iter
for k = 1:max_iter
    B = B.*(((V./(B*W))*W')./(ones(1,N)*W'));
    W = W.*((B'*(V./(B*W)))./(B'*ones(D,1)));
    obj = compute_objective(V, B, W);
    if abs(old_obj-obj)<=lambda
        break
    end
    
   

end
end

