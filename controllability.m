clearvars;
%load('200708_slice1_1_L_-0.25_spikes.mat');
load('191210_FTD_slice3_DIV_g04_2018_L_-0.39494_spikes.mat')
%
fs = 25000;
duration = round(spikeDetectionResult.params.duration * fs);
spikeMatrix = times2matrix(spikeTimes, duration, 'mea');
%spikeMatrix([15,21], :) = [];
n = duration/1250;
X = downSampleMean(spikeMatrix', n);

%adjM = getAdjM(spikeMatrix', 'tileCoef', 0, 15);

%%
lag = 15; % [ms]
numChannel = length(channels);
combChannel = nchoosek(1:numChannel, 2);
A = zeros(1, length(combChannel));
adjM = NaN(numChannel, numChannel);
tic
for i = 1:length(combChannel)
    dtv = lag/1000; % [s]
    spike_times_1 = double(spikeTimes{combChannel(i,1)}.mea/25000);
    spike_times_2 = double(spikeTimes{combChannel(i,2)}.mea/25000);
    N1v = int16(length(spike_times_1));
    N2v = int16(length(spike_times_2));
    dtv = double(dtv);
    Time = double([0 spikeDetectionResult.params.duration]);
    tileCoef = sttc(N1v, N2v, dtv, Time, spike_times_1, spike_times_2);
    
    row = combChannel(i,1);
    col = combChannel(i,2);
    A(i) = tileCoef; % Faster to only get upper triangle so might as well store as vector
end
toc

% Vector -> matrix
for i = 1:length(combChannel)
    row = combChannel(i,1);
    col = combChannel(i,2);
    adjM(row, col) = A(i);
    adjM(col, row) = A(i);
end

%%
repNum = 100;
lag = 15;
p = 0.05;
[adjMci] = AdjMProbabilisticThresh_v3(spikeMatrix,adjM,repNum,lag,1,p);

%%
%A = A./(1+svds(A,1));     % Matrix normalization
Acov = cov(X);
Acorr = corr(X);
A = adjM;

% A = Asttc;

I = eye(size(A));
% Matrix form
g = size(A);
temp = expm([-A I; zeros(size(A)) A']);
Wm = temp(g+1:g*2,g+1:g*2)'*temp(1:g,g+1:g*2);

% Integral form
f = @(tau) expm(A*tau)*I*expm(A'*tau);
W = @(t) integral(f, 0, t, 'ArrayValued', 1);
Wi = W(1);

% Lyapunov form
Wl = lyap(A, I);

globalCtrb = trace(Wm);
%%
t = tiledlayout(2,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% set(gcf, 'position', [300 300 1000 1000]);

nexttile
imagesc(Acov);
title('cov', 'FontName', 'Linux Biolinum');
axis square
colorbar

nexttile
imagesc(Acorr);
title('corr', 'FontName', 'Linux Biolinum');
axis square
colorbar

nexttile
imagesc(Asttc);
title('sttc', 'FontName', 'Linux Biolinum');
axis square
colorbar


nexttile
imagesc(Aglm);
title('glmcc', 'FontName', 'Linux Biolinum');
axis square

title(t,'Adjacency matrices obtained with different methods', 'FontName', 'Linux Biolinum')
xlabel(t,'Electrode number', 'FontName', 'Linux Biolinum')
ylabel(t,{['Electrode number'],['']}, 'FontName', 'Linux Biolinum')
colorbar

c_map = 'haline';
c_map = cmocean(c_map);
colormap(c_map);

