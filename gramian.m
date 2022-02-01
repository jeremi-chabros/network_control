function W = gramian(A, args)

arguments
    A;
    args.B;
    args.method;
    args.time;
end

% Normalization to ensure stability
switch args.time
    case 'c'
        A = A/(1+svds(A,1)) - eye(size(A));
    case 'd'
        A = A/(1+abs(svds(A,1)));
end

if isfield(args, 'B')
    B = args.B;
else
    B = eye(size(A));
end

if isfield(args, 'method')
    method = args.method;
else
    method = 'mat';
end

if strcmp(args.time, 'c')
    
    switch method
        
        case 'mat'
            % Matrix form
            g = size(A);
            temp = expm([-A B*B'; zeros(size(A)) A']);
            W = temp(g+1:g*2,g+1:g*2)'*temp(1:g,g+1:g*2);
            
        case 'int'
            % Integral form
            f = @(tau) expm(A*tau)*B*B'*expm(A'*tau);
            W = @(t) integral(f, 0, t, 'ArrayValued', 1);
            W = W(1);
            
        case 'lyap'
            % Lyapunov form
            W = lyap(A, B);
            
    end
else
    switch method
        
        case 'sum'
            T = 2;
            for tau = 1:T-1
                W = A^tau*B*B'*(A')^tau;
            end
          
        case 'dlyap'
            % Discrete Lyapunov form
            W = dlyap(A, B);
            
    end
end