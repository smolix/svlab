function x = sv_dot(kernel, a, b, dot_a)
%SV_DOT_FAST dot product for the BESSEL dot
%
%	X = SV_DOT_FAST(kernel, A, B, DOT_A) returns the <A,B> (for three
%	input arguments) or where kernel is the type of dot product used
%	We compute 
%	besseli(nu, -sigma * ||x - y||)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @bessel_dot/sv_dot.m
%
% Author:      Alexandros Karatzoglou, Alex J. Smola
% Created:     12/02/04
% Updated:     12/02/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if (nargin ~= 4) 
  error('wrong number of arguments');
else
  nutemp = kernel.nu;
  if (kernel.nu == -1)			% we are automatic
    nutemp=round((size(a,1)-1)/2);
  end
  lim = 1/(gamma(nutemp + 1)*2^nutemp);
   
  dot_b = sum(b.*b,1);
    
    unitvec = ones(size(a,2),1);
    x = a' * b;
    for i=1:size(b,2)
      xx = kernel.sigma * ((dot_a' + dot_b(i) * unitvec - 2 * x(:,i)).^0.5);
      x(:,i) = besselj((nutemp+1),xx) .* (xx.^(-(nutemp+1)));
      x(find(xx <10e-5),i) = lim;
    end
  end;
  x = (x/lim).^kernel.n;
end;  
  
