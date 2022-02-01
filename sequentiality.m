clearvars;

files = dir('*0.25*.mat');

for file = 1:numel(files)
    
    file_name = files(file).name;
    load(file_name);
    fname = file_name(1:strfind(file_name, 'L')-2);
    
    duration = spikeDetectionResult.params.duration;
    fs = spikeDetectionResult.params.fs;
    
    spike_matrix = zeros(round(fs*duration), 60);
    for channel = 1:length(spikeTimes)

            spike_frames = spikeTimes{channel}.mea;
            spike_matrix(spike_frames, channel) = 1;

    end
    
    shuffled_matrix = circshiftmat(spike_matrix);
    
    dsampled_matrix = downSampleMean(spike_matrix, 250);
    dsampled_shuffled = downSampleMean(shuffled_matrix, 250);
    
    s{file} = calSeqVec(dsampled_matrix);
    s_shuffled{file} = calSeqVec(dsampled_shuffled);

end

%%

for f = 1:numel(s)
% for f = 1:158
    
    sc = scatter(s{f}, s_shuffled{f}, 50);
    sc.MarkerEdgeColor = 'w';
    sc.MarkerFaceColor = [0.5 0.5 0.5];
    
    hold on;
end
hold on;
line = plot([0,1],[0,1]);
line.LineStyle = '--';
line.Color = 'r';
xlim([0 1]);
ylim([0 1]);
xlabel('Sequentiality (shuffled)');
ylabel('Sequentality')
title('Sequentiality across 196 organoid recordings');


%%
close all;
x = parula;
flds = fieldnames(s);

l_entries = {'const. stim', '100 ms pulses', 'no stim', 'no stim', 'no stim',...
    '100 ms pulses', 'const. stim', 'baseline', 'x = y'};

for f = 1:numel(flds)
    field = flds{f};
    scatter(s.(field), s_shuffled.(field), 300,...
        'markerfacecolor', x(f*30, :),...
        'markeredgecolor', 'none',...
        'marker', 'd');
    textscatter(s.(field), s_shuffled.(field), string(l_entries{f}));
    hold on;
end
hold on;
line = refline(1, 0);
line.LineStyle = '--';
line.Color = 'r';


% legend(l_entries,'interpreter', 'none', 'location', 'bestoutside');
%%
flds = fieldnames(s);
for f = 1:numel(flds)
    field = flds{f};
    plot(s);
    hold on;
end