function h = boxPlot(var2plot, XLabel)
%% Box plot
var2plot = sort(var2plot,2);
mname = XLabel;
width = 0.2;
sep = 5*width;
% sep = 5*width;
caption = mname;
pos = [1 2*sep 3*sep];
pos = [pos, pos+sep/3];



fs = boxplot(var2plot(7:end,:)',...
    'positions', pos(4:end),...
    'widths', width,...
    'colors', ([0, 113, 188]/256),...
    'symbol','');

hold on

boxplot(var2plot(4:6,:)',...
    'positions', pos(1:3),...
    'widths', width,...
    'colors', ([182, 50, 28]/256),...
    'symbol','');

for i = 4:6
    [h,p,ci,stat] = ttest2(var2plot(i,:),var2plot(i+3,:));
    stats(i-3) = p;
end
sigstar({[pos(1),pos(4)],[pos(2),pos(5)],[pos(3),pos(6)]},stats);

% outliers = [];
% m = var2plot(4:end,:);
% e = eps(max(m(:)));
% h = flipud(findobj(gcf,'tag','Outliers')); % flip order of handles
% for jj = 1 : length( h )
%     x =  get( h(jj), 'XData' );
%     y =  get( h(jj), 'YData' );
%     for ii = 1 : length( x )
%         if not( isnan( x(ii) ) )
%             ix = find( abs( m(:,jj)-y(ii) ) < e );
%             outliers(jj,:) = [x(ii) y(ii)];
%         end
%     end
% end
% hold on

% [sharedvals,idx] = intersect(var2plot,outliers,'stable');
% [row,col] = ind2sub(size(var2plot), idx);
% var2plot(row,col) = NaN;

jitWidth = width;
for i = 4:size(var2plot, 1)
    p = pos(i-3);
%     jitter = sort((rand(size(var2plot(i,:)))) * jitWidth);
    jitter = linspace(0, width, length(var2plot(i,:)));
    s = scatter(p-jitWidth/2+jitter, var2plot(i,:));
    if i<=6
        s.MarkerFaceColor = [182, 50, 28]/256;
        s.MarkerEdgeColor = [182, 50, 28]/256;
    else
        s.MarkerFaceColor = [0, 113, 188]/256;
        s.MarkerEdgeColor = [0, 113, 188]/256;

    end
    s.SizeData = 30;
%         s.MarkerEdgeColor = 'w';
    s.MarkerFaceAlpha = .5;
    s.MarkerEdgeAlpha = 1;
%     s.LineWidth = 1.5;
    hold on
end
%
% hold on
% outliers = reshape(outliers(outliers>0), [],2);
% scatter(outliers(:,1),outliers(:,2),50, 'kx');




ylabel(caption, 'interpreter','none');
% ylim(0.9*[min(min(var2plot)) max(max(var2plot))*1.15])
ylim([-5 1]);

title([caption ' across ages and genotypes'], 'interpreter','none');
box off;
axis padded
axPos = get(gca, 'position');
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([1,4]), {'KO','WT'});
hLegend.Title.String = 'Genotype';
hLegend.Location = 'northeastoutside';

xticklabels({'14', '21', '28'})
xlabel('Age (days in vitro)')
xticks(pos(1:3)+(pos(1)+pos(4))/2 - pos(1))

set(findobj(gca,'type','line'),'linew', 1)
set(gca,'position',axPos);

h = gcf;
caption = ['/Users/jeremi/mea/network_control/plots/' caption];
end
% exportgraphics(gca, [caption '_boxplot.pdf'], 'ContentType', 'vector');
% set(findall(gcf,'-property','FontSize'),'FontSize',fsz)
%     exportgraphics(gca, [caption '_boxplot.png'], 'resolution', 300);