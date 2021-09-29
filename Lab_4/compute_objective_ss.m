function [obj] = compute_objective_ss(V,B,W, alpha, beta) 

% Your code here
% BW = B*W;
% BW = BW + eps;
% [imax,jmax] = size(V);
% for i=1:imax
%     for j=1:jmax
%         obj = V(i,j).*log(V(i,j)./BW(i,j))+V(i,j)-BW(i,j);
%     end
% end
% obj = obj+alpha*sum(sum(W))+ beta*sum(sum(B));

BW = B*W;
BW = BW+eps;
V = V+eps;
obj = sum(sum(V.*log(V./BW))) + sum(sum(V)) - sum(sum(BW)) + alpha*sum(sum(W)) + beta*sum(sum(W));
end