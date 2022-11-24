function x = sv_pol(kernel, a, b, c, d)
%SV_DOT Basic template for the Dot Product 
%
%	X = SV_MULT(D, X1, X2, Y1, Y2) returns the scalar product of X1 and X2 
%	multiplied componentwise with the polarities of Y1 and Y2, which
%	is a vector (for five input arguments) 
%	or of X1'*X1 with Y1 componentwise (for three input arguments)
%	where D is the type of dot product used
%
%	besseli(nu, -sigma * ||x - y||)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @bessel_dot/sv_pol.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     21/10/00
% Updated:     14/11/02
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if (nargin ~= 3) & (nargin ~= 5)
  error('wrong number of arguments');
else
  nutemp = kernel.nu;
 if (kernel.nu == -1) 
    nutemp=round((size(a,1)-1)/2);
 end
  lim = 1/(gamma(nutemp+1)*2^nutemp);
 if (nargin == 3)
  dot_a = sum(a.*a,1);
  unitvec = ones(size(a,2),1);
  x = a' * a;
  for i=1:size(a,2)
    xx = kernel.sigma * ((-2 * x(:,i) + dot_a' + dot_a(i) * unitvec).^0.5);
    x(:,i) = besselj(nutemp+1, xx).* (xx.^-(nutemp+1));
    x(find(xx < 10e-5),) = lim;
    x(:,i) = b(i)*(x(:,i).^kernel.n).*b;
  end
 else
   dot_a = sum(a.*a,1);
   dot_b = sum(b.*b,1);
   unitvec = ones(size(a,2),1);
   x = a' * b;
  for i=1:size(b,2)
   xx = kernel.sigma * ((-2 * x(:,i) + dot_a' + dot_b(i) * unitvec).^0.5);
   x(:,i) = besselj(nutemp+1, xx) .* (xx.^-(nutemp+1));
   x(find(xx < 10e-5),) = lim;
   x = b(i) * (x(:,i)^kernel.n).* c;
   end
 end;
end;




