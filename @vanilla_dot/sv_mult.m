function x = sv_mult(d, a, b, c)
%DOT Basic template for the Dot Product 
%
%	X = SV_MULT(D, A, B, C) returns A' * B * C (for four input arguments) 
%	X = SV_MULT(D, A, B)    returns A' * A * B (for three inputs)
%	D is the type of dot product used
%
%	see also SV_DOT, SV_MULT, SV_POL

% File:        @vanilla_dot/sv_mult.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     05/08/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin ~= 3) & (nargin ~= 4)
  error('wrong number of arguments');
elseif nargin == 3
  x = ((a * b)' * a)';			% much faster since it
                                        % avoids transposing a
else
  x = ((b * c)' * a)';
end;

