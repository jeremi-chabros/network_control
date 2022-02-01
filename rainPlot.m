% NOTE: Need to define data
%       My data are 9x13 (9 time points, 13 cultures)
%       so I extract all cultures from time point:
%       data = data(i,:)

function ax = rainPlot(var2plot, XLabel, YLabel)
colours = [0.7109, 0.1953, 0.1094; 0, 0.4414, 0.7344];

fmax = 0;
for i = 1:2
    data = var2plot(i,:);
    [f,xi] = ksdensity(data);
    if max(f)>fmax
        fmax=max(f);
    end
end
c = 1;
for i = [1,2]
    colour = colours(c,:);
    data = var2plot(i,:);
    
    % Plot density distribution (from HalfViolinPlot.m)
    [f,xi] = ksdensity(data);
    obj.ViolinPlot = fill(xi,f,colour);
    obj.ViolinPlot.EdgeColor = colour;
    obj.ViolinPlot.LineWidth = 1;
    obj.ViolinPlot.FaceAlpha = 0.1;
    
    % Set fmax to scale axes

    hold on
    
    % Plot scatter
    if i == 1
        mxval = 0;
        mnval = -0.3*fmax;
        jitter = mnval + rand(size(data)).*(mxval-mnval);
    else
        mxval = -0.3*fmax;
        mnval = -0.5*fmax;
        jitter = mnval + rand(size(data)).*(mxval-mnval);
    end
    
    s = scatter(data, jitter-0.1*fmax, 50, 'o', 'filled', 'markerfacecolor', colour,...
        'markeredgecolor', 'w');
    s.LineWidth = 1;
    
    set(get(get(s,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    obj.scatter(i) = s;
    box off
    hold on
    c = c+1;
end

% Axes limits and ticks
axis tight
ylim([-0.6*fmax fmax])
yticks(linspace(0, fmax, 5))
yticklabels(round(linspace(0, fmax,5),2))

xt = get(gca, 'xtick');
xbin = xt(2)-xt(1);
newTicks = 0:xbin:xt(end);
xticks(newTicks)

% Axes labels
xlabel(XLabel)
ylb = ylabel(YLabel);
ylb.HorizontalAlignment = 'left';
ax = gca;
yl=yline(0,'k-');
yl.LineWidth = 1;
end
% Legend
% hLegend = legend({'KO','WT'});
% hLegend.Title.String = 'Genotype';
% hLegend.Location = 'northeastoutside';
% set(findobj(gca,'type','line'),'linew', 1)

%     % Plot mean (line)
%     [~ ,idx] = min(abs(bsxfun(@minus, mean(data), xi)));
%     lineHeight = f(idx-1);
%     %     lineHeight = max(f);
%     l = line([mean(data),mean(data)],[0,lineHeight]);
%     l.LineWidth = 1;
%     l.Color = colour;
%     l.LineStyle = '--';
%     set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%
%     % Plot mean (label)
%     dist = get(gca, 'xtick');
%     dist = (dist(2)-dist(1))*0.1; % So as text and line don't overlap
%     t = text(mean(data)+dist, lineHeight,"\mu = " + round(mean(data),2));
%     t.Color = colour;
%     hold on
%
%     % Plot std (line)
%     [~ ,idx] = min(abs(bsxfun(@minus, mean(data)+std(data), xi)));
%     lineHeight = f(idx-1);
%     l = line([mean(data)+std(data),mean(data)+std(data)],[-0.001,lineHeight]);
%     l.Color = colour;
%     l.LineStyle = '-.';
%     l.LineWidth = 100;
%     set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%
%     % Plot std (label)
%     dist = get(gca, 'xtick');
%     dist = (dist(2)-dist(1))*0.1; % So as text and line don't overlap
%     t = text(mean(data)+std(data), -0.002,"\sigma = " + round(std(data),2));
%     t.Color = colour;
%     hold on
