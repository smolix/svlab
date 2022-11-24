% Create artificial data
x = [randn(10,20),randn(10,20)+2];
y = [ones(20,1);-ones(20,1)];

% initialize rbf kernel
kernel = rbf_dot;

sm = pr_smo;
sm.C = 1;

% call smo
[alpha, beta, error] = optimize(sm, kernel, x, y)

