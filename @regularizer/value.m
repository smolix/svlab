function x = value(regularizer, alpha, k_alpha)
%X = VALUE(REGLARIZER, ALPHA, K_ALPHA)
%
%returns the value of the regularization term
%computes it cheaply
%

% File:        @regularizer/value.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated: 
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

switch regularizer.type
 case 1
  x = 0.5 * dot(alpha, k_alpha);
 case 2
  x = 0.5 * dot(alpha, k_alpha);
 case 3
  x = sqrt(dot(alpha, k_alpha));
 case 4
  x = sqrt(dot(alpha, k_alpha));
 case 5
  x = sum(abs(alpha));
 case 6
  x = 0.5 * dot(alpha, alpha);
end





