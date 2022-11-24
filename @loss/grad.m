function x = grad(loss, alpha, k_alpha, y)
%X = GRAD(loss, ALPHA, K_ALPHA, Y)
%
%returns the gradient (currently alpha is unused)
%computes it cheaply
%

% File:        @loss/grad.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated: 
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

switch loss.type
 case 1
  x = sign(k_alpha - y);
 case 2
  x = (k_alpha - y);
 case 3
  x = -y.*((loss.scale - k_alpha .* y) > 0);
 case 4
  difference = k_alpha - y;
  x = sign(difference) .* (1 - (abs(difference) < loss.scale));
 case 5
  x = -y ./ (1 + exp(y .* k_alpha));
 case 6
  x = -y .* exp(-k_alpha .* y);
 case 7
  tmp1 = y.* k_alpha;
  tmp2 = (tmp1 > 1);
  x = -ones(length(tmp1), 1);
  x(tmp2) = -tmp1(tmp2).^(-2);
  x = y.*x;
end








