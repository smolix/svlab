function [z, l, index, gamma, regfun] = optimize(d, kernel, myloss, lambda, x, y, n);
% OPTIMIZE Reduced Cholesky decomposition via positive diagonal pivoting
%
%        [z, l, index, gamma, regfun] = optimize(d, kernel, myloss, lambda, x, y, n);
%
% d      : class
% kernel : kernel object (we don't want to pass K)
% myloss : loss function (we get gradient and hessian)
% lambda : regularization constant
% x      : upon which to construct the dot product matrix
% y      : labels for x
% n      : number of dimensions to be extracted
% 
% z      : decomposes K into z z'
% l      : lower triangular matrix of the nxn submatrix
% index  : data chosen
% gamma  : coefficients for expansion
% regfun : minimum value of the objective function

% File:        laplace_approx.m
%
% Author:      Alex J. Smola
% Created:     11/05/01
% Updated:     
%
% This code is not currently released
% Copyright by Telstra Research and The Australian National University

% initializing the variables
[d, m] = size(x); 			% we get the dimensionality
                                        % of the data
beta = zeros(n,1);			% the parameter vector
f = zeros(m,1);				% the predictions 
f_grad = zeros(m,1);			% gradient in f
beta_grad = zeros(n,1);			% gradient in beta
f_hess = zeros(m,1);			% hessian in f
beta_hess = zeros(n,n);			% hessian in beta

% start by decomposing the data
if (d.verbose > 0)	% print at least one status report
  disp('Decomposing K');
end;
[z, l, index, residual_trace] = red_chol(d, kernel, x, n);
%
sigfig = -100;
					
if (d.verbose > 0)	% print at least one status report
  disp('Starting Newton Iterations');
  report = sprintf(['Iter \tSigFigs \tPrimalObj']); 
  disp(report);
end
i = 0;
while (i < d.maxiter)
  i = i+1;
  f_grad = grad(myloss, [], f, y);
  f_hess = hessian(myloss, [], f, y);
  beta_grad = lambda * beta + (1/m) * (f_grad' * z)';
  beta_hess = lambda * eye(n) + (1/m) * z' * sparse(diag(f_hess)) * z;
  %
  % monitoring
  normgrad = norm(beta_grad);
  regfun = 0.5 * lambda * sum(beta.^2) + (1/m) * value(myloss, [], f, y);
  sigfig = -log10((0.5 * (normgrad^2) / lambda) / regfun);
  %
  if (sigfig >= d.sigfig) break; end;
  if (d.verbose > 0)	% print at least one status report
    report = sprintf(['Iter \tSigFigs \tPrimalObj']); 
    disp(report);
  end
  if (d.verbose > 1)			% final report
    report = sprintf('%i \t%e \t%e', i, sigfig, regfun);
    disp(report);
  end
  % newton step
  beta = beta - beta_hess \ beta_grad;
  f = z * beta;
  disp([i, log(normgrad), log(regfun)]);
end;

if (d.verbose > 1)			% final report
  report = sprintf('%i \t%e \t%e', i, sigfig, regfun);
  disp(report);
end

% rescale back to kernel expansion form
gamma  = l' \ beta;
regfun = 0.5 * lambda * sum(beta.^2) + (1/m) * value(myloss, [], f, y);





