function x = sv_dot(d, a, b)
%SV_DOT dot product for the RBF dot
%
%	X = SV_DOT(D, A, B) returns the <A,B> (for three
%	input arguments) or <A',A> (for two input arguments) where
%	D is the type of dot product used
%	
%	exp(-sigma * |x - y|^2)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @gauss_dot/sv_dot.m
%
% Author:      Alex Smola (fixed from Cheng)
% Created:     15-01-2003
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
    x(:,i) = exp(d.sigma * (2*x(:,i) - dot_a - dot_a(i) * unitvec));
  end
else
  dot_a = sum(a.*a,1)';
  dot_b = sum(b.*b,1)';
  unitvec = ones(size(a,2),1);
  x = a' * b;
  
  for i=1:size(b,2)
    x(:,i) = exp(d.sigma * (2*x(:,i) - dot_a - dot_b(i) * unitvec));
  end
end;



