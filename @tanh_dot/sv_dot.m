function x = sv_dot(d, a, b)
%SV_DOT dot product for the TANH dot
%
%	X = SV_DOT(D, A, B) returns the scalar product of A and B (for three
%	input arguments) or of <A',A> (for two input arguments) where
%	D is the type of dot product used
%	
%       k(x, x') = tanh(scale * (x * x') + offset)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @tanh_dot/sv_dot.m
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
  x = tanh(d.scale * a' * a + d.offset);
else
  x = tanh(d.scale * a' * b + d.offset);
end;








