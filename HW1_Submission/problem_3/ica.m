function [A] = ica(M)
% zero mean
[row,col]=size(M); 
mu = sum(M,2)/col;
zeroM=M-mu*ones(1,col);
% whitening
corr = zeroM * zeroM';
[vector,eigval] = eig(corr);
C = eigval^(-1/2)*vector';
X = C*zeroM;
% FOBI
D = zeros();
for k = 1:size(X,2)
    D = D + norm(X(:,k)) ^ 2 * X(:,k) * X(:,k)';
end

[vector,eigval] = eig(D');
A = vector'*C;
end

