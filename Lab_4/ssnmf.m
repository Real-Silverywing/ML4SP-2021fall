function [B,W,obj,k,error] = ssnmf(V,rank,max_iter,lambda,alpha,beta) 
% SSNMF - Non-negative matrix factorization
% [W,H,OBJ,NUM_ITER] = SSNMF(V,RANK,MAX_ITER,LAMBDA)
% V - Input data.
% RANK - Rank size.
% MAX_ITER - Maximum number of iterations (default 50). 
% LAMBDA - Convergence step size (default 0.0001).
% ALPHA - Sparse coefficient for W.
% BETA - Sparse coefficient for B.
% W - Set of basis images.
% H - Set of basis coefficients.
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
old_obj = compute_objective_ss(V,B,W, alpha, beta);

%iter
for k = 1:max_iter
    B = B.*(((V./(B*W))*W')./(ones(1,N)*W'+beta));
    W = W.*((B'*(V./(B*W)))./(B'*ones(D,1)+alpha));
    W = W./sum(W);
    obj = compute_objective_ss(V,B,W, alpha, beta);
    error = abs(old_obj-obj);
    if error <= lambda
        disp('error < lambda')
        break
    end
    old_obj = obj;

end
end

