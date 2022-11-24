function x = sv_dot(d, a, b)
%SV_DOT dot product for the POLY dot
%
%	X = SV_DOT(D, A, B) returns the scalar product of A and B (for three
%	input arguments) or of <A',A> (for two input arguments) where
%	D is the type of dot product used
%	
%       k(x, x') = (scale * (x * x') + offset)^degree
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @poly_dot/sv_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     08/05/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
elseif nargin == 2
  x = (d.scale * a' * a + d.offset).^d.degree;
else
  x = (d.scale * a' * b + d.offset).^d.degree;
end;








