%% Write the solution to Problem 3 here
%% load data
clc
clear
[s1,fs] = audioread([pwd,'/data/sample1.wav']);
[s2,fs] = audioread([pwd,'/data/sample2.wav']);
M = [s1';s2'];

%% ICA
% zero mean
A = ica(M);
%%
H = A*M;
audiowrite('results/source1.wav',H(1,:),fs);
audiowrite('results/source2.wav',H(2,:),fs);