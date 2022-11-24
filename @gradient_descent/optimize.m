function [alpha, l_rreg, l_gradient] = optimize(d, aloss, aregularizer, kernel, lambda, x, y, call_alpha)
%[ALPHA, RREG, GRADIENT] = OPTIMIZE(D, LOSS, REGULARIZER, KERNEL, LAMBDA, X, Y, ALPHA)
%
%performs gradient descent on regularized risk functional given by
%rreg = loss(x, y, f) + lambda * regularizer(x, f)
%
%ALPHA       expansion coefficients
%RREG        tracked values of the regularized risk functional (OPTIONAL)
%GRADIENT    tracked norm values of the gradient (OPTIONAL)
%         
%D           gradient descent object
%LOSS        loss object
%REGULARIZER regularization term (will take account of alpha/rkhs automatically)
%KERNEL      dot product kernel
%LAMBDA      regularization constant
%X           training data
%Y           target values
%ALPHA       starting value of alpha (OPTIONAL)

% File:        @gradient_descent/optimize.m
%
% Author:      Alex J. Smola
% Created:     08/03/01
% Updated:
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% check number of arguments
l_rreg = zeros(d.maxiter, 1);

if nargout > 2
  log.gradient = 1;
  l_gradient = zeros(d.maxiter, 1);
else
  log.gradient = 0;
end;

if nargin < 7
  error('too small number of arguments, bailing out ...');
elseif nargin == 7
  alpha = zeros(length(y), 1);
elseif nargin == 8
  alpha = call_alpha;
else
  error('too large number of arguments, bailing out ...');
end;

if (d.precompute_k ==1)
  K = sv_dot(kernel, x);
end
if (nargin == 7) 
  k_alpha = zeros(length(y), 1);	% we start from scratch
elseif (d.precompute_k ==1)
  k_alpha = K * alpha;
else
  k_alpha = sv_mult(kernel, x, alpha);
end;
  

% gather some starting data
[m, n] = size(x); 

% value of regularized risk functional
regfun = inline(['value(aloss, alpha - eta * grad, k_alpha - eta * k_grad, y) +',  ...
		'lambda * value(aregularizer, alpha - eta * grad, k_alpha - eta * k_grad)'], ...
		'eta', 'aloss', 'aregularizer', 'alpha', 'k_alpha', 'grad', 'k_grad', 'y', 'lambda');
options = optimset('LineSearchType','cubicpoly','Diagnostics','off', 'Display', 'off');

% MAIN LOOP
for i=1:d.maxiter
  % compute gradient
  l_grad = grad(aloss, alpha, k_alpha, y);
  r_grad = grad(aregularizer, alpha, k_alpha);
  % take care of coefficient space setting
  alpha_grad = l_grad + lambda * r_grad;
  if ((d.type == 2) & (d.precompute_k == 1))
    alpha_grad = K * alpha_grad;
  end;
  if ((d.type == 2) & (d.precompute_k == 0))
    alpha_grad = sv_mult(kernel, x, alpha_grad);
  end;

  % monitoring (if needed) and bailout
  normgrad = norm(alpha_grad);		% we need that anyway
  l_rreg(i) = value(aloss, alpha, k_alpha, y) + lambda * value(aregularizer, alpha, k_alpha);
  if (log.gradient == 1)
    l_gradient(i) = normgrad;
  end;
  if (i > 1) 
    if ((l_rreg(i-1) - l_rreg(i)) < (d.threshold * l_rreg(i)))
      break;				% bail out of loop
    end;
  end;
  % compute gradient in f values
  if (d.precompute_k == 1)
    k_grad = K * alpha_grad;
  else
    k_grad = sv_mult(kernel, x, l_grad);
  end;
  
  % compute update direction (we walk alpha -> alpha - eta * alpha_grad)
%  eta = fminunc(regfun, 1, options, aloss, aregularizer, alpha, k_alpha, alpha_grad, k_grad, y, lambda);
  eta = fminbnd(regfun, 0, 1, options, aloss, aregularizer, alpha, k_alpha, alpha_grad, k_grad, y, lambda);

  % update the parameters
  alpha = alpha - eta * alpha_grad;
  k_alpha = k_alpha - eta * k_grad;
  disp([i, l_rreg(i), l_gradient(i), eta]);
end;

% CLEANUP BEFORE END
l_rreg = l_rreg(1:i);
if log.gradient
  l_gradient = l_gradient(1:i);
end;









