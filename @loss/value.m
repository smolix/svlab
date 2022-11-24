function x = value(loss, alpha, k_alpha, y)
%X = VALUE(LOSS, ALPHA, K_ALPHA)
%
%returns the value of the loss term
%computes it cheaply
%

% File:        @loss/value.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated: 
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

switch loss.type
 case 1
  x = sum(abs(k_alpha - y));
 case 2
  x = 0.5 * ((norm(k_alpha - y))^2);
 case 3
  x = sum(max(loss.scale - k_alpha .* y, 0));
 case 4
  x = sum(max(abs(k_alpha - y) - loss.scale,0));
 case 5
  x = sum(log(1 + exp(-k_alpha .* y)));
 case 6
  x = sum(exp(-k_alpha .* y));
 case 7
  tmp1 = y.* k_alpha;
  tmp2 = (tmp1 > 1);
  x = 2-tmp1;
  x(tmp2) = 1./tmp1(tmp2);
  x = sum(x);
end

