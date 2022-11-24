function x = sv_dot_fast(kernel, a, b, dot_a)

% SV_DOT_FAST Dot product for the RBF kernel, when using Incomplete
% Cholesky 
%
% X = SV_DOT(kernel, A, B, DOT_A) returns <A,B> where kernel is the
% type of dot product used. We compute exp( -sigma * |x - y|^2 )
%
% see also DISPLAY, SV_DOT, SV_MULT, SV_POL
%
% File:        @rbf_dot/sv_dot_fast.m
%
% Author:      S V N Vishwanathan and Alex Smola
% Created:     06-06-2003
%
% This code is released under the GNU Public License
% Copyright by The Australian National University and NICTA

if ( nargin ~= 4 )
  error('wrong number of arguments');
else 
  dot_b = sum( b.^2, 1 )';
  unitvec = ones( size( a, 2 ), 1 );
  x = a' * b;
  for i = 1:size( b, 2 )
    x(:,i) = exp(kernel.sigma * (2*x(:,i) - dot_a - dot_b(i) * unitvec));
  end
end
return
