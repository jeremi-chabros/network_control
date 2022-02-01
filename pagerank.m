clearvars; clc;
files = dir('/Users/jeremi/mea/data/Generative_model_format/*murine*.mat');

Rho= [];
Pval = [];
R2 =[];
for j = 1:length(files)
    % for j = 1:1
    load(files(j).name);
    
    for i = 1:size(adjM_all,3)
        ctr_meas = [];
        reachability_score = [];
        
        %     for i = 1:1
        A = adjM_all(:,:,i);
        
        A(isnan(A)) = 0;
%         A(isnan(A)) = [];
%         A = reshape(A, [sqrt(length(A)), sqrt(length(A))]);
        N = length(A);
        A(1:N+1:end) = 0; % Set diagonal to zeros
        A(A<0) = 0; % Set negative values to zeros
        
        B = eye(N);
        W = gramian(A, 'B', B, 'method', 'dlyap', 'time', 'd');
        ave_ctrb = diag(W);
        modal_ctrb = modal_control(A, 'c');
        
                kF = cond(W);
                ctrbIndex = 1/kF;
        
        G = graph(A);
        
        H = digraph(A);
        D = transclosure(H);
        R = full(adjacency(D));
        
        for l = 1:N
            reachability_score(l) = length(find(R(l,:)));
        end
        
        ctr_meas(1,:) = centrality(G, 'pagerank', 'importance', G.Edges.Weight);
        ctr_meas(2,:) = centrality(G, 'eigenvector', 'importance', G.Edges.Weight);
        ctr_meas(3,:) = centrality(G, 'betweenness', 'cost', 1./G.Edges.Weight);
        ctr_meas(4,:) = centrality(G, 'closeness', 'cost', 1./G.Edges.Weight);
        ctr_meas(5,:) = centrality(G, 'degree');
        ctr_meas(6,:) = sum(A);
        ctr_meas(7,:) = reachability_score;

        ctr_meas = ctr_meas';
        
        for k = 1:size(ctr_meas,2)
            mdl = fitlm(ctr_meas(:,k),ave_ctrb);
            [rho,pval] = corr(ctr_meas(:,k), ave_ctrb);
            Rho(k,end+1) = rho;
            Pval(k,end+1) = pval;
            if rho < 0
                R2(k,end+1) = mdl.Rsquared.Ordinary;
            else
                R2(k,end+1) = mdl.Rsquared.Ordinary;
            end
        end
    end
end
%%

Rho(Rho==0)=NaN;
Pval(Pval==0)=NaN;
R2(R2==0)=NaN;
tf = table(nanmean(R2,2), nanmean(Pval,2), nanmean(Rho,2), 'variablenames', {'R2','p','rho'},...
    'RowNames', {'Pagerank','Eigenvector','Betweenness','Closeness','Degree','Strength', 'Reachability'});
tf

% tf = table(nanmean(R2,2), nanmean(Pval,2), nanmean(Rho,2), 'variablenames', {'R2','p','rho'},...
%     'rownames', {'ave_ctrb:ctrb_index'});
% ;
%
% var = STR;
% plot(rescale(var))
% hold on
% plot(rescale(CTRB));
% l = legend({'Node strength','ctrb_{ave}'});
% pos = get(l, 'Position');
% mdl = fitlm(var,CTRB);
% [rho,pval] = corr(var, CTRB);
% box off;
% title({["\rho = " + rho], ["R^2 = " + mdl.Rsquared.Ordinary], ["\it p = \rm\bf"  + pval]})
% xlabel('Samples')
% ylabel('Values')