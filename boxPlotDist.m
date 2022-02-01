close all; clc;
var2plot = ave_ctrb_global;

XLabel = 'L-skewness of average controllability';
YLabel = 'Probability distribution';

% subplot(2, 3, [1 2 3])
boxPlot(var2plot, XLabel);
set(gcf, 'color','w', 'position', [4 4 9 9]);
%%
subplot(2, 3, 4)
ax1 = rainPlot(var2plot([4,7],:),XLabel, YLabel);
axis square

subplot(2, 3, 5)
ax2 = rainPlot(var2plot([5,8],:),XLabel,YLabel);
axis square

subplot(2, 3, 6)
ax3 = rainPlot(var2plot([6,9],:),XLabel,YLabel);
axis square
axPos = get(gca,'Position');

linkaxes([ax1, ax2, ax3], 'x');

% Add legend
hLegend = legend({'KO','WT'});
hLegend.Title.String = 'Genotype';
hLegend.Location = 'northeastoutside';
set(findobj(gca,'type','line'),'linew', 1);

set(gca, 'position', axPos); % Fix axes

% Resize figure & font size
set(gcf,'unit','pixels');
set(findall(gcf,'-property','FontSize'),'FontSize',12);
set(gcf, 'position',[1, 1, 1050 , 1485], 'color','w');

% exportgraphics(gcf, 'boxplot_with_dist.png', 'resolution', 300);