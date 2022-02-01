
A = results.llr_matrix;
A(1:length(A)+1:end) = 0; % Set diagonal to zeros
A = A./(1+svds(A,1)); % Normalization

B = eye(size(A));

Q = ctrb(A,B);

f = @(tau) expm(A*tau)*B*B'*expm(A'*tau);
W = @(t) integral(f, 0, t, 'ArrayValued', 1);
F = W(1);

kF = cond(F);
cF = 1/kF;

