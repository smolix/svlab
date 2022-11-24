function x = sv_dot(d, a, b)
%SV_DOT dot product for the Laplacian Kernel
%
%	X = SV_DOT(D, A, B) returns the <A,B> (for three
%	input arguments) or <A',A> (for two input arguments) where
%	D is the type of dot product used
%	
%	exp(-sigma * |x - y|)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @gauss_dot/sv_dot.m
%
% Author:      Alex Smola 
% Created:     17/07/03
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
elseif nargin == 2
  dot_a = sum(a.*a,1)'; 
  unitvec = ones(size(a,2),1);
  x = a' * a;
  
  for i=1:size(a,2)
    x(:,i) = exp(-d.sigma * (dot_a + dot_a(i) * unitvec - (2*x(:,i))).^0.5);
  end
else
  dot_a = sum(a.*a,1)';
  dot_b = sum(b.*b,1)';
  unitvec = ones(size(a,2),1);
  x = a' * b;
  
  for i=1:size(b,2)
    x(:,i) = exp(-d.sigma * (dot_a + dot_b(i) * unitvec - 2*x(:,i)).^0.5);
  end
end;



