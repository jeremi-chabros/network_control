clearvars; clc;
files = dir('/Users/jeremi/mea/data/Generative_model_format/*.mat');
% addpath(files)
% load channels
fsz = 16;

for file = 1:numel(files)
    load(files(file).name);
    for culture = 1:13
        
        A = adjM_all(:,:, culture);
        N = length(A);
        A(1:N+1:end) = 0; % Set diagonal to zeros
        A(isnan(A))=0;
        
        %
        F=A;
        grd = nansum(A)==0;
        grd = find(grd);
        F(nansum(F)==0,:) = 0;
        F(:,nansum(F)==0) = 0;
        F(F<0) = 0;
        K = ave_control(F);
%         customHeatmap(K,...
%             'grd', grd, ...
%             'c_map', 'thermal');
%         axis square
%         set(gcf, 'unit','pixels');
%         exportgraphics(gcf, "control_hmaps/" + culture_list{culture}+ ".png", 'resolution', 300);
        
%         close all;
        %
        
        A(nansum(A)==0,:) = [];
        A(:,nansum(A)==0) = [];
        A(A<0) = 0; % Set negative values to zeros
        
        N = length(A);
        B = eye(N);
        
        W = gramian(A, 'B', B, 'method', 'mat', 'time', 'c');
        
        ave_ctrb_global(file, culture) = trace(W);
        ave_ctrb_nodal(file, culture) = mean(ave_control(A));
        gramian_det(file, culture) = log(det(W));
        gramian_V(file, culture) = (pi^(N/2)/(gamma((N/2)+1)))*nthroot(det(W), N);
        modal_ctrb(file, culture) = mean(modal_control(A, 'd'));
        global_ctrb(file, culture) = mean(eig(W));
        min_nrg(file, culture) = 1/min(eig(W));
        ctrb_index(file, culture) = (1/cond(W));
        erank_(file, culture) = efrank(A);
        rerank(file, culture) = erank_(file, culture)/N;
        network_size(file, culture) = N;
        
        L_moments = lmom(rescale(ave_control(A)), 4);
        ave_ctrb_Lskew(file, culture) = L_moments(3)/L_moments(2);
        ave_ctrb_skew(file, culture) = skewness(ave_control(A));
        
        L_moments = lmom(modal_control(A, 'c'), 4);
        modal_ctrb_skew(file, culture) = skewness(modal_control(A, 'c'));
        modal_ctrb_Lskew(file, culture) = L_moments(3)/L_moments(2);
        
        
    end
end
%% Line plot

% metrics_list = {'ave_ctrb_global','ave_ctrb_nodal','gramian_det','gramian_V',...
%     'modal_ctrb','global_ctrb','min_nrg','ctrb_index','erank_','rerank','network_size'};

metrics_list = {'ave_ctrb_global','ave_ctrb_nodal','modal_ctrb'};
for metric = 1:length(metrics_list)
    close all;
    switch metric
        
        case 1
            mname = 'Average controllability';
        case 2
            mname = 'Nodal average controllability';
        case 3
            mname = 'det (W_c)';
        case 4
            mname = 'Volume of the controllability ellipsoid';
        case 5
            mname = 'Modal controllability';
        case 6
            mname = 'Global controllability';
        case 7
            mname = 'Minimum input energy';
        case 8
            mname = 'Controllability index';
        case 9
            mname = 'Effective rank';
        case 10
            mname = 'Relative effective rank';
        case 11
            mname = 'Network size';
    end
    metric = metrics_list{metric};
    eval(['var2plot = ' metric ';']);
    var2plot = network_size;
    err =  std(var2plot);
    var2plot = mean(var2plot,2);
    caption = [mname ' (mean +/- SEM)'];
    ebar = 1;
    
    var2plot = reshape(var2plot, [3,3])';
    if ebar
        errorbar([14, 21, 28], var2plot(1,:), err(1:3)/13, 's-', 'linewidth', 1.2, 'markersize', 5);
        hold on;
        errorbar([14, 21, 28], var2plot(2,:), err(1:3)/13,'s-', 'linewidth', 1.2, 'markersize', 5);
        hold on;
        errorbar([14, 21, 28], var2plot(3,:), err(1:3)/13,'s-', 'linewidth', 1.2, 'markersize', 5);
    else
        plot([14, 21, 28], var2plot(1,:), 's-', 'linewidth', 1.2, 'markersize', 5);
        hold on;
        plot([14, 21, 28], var2plot(2,:), 's-', 'linewidth', 1.2, 'markersize', 5);
        hold on;
        plot([14, 21, 28], var2plot(3,:), 's-', 'linewidth', 1.2, 'markersize', 5);
    end
    lgd = legend('HE', 'KO', 'WT');
    lgd.Title.String = 'Genotype';
    lgd.Location = 'northwest';
    ylabel(caption, 'interpreter','none');
    xticks([14 21 28]);
    xlabel('Age (DIV)');
    title([caption ' across ages and genotypes'], 'interpreter','none');
    box off;
    caption = ['/Users/jeremi/mea/network_control/plots/' caption];
    set(findall(gcf,'-property','FontSize'),'FontSize',fsz)
%     exportgraphics(gca, [caption(1:strfind(caption, '(')-2) '.png'], 'resolution', 300)

    %% Box plot
    close all;
    
    eval(['var2plot = ' metric ';']);
    caption = mname;
    pos = [1 2 3];
    
    
    boxplot(var2plot(4:6,:)',...
        'positions', pos,...
        'widths', 0.25,...
        'colors', ([182, 50, 28]/256),...
        'symbol','x');
    
    hold on
    
    boxplot(var2plot(7:end,:)',...
        'positions', pos+0.3,...
        'widths', 0.25,...
        'colors', ([0, 113, 188]/256),...
        'symbol','x');
    
    
    xticklabels({'14', '21', '28'})
    xlabel('Age (DIV)')
    xticks([1 2 3]+0.175)
    
    ylabel(caption, 'interpreter','none');
    % ylim(0.9*[min(min(var2plot)) max(max(var2plot))*1.15])
    ylim([-5 1]);
    
    title([caption ' across ages and genotypes'], 'interpreter','none');
    box off;
    
    box_vars = findall(gca,'Tag','Box');
    hLegend = legend(box_vars([1,4]), {'WT','KO'});
    hLegend.Title.String = 'Genotype';
    hLegend.Location = 'northeastoutside';
    h = gcf;
    set(findobj(gca,'type','line'),'linew', 1)
    
    axis padded
    caption = ['/Users/jeremi/mea/network_control/plots/' caption];
    % exportgraphics(gca, [caption '_boxplot.pdf'], 'ContentType', 'vector');
    set(findall(gcf,'-property','FontSize'),'FontSize',fsz)
    exportgraphics(gca, [caption '_boxplot.png'], 'resolution', 300);
    % matlab2tikz();
    
    %%
    close all;
    eval(['var2plot = ' metric ';']);
    caption = mname;
    
    cum_var2plot = [var2plot(4,:), var2plot(5,:), var2plot(6,:);...
        var2plot(7,:), var2plot(8,:), var2plot(9,:)];
    boxplot(cum_var2plot');
    xticklabels({'KO','WT'});
    xlabel('Genotype')
    ylabel(caption, 'interpreter','none')
    box off
    title(['Genotype differences in ' caption ' (cumulative across development)'], 'interpreter','none')
    caption = ['/Users/jeremi/mea/network_control/plots/' caption];
    set(findall(gcf,'-property','FontSize'),'FontSize',fsz)
%     exportgraphics(gca, [caption '_cumboxplot.png'], 'resolution', 300);
end