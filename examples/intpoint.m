% Create artificial data
x = [randn(10,20),randn(10,20)+2];
y = [ones(20,1);-ones(20,1)];

% Lower rank of matrix 
x(:,1:2) = ones(10,2);

% initialize rbf kernel
k = rbf_dot

% Create nu-svc optimization problem

H = sv_pol(k,x,y);
c = zeros(40,1);
A = [y';ones(1,40)];
b = [0;(0.05*40)];
l = zeros(40,1)
u = ones(40,1)
optim = intpoint_pr

% call optimizer through wrapper function
[primal, dual, how] = optimize(optim, c, H, A, b, l, u)


% try the same think with  a low rank aproximation Z
Z = chol_reduce(x, k)';

% ooops bug ?
[primal, dual, how] = optimize(optim, c, Z, A, b, l, u)

Hmn = Z;
Hnn = diag(ones(39,1));

% same think 
[primal, dual, how] = optimize(optim, c, Hmn, A, b, l ,u, Hnn)
