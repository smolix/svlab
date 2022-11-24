clear all;

%set up dummy data
X = randn (10,100);

skew=10*eye(10);
skew2 = [skew,skew];
skew4=[skew2,skew2];
skew8=[skew4,skew4];
skew=[skew8,zeros(10,20)];

X=X+skew*10;
X=[X;randn(100,100)];

%set up variables
ker = vanilla_dot;
kfa_var = kfa;
kfa_var.numfeatures=5;

[alphas,betas]=train(kfa_var,ker,X);


