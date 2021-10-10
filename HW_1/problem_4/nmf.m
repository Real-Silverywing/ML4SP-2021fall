function [B, W, obj, k] = nmf(M,B_init,W_init,n_iter)
[D,N] = size(M);
B = B_init;
W = W_init;
k = 0;
obj= compute_objective(M, B, W);
%iter
for k = 1:n_iter
    B = B.*(((M./(B*W))*W')./(ones(1,N)*W'));
    W = W.*((B'*(M./(B*W)))./(B'*ones(D,1)));
    obj= compute_objective(M, B, W);
end

end

