function x = sv_pol(kernel, a, b, c, d)
%SV_DOT Basic template for the Dot Product 
%
%	X = SV_MULT(D, X1, X2, Y1, Y2) returns the scalar product of X1 and X2 
%	multiplied componentwise with the polarities of Y1 and Y2, which
%	is a vector (for five input arguments) 
%	or of X1'*X1 with Y1 componentwise (for three input arguments)
%	where D is the type of dot product used
%
%	exp(-sigma * |x - y|)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @laplace_dot/sv_pol.m
%
% Author:      Alex J. Smola
% Created:     16/07/03
% Updated:     
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if (nargin ~= 3) & (nargin ~= 5)
  error('wrong number of arguments');
elseif nargin == 3
  dot_a = sum(a.*a,1);
  unitvec = ones(size(a,2),1);
  x = a' * a;
  for i=1:size(a,2)
    x(:,i) = b(i) * (exp(-kernel.sigma * (dot_a' + dot_a(i) * ...
				    unitvec - 2 * x(:,i)).^(0.5)) .* b);
  end
else
  dot_a = sum(a.*a,1);
  dot_b = sum(b.*b,1);
  unitvec = ones(size(a,2),1);
  x = a' * b;
  for i=1:size(b,2)
    x(:,i) = d(i) * (exp(-kernel.sigma * (dot_a' + dot_b(i) * ...
					 unitvec - 2 * x(:,i)).^(0.5)) .* c);
  end
end;





