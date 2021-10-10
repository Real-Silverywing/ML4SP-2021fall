%% Load Notes and Music
% Use the 'load_data' function here
[smagNote, smagMusic, sphaseMusic] = load_data();
%% Solution for Problem 1.1 here
% Place all the 15 scores W_i (for the 15 notes) into a single matrix W. 
% Place  the score for the i-th note in the i-th row of W.
% W will be a 15xT matrix, where T is the number of frames in the music.
% Store W in a text file called "problem2a.dat"
W = pinv(smagNote) * smagMusic;
save('results/problem1a.mat','W')
%% Solution to Problem 1.2 here:  Synthesize Music
% Use the 'synthesize_music' function here.
% Use 'wavwrite' function to write the synthesized music as 'problem2b_synthesis.wav' to the 'results' folder.
W = pinv(smagNote) * smagMusic;
save('results/problem1b.mat','W')
smagMusicProj = smagNote * W;
synMusic = synthesize_music(sphaseMusic,smagMusicProj);
audiowrite('results/problem1b_synthesis.wav',synMusic,16000);

