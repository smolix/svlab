% Create artificial data
x = [randn(10,20),randn(10,20)+2];
y = [ones(20,1);-ones(20,1)];

% Lower rank of matrix 
x(:,1:2) = ones(10,2);

% initialize rbf kernel
k = rbf_dot

% Create c-svc optimization problem

H = sv_pol(k,x,y);
c = -ones(40,1);
A = -y';
b = 0;
l = zeros(40,1);
u = repmat(5/40,40,1);
r = 0 ;
optim = intpoint


[primal, dual, how] = optimize(optim, c, H, A, b, r, l, u)

% low rank aprox.
Z = chol_reduce(x, k)';

[primal, dual, how] = optimize(optim, c, Z, A, b, r, l, u)

%
Hmn = Z ;
Hnn = diag(ones(39,1));

[primal, dual, how] = optimize(optim, c, Hmn, A, b, r, l, u, Hnn)
