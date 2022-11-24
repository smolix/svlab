function x = sv_mult(d, a, b, c)
%SV_MULT dot product for the RBF dot
%
%	X = SV_MULT(D, A, B, C) returns <A',B> * C (for four input arguments) 
%	X = SV_MULT(D, A, B)    returns <A',A> * B (for three inputs)
%	D is the type of dot product used
%
%	exp(-sigma * |x - y|)
%
%	see also SV_DOT, SV_MULT, SV_POL

% File:        @laplace_dot/sv_mult.m
%
% Author:      Alex J. Smola
% Created:     17/07/03
% Updated:    
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University
%

if (nargin ~= 3) & (nargin ~= 4)
  error('wrong number of arguments');
elseif nargin == 3
  num_dims = size(a,2);
  num_blocks = floor(num_dims / d.blocksize);
  num_features = size(b,2);
  x = zeros(num_dims,1);

  dot_a = sum(a .* a, 1);
  unitvec = ones(1,num_dims);
  blockvec = ones(d.blocksize,1);
  
  x = zeros(num_dims,num_features);

  lower_limit = 1;
  upper_limit = 0;

  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    x(lower_limit:upper_limit,:) = ...
	exp(-d.sigma * ...
	    (blockvec * dot_a + ...
	     dot_a(lower_limit:upper_limit)' * unitvec - ...
	     2 * a(:,lower_limit:upper_limit)' * a).^0.5) * b;
    lower_limit = upper_limit + 1;
  end;
  
  if (lower_limit <= num_dims)
    x(lower_limit:num_dims,:) = ...
	exp(-d.sigma * ...
	    (ones(num_dims-lower_limit+1,1) * dot_a + ...
	     dot_a(lower_limit:num_dims)' * unitvec - ...
	     2 * a(:,lower_limit:num_dims)' * a).^0.5) * b;
  end;
else
  num_dims = size(a,2);
  num_blocks = floor(num_dims / d.blocksize);
  num_features = size(c,2);
  x = zeros(num_dims,1);
  
  dot_a = sum(a.*a, 1);
  dot_b = sum(b.*b, 1);
  unitvec = ones(1,size(b,2));
  blockvec = ones(d.blocksize,1);
  
  x = zeros(num_dims,num_features);
  
  lower_limit = 1;
  upper_limit = 0;

  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    
    x(lower_limit:upper_limit,:) = ...
	exp(-d.sigma * ...
	    (blockvec * dot_b + ...
	     dot_a(lower_limit:upper_limit)' * unitvec - ...
	     2 * a(:,lower_limit:upper_limit)' * b).^0.5) * c;
    lower_limit = upper_limit + 1;
  end;
  if (lower_limit <= num_dims)
    x(lower_limit:num_dims,:) = ...
	exp(-d.sigma * ...
	    (ones(num_dims-lower_limit+1,1) * dot_b + ...
	     dot_a(lower_limit:num_dims)' * unitvec - ...
	     2 * a(:,lower_limit:num_dims)' * b).^0.5) * c;
  end;
end;


