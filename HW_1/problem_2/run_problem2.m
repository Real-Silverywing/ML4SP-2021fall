%% Load Notes and Music
% You may reuse your 'load_data' function from prob 1
[smagNote, smagMusic, sphaseMusic] = load_data();
%% Compute The Transcribe Matrix: non-negative projection with gradient descent
% Use the 'transcribe_music_gradient_descent' function here
eta = [0.0001, 0.001, 0.01, 0.1];
for i = 1:length(eta)
lr = eta(i);
num_iter = 250;
[W, E, smagMusicProj] = transcribe_music_gradient_descent(smagMusic, smagNote, lr, num_iter);

save(['results/weight_eta_',num2str(eta(i)),'.dat'],'W')

min_e(i) = min(E);

figure()
plot(E)
xlabel('iteration');
ylabel('error');
title(['$$\eta = $$',num2str(eta(i))],'interpreter','latex');
saveas(gcf,['results/error_eta_',num2str(eta(i)),'.png'])
end
%%
figure()
tag = categorical({'0.0001','0.001','0.01','0.1'});
bar(tag,min_e);
xlabel('$$\eta$$','interpreter','latex')
ylabel('error')
title('Best Error vs $$\eta$$','interpreter','latex')
saveas(gcf,['results/problem2b_eta_vs_E.png'])
% Store final W for each eta value in a text file called "problem2b_eta_xxx.dat"
% where xxx is the actual eta value. E.g. for eta = 0.01, xxx will be "0.01".

% Print the plot of E vs. iterations for each eta in a file called
% "problem2b_eta_xxx_errorplot.png", where xxx is the eta value.
% Print the eta vs. E as a bar plot stored in "problem2b_eta_vs_E.png".


%% Synthesize Music
% You may reuse the 'synthesize_music' function from prob 1.
% write the synthesized music as 'polyushka_syn.wav' to the 'results' folder.
smagMusicProj = smagNote * W;
synMusic = synthesize_music(sphaseMusic,smagMusicProj);
audiowrite('results/polyushaka_syn.wav',synMusic,16000);