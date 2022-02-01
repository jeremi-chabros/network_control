clc; clearvars;
load('200708_slice1_1_L_-0.2_spikes.mat')
fs = spikeDetectionResult.params.fs;
duration = spikeDetectionResult.params.duration*fs;
spikeMatrix = zeros(60, duration);
%%
for i = 1:60
    spikeMatrix(i, spikeTimes{i}.mea) = 1;
end

spikeMatrixDS = downSampleMean(spikeMatrix', duration/(40*25));
%%
erank_ = erank(spikeMatrixDS');

