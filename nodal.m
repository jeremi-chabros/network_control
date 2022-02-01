clearvars -except Acorr Acov Asttc Aglm;
clc;


A = Aglm;
% A = randi([0,1000], 60)/1000;
N = length(A);
A(1:N+1:end) = 0;

B = eye(N);

% % Nodal average controllability
% for n = 1:N
%     B = zeros(N);
%     B(n,n) = 1;
%     W = gramian(A, 'B', B, 'method', 'mat', 'time', 'c');
%     nodal_ctrb(n) = trace(W);
%     nodal_nrg(n) = real(min(eig(W)));
% end

W = gramian(A, 'B', eye(N), 'method', 'mat', 'time', 'c');

ave_ctrb = trace(W);
min_nrg = min(eig(W));

ctrbIndex = 1/cond(W);

%%
A = A/(1+eigs(A,1));
SeriesSum = dlyap(A,eye(size(A,1)));
values = diag(SeriesSum);