function [obj] = compute_objective(V, B, W) 

% Your code here
% BW = B*W;
% BW = BW+eps;
% t1 = sum(V.*log(V./(B*W)),'all');
% t2 = sum(V,'all');
% t3 = sum(B*W,'all');
% obj = t1+t2+t3;

BW = B*W;
[imax,jmax] = size(V);
for i=1:imax
    for j=1:jmax
        obj = V(i,j).*log(V(i,j)./BW(i,j))+V(i,j)-BW(i,j);
    end
end