function x = sv_pol(d, x1, x2, y1, y2)
%SV_DOT Basic template for the Dot Product 
%
%	X = SV_POL(D, X1, X2, Y1, Y2) returns the scalar product of X1 and X2 
%	multiplied componentwise with the polarities of Y1 and Y2, which
%	is a vector (for five input arguments) 
%	or of X1'*X1 with Y1 componentwise (for three input arguments)
%	where D is the type of dot product used
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @vanilla_dot/sv_pol.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     05/08/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin ~= 3) & (nargin ~= 5)
  error('wrong number of arguments');
elseif nargin == 3
  x = x1' * x1;
  for i=1:size(x1,2)
    x(:,i) = x2(i) * (x(:,i) .* x2);
  end
else
  x = x1' * x2;
  for i=1:size(x2,2)
    x(:,i) = y2(i) * (x(:,i) .* y1);
  end
end;

