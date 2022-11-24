function x = sv_mult(d, a, b, c)
%SV_MULT dot product for the BESSEL dot
%
%	X = SV_MULT(D, A, B, C) returns <A',B> * C (for four input arguments) 
%	X = SV_MULT(D, A, B)    returns <A',A> * B (for three inputs)
%	D is the type of dot product used
%
%	besseli(nu, -sigma * ||x - y||)
%
%	see also SV_DOT, SV_MULT, SV_POL

% File:        @bessel_dot/sv_mult.m
%
% Author:      Alexandros Karatzoglou, Alex J. Smola
% Created:     01/12/98
% Updated:     14/11/02
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University
%

nutemp = d.nu;
lim = 1/(gamma(nutemp+1)*2^nutemp);

if (nargin ~= 3) & (nargin ~= 4)
  error('wrong number of arguments');
  else
    nutemp = d.nu;
  if (d.nu == -1) 
    nutemp=round((size(a,1)-1)/2);
  end
  lim = 1/(gamma(nutemp + 1)*2^nutemp);
  
 if (nargin == 3)
  num_dims = size(a,2);
  num_blocks = floor(num_dims / d.blocksize);
  num_features = size(b,2);

  
  dot_a = sum(a.*a,1);
  unitvec = ones(1,num_dims);
  blockvec = ones(d.blocksize,1);
  
  x = zeros(num_dims,num_features);
  x1 = zeros(num_dims,num_dims);
  xx = zeros(num_dims,num_dims);
  lower_limit = 1;
  upper_limit = 0;

  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    
    xx = d.sigma * ((-2 * a(:,lower_limit:upper_limit)' * a + blockvec * dot_a + ...
                dot_a(lower_limit:upper_limit)' * unitvec).^0.5);
    x1(lower_limit:upper_limit,:) = besselj(nutemp+1, xx) .* xx.^-(nutemp+1);
    x1(find(xx<10e-5)) = lim;
    x(lower_limit:upper_limit,:) = (x1(lower_limit:upper_limit,:).^d.n) * b;  
    
    lower_limit = upper_limit + 1;

  end;
  if (lower_limit <= num_dims)
    xx = d.sigma * ((-2 * a(:,lower_limit:num_dims)' * a + ones(num_dims - lower_limit+1,1) * dot_a ...
                + dot_a(lower_limit:num_dims)' * unitvec).^0.5);
    x1(lower_limit:num_dims,:) = besselj(nutemp+1, xx) .* xx.^-(nutemp+1);
    x1(find(xx<10e-5)) = lim;
    x(lower_limit:num_dims,:) = (x1(lower_limit:num_dims,:).^d.n) * b;

  end;
 else

  num_dims = size(a,2);
  num_blocks = floor(num_dims / d.blocksize);
  num_features = size(c,2);
  
   dot_a = sum(a.*a,1);
   dot_b = sum(b.*b,1);

  unitvec = ones(1,size(b,2));
  blockvec = ones(d.blocksize,1);
  
  x = zeros(num_dims,num_features);
  x1 = zeros(num_dims,size(b,2));
  xx = zeros(num_dims,size(b,2));
  lower_limit = 1;
  upper_limit = 0;
  
  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    
    xx = d.sigma * ((-2 * a(:,lower_limit:upper_limit)' * b + blockvec * dot_b + ...
	     dot_a(lower_limit:upper_limit)' * unitvec).^0.5);
    x1(lower_limit:upper_limit,:) = besselj(nutemp+1, xx) .* xx.^-(nutemp+1);
    x1(find(xx<10e-5)) = lim; 
    x(lower_limit:upper_limit,:) =  (x1(lower_limit:upper_limit,:).^d.n) * c;
       
    lower_limit = upper_limit + 1;
  end;
  if (lower_limit <= num_dims)
    xx = d.sigma * ((-2 * a(:,lower_limit:num_dims)' * b + ones(num_dims-lower_limit+1,1) * dot_b + ...
	     dot_a(lower_limit:num_dims)' * unitvec).^0.5);
     
    x1(lower_limit:num_dims,:) = besselj(nutemp+1, xx) .* xx.^-(nutemp+1);
    x1(find(xx<10e-5)) = lim;
    x(lower_limit:num_dims,:) =  (x1(lower_limit:num_dims,:).^d.n) * c;
      
   end;
 end;
end;

