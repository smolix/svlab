function x = sv_dot(d, a, b)
%SV_DOT dot product for the BESSEL dot
%
%	X = SV_DOT(D, A, B) returns the <A,B> (for three
%	input arguments) or <A',A> (for two input arguments) where
%	D is the type of dot product used
%	
%	besseli(nu, -sigma * ||x - y||)
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @bessel_dot/sv_dot.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     21/10/00
% Updated:     14/11/02
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
else
  nutemp = d.nu;
  if (d.nu == -1)			% we are automatic
    nutemp=round((size(a,1)-1)/2);
  end
  lim = 1/(gamma(nutemp + 1)*2^nutemp);
   
  if nargin == 2
    dot_a = sum(a.*a,1); 
    unitvec = ones(size(a,2),1);
    x = a' * a;
    for i=1:size(a,2)
      xx = d.sigma * ((dot_a' + dot_a(i) * unitvec - 2 * x(:,i)).^0.5);
      x(:,i) = besselj((nutemp+1),xx).* (xx.^(-(nutemp+1)));
      x(find(xx< 10e-5),i) = lim;	% avoiding numerical
                                        % trouble close to zero
    end
  else
    dot_a = sum(a.*a,1);
    dot_b = sum(b.*b,1);
    
    unitvec = ones(size(a,2),1);
    x = a' * b;
    for i=1:size(b,2)
      xx = d.sigma * ((dot_a' + dot_b(i) * unitvec - 2 * x(:,i)).^0.5);
      x(:,i) = besselj((nutemp+1),xx) .* (xx.^(-(nutemp+1)));
      x(find(xx <10e-5),i) = lim;
    end
  end;
  x = (x/lim).^d.n;
end;  
  
