function x = sv_mult(d, a, b, c)
%SV_MULT dot product for the TANH dot
%
%	X = SV_MULT(D, A, B, C) returns <A',B> * C (for four input arguments) 
%	X = SV_MULT(D, A, B)    returns <A',A> * B (for three inputs)
%	D is the type of dot product used
%
%	see also SV_DOT, SV_MULT, SV_POL

% File:        @tanh_dot/sv_mult.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     05/08/00
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

  lower_limit = 1;
  upper_limit = 0;
  
  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    x(lower_limit:upper_limit,:) = ...
	tanh(d.scale * a(:,lower_limit:upper_limit)' * a + d.offset) * b;
    lower_limit = upper_limit + 1;
  end;
  if (lower_limit <= num_dims)
    x(lower_limit:num_dims,:) = ...
	tanh(d.scale * a(:,lower_limit:num_dims)' * a + d.offset) * b;
  end;
else
  num_dims = size(a,2);
  num_blocks = floor(num_dims / d.blocksize);
  num_features = size(c,2);
  x = zeros(num_dims,1);
  
  lower_limit = 1;
  upper_limit = 0;
  
  for i = 1:num_blocks
    upper_limit = upper_limit + d.blocksize;
    x(lower_limit:upper_limit,:) = ...
	tanh(d.scale * a(:,lower_limit:upper_limit)' * b + d.offset) * c;
    lower_limit = upper_limit + 1;
  end;
  if (lower_limit <= num_dims)
    x(lower_limit:num_dims,:) = ...
	tanh(d.scale * a(:,lower_limit:num_dims)' * b + d.offset) * c;
  end;
end;


