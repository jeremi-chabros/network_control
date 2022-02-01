function [aveControl, eps_min] = matrixControl(mat)
%% Calculate the controllability Gramian from covariance matrix

% INPUT:
% mat - the (downsampled) neural activity matrix [num_electrodes x num_samples]

% OUTPUT: 
% aveControl - the value for average controllability as quantified by the 
%              trace of the controllability Gramian
%
% eps_min - the minimal energy required to drive the system between states

% Notes:
% Using matrix operations instead of integration
% See: https://www.cs.cornell.edu/cv/ResearchPDF/computing.integrals.involving.Matrix.Exp.pdf

% Substitute identity matrix I for B*B'

% TODO: parameterize for different number of active electrodes

I = eye(60);
A = cov(mat');
temp = expm([-A I; zeros(60) A']);
W = temp(61:120,61:120)'*temp(1:60,61:120);
aveControl = trace(W);

% Consider only active nodes
emptyRows = round(sum(W)) == 1;
notEmpty = W(~emptyRows, ~emptyRows);

% Get minimum energy
eps_min = 1/min(eig(notEmpty));

end