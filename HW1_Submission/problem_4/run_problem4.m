%% Write the solution to Problem 4 here
clc
clear
[speech,	fs]	=	audioread('data\speech.wav');
spectrogram	=	stft(speech',2048,256,0,hann(2048));
Ms	=	abs(spectrogram);
sphaseSpeech = spectrogram ./(abs(spectrogram)+eps);

[music,	fs]	=	audioread('data\music.wav');
spectrogram	=	stft(music',2048,256,0,hann(2048));
Mm	=	abs(spectrogram);
sphaseMusic = spectrogram ./(abs(spectrogram)+eps);
%% NMF
load('data\Bm_init.csv');
load('data\Bs_init.csv');
load('data\Wm_init.csv');
load('data\Ws_init.csv');
n_iter = [0, 50, 100, 150, 200, 250];
objm_list = [];
objs_list = [];
for i = 1:length(n_iter)
    [Bm,Wm,objm,km] = nmf(Mm,Bm_init,Wm_init,n_iter(i));
    objm_list = [objm_list,objm];
    [Bs,Ws,objs,ks] = nmf(Ms,Bs_init,Ws_init,n_iter(i));
    objs_list = [objs_list,objs];
end
%%
figure()
plot(n_iter,objm_list,'r-o','MarkerFaceColor','r')
title({'D(M_m||B_mW_m)';['D(M_m||B_mW_m)_{250 iter}= ',num2str(objm_list(6))]})
saveas(gcf,['results/KL divergence of music.png'])
figure()
plot(n_iter,objs_list,'r-o','MarkerFaceColor','r')
title({'D(M_s||B_sW_s)';['D(M_s||B_sW_s)_{250 iter} = ',num2str(objs_list(6))]})
saveas(gcf,['results/KL divergence of speech.png'])
%% signal seperation
[mixed,	fs]	=	audioread('data\mixed.wav');
spectrogram	=	stft(mixed',2048,256,0,hann(2048));
Mmixed	=	abs(spectrogram);
iter = 250;
[ M_speech_rec, M_music_rec] = B_nmf(Mmixed,Bs,Bm,iter);
csvwrite(['results\M speech rec_',num2str(iter),'.csv'],M_speech_rec);
csvwrite(['results\M music rec_',num2str(iter),'.csv'],M_music_rec);
iter = 500;
[ M_speech_rec, M_music_rec] = B_nmf(Mmixed,Bs,Bm,n_iter);
csvwrite(['results\M speech rec_',num2str(iter),'.csv'],M_speech_rec);
csvwrite(['results\M music rec_',num2str(iter),'.csv'],M_music_rec);
%%
speech_rec = synthesize_music(sphaseSpeech,M_speech_rec);
audiowrite('results/speech rec.wav',speech_rec,16000);

music_rec = synthesize_music(sphaseMusic,M_music_rec);
audiowrite('results/music rec.wav',music_rec,16000);