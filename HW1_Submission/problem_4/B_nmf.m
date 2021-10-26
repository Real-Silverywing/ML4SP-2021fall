function [ M_speech_rec, M_music_rec] = B_nmf(M,Bs,Bm,n_iter)
%NMF function that do not update bases
load('data\Wm_init.csv');
load('data\Ws_init.csv');

[D,N] = size(M);
B = [Bs,Bm];
W = [Ws_init;Wm_init];
%iter
for k = 1:n_iter
    W = W.*((B'*(M./(B*W)))./(B'*ones(D,1)));
end
M_speech_rec = Bs*W(1:200,:);
M_music_rec = Bm*W(201:400,:);
end

