clearvars; clc;
load('200617_slice1_L_-0.4_spikes.mat')
%%
fs = spikeDetectionResult.params.fs;
duration_s = spikeDetectionResult.params.duration;
duration = duration_s*fs;
bin_ms = 10;
spikeMatrix = times2matrix(spikeTimes, duration, 'mea');
dsMatrix = downSample(spikeMatrix, '', bin_ms*fs/1000, 'sum', 1);

%%
effRankReal = erank(dsMatrix);
%%
rep_num = 100;
tic
for rep = 1:rep_num
    synthMatrix = zeros(size(dsMatrix));
    for i = 1:60
        synthMatrix(i,:) = circshift(dsMatrix(i,:), randi(length(dsMatrix),1));
    end
    corr_mat = corr(synthMatrix');
    erank_corr(rep) = erank(corr_mat);
    effRankSynth(rep) = erank(synthMatrix);
end
toc

