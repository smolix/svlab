function x = hessian(loss, alpha, k_alpha, y)
%X = HESSIAN(loss, ALPHA, K_ALPHA, Y)
%
%returns the second derivative of the loss (currently alpha is unused)
%computes it cheaply
%

% File:        @loss/hessian.m
%
% Author:      Alex J. Smola
% Created:     11/05/01
% Updated: 
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

[m,n] = size(y);

switch loss.type
 case 1
  x = zeros(m,n);
 case 2
  x = ones(m,n);
 case 3
  x = zeros(m,n);
 case 4
  x = zeros(m,n);
 case 5
  x = exp(y .* k_alpha);
  x = x./ ((1 + x).^2);
 case 6
  x = exp(-k_alpha .* y);
 case 7
  tmp1 = y.* k_alpha;
  tmp2 = (tmp1 > 1);
  x = -zeros(length(tmp1), 1);
  x(tmp2) = 2./(tmp1(tmp2).^3);
end








