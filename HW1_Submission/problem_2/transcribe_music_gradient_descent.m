function [T, E, smagMusicProj] = transcribe_music_gradient_descent(M, N, lr, num_iter)
% Input: 
%   M: (smagMusic) 1025 x K matrix containing the spectrum magnitueds of the music after STFT.
%   N: (smagNote) 1025 x 15 matrix containing the spectrum magnitudes of the notes.
%   lr: learning rate, i.e. eta as in the assignment instructions
%   num_iter: number of iterations
%   threshold: threshold

% Output:
%   T: (transMat) 15 x K matrix containing the transcribe coefficients.
%   E: num_iter x 1 matrix, error (Frobenius norm) from each iteration
%   transMatT: 15 x K matrix, threholded version of T (transMat) using threshold
%   smagMusicProj: 1025 x K matrix, reconstructed version of smagMusic (M) using transMatT
[D,A] = size(M);
[D,K] =size(N);
E = [];
W=zeros(K,A);
for i = 1:num_iter
    W = W + lr .* 2.* N'* (M - N * W);
%     W = W - lr * 2 * N.'* (N * W - M);
%     W = W + lr .* (2/(D*A)) .* N'* (M - N * W);
    W(W<0) = 0;
    E(i) = (1/(D*A))*norm(M-N*W,'fro');
end

T = W;
smagMusicProj = N * T;

