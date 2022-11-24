function x = grad(regularizer, alpha, k_alpha)
%X = GRAD(regularizer, ALPHA, K_ALPHA)
%
%returns the value of the regularization term
%computes it cheaply
%

% File:        @regularizer/grad.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated: 
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

switch regularizer.type
 case 1
  x = alpha;
 case 2
  x = k_alpha;
 case 3
  normval = value(regularizer, alpha, k_alpha);
  if normval > 0
    x = (1/normval) * alpha;
  else
    x = 0 * alpha;
  end;
 case 4
  normval = value(regularizer, alpha, k_alpha);
  if normval > 0
    x = (1/normval) * k_alpha;
  else
    x = 0 * k_alpha;
  end;
 case 5
  x = sign(alpha);
 case 6
  x = alpha;
end
