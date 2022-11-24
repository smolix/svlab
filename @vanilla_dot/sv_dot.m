function x = sv_dot(d, a, b)
%SV_DOT Basic template for the Dot Product 
%
%	X = SV_DOT(D, A, B) returns the scalar product of A and B (for three
%	input arguments) or of A'*A (for two input arguments) where
%	D is the type of dot product used
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @vanilla_dot/sv_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     05/08/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
elseif nargin == 2
  x = a' * a;
else
  x = a' * b;
end;

