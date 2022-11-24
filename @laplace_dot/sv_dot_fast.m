function x = sv_dot_fast(kernel, a, b, dot_a)

% SV_DOT_FAST Dot product for the Laplacian kernel, when using Incomplete
% Cholesky 
%
% X = SV_DOT(kernel, A, B, DOT_A) returns <A,B> where kernel is the
% type of dot product used. We compute exp( -sigma * |x - y|^2 )
%
% see also DISPLAY, SV_DOT, SV_MULT, SV_POL
%
% File:        @laplace_dot/sv_dot_fast.m
%
% Author:      Alex Smola
% Created:     17/07/03
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
    x(:,i) = exp(-kernel.sigma*(dot_a + dot_b(i)*unitvec-2*x(:,i)).^0.5);
  end
end
return