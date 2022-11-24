function d = poly_dot(a, offset, scale, blocksize)
%POLY_DOT Polynomial dot product constructor
%
%	d = poly_dot(degree, offset, scale, blocksize) creates a polynomial
%	                                    dot product class
%       k(x, x') = (scale * (x * x') + offset)^degree
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @poly_dot/poly_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     08/05/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin > 4)
  error('Wrong number of arguments');
end;

d.name = 'poly_dot';			% preset parameters
d.degree = 1;
d.offset = 1;
d.scale  = 1;
d.blocksize = 128;			% have to redefine that
                                        % since matlab oo is
                                        % completely fscked up!

if ((nargin == 1) & isa(a, 'char'))	% we use the token format
  token = read_token(a, 'degree');
  d.degree = str2num(token);
  token = read_token(a, 'offset');
  d.offset = str2num(token);
  token = read_token(a, 'scale');
  d.scale = str2num(token);
else
  if (nargin > 0) 
    d.degree = a;
  end;
  if (nargin > 1) 
    d.offset = offset;
  end;
  if (nargin > 2) 
    d.scale = scale;
  end;
  if (nargin > 3) 
    d.blocksize = blocksize;
  end;
end
d = class(d, 'poly_dot', vanilla_dot);
superiorto('vanilla_dot');







