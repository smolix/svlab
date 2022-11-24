function d = tanh_dot(a, scale, blocksize)
%TANH_DOT Tanhnomial dot product constructor
%
%	d = tanh_dot(offset, scale, blocksize) creates a tanhnomial
%	                                    dot product class
%       k(x, x') = tanh(scale * (x * x') + offset)
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @tanh_dot/tanh_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     08/05/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin > 3)
  error('Wrong number of arguments');
end;

d.name = 'tanh_dot';			% preset parameters
d.offset = 1;
d.scale  = 1;
d.blocksize = 128;			% have to redefine that
                                        % since matlab oo is
                                        % completely fscked up!

if ((nargin == 1) & isa(a, 'char'))	% we use the token format
  token = read_token(a, 'offset');
  d.offset = str2num(token);
  token = read_token(a, 'scale');
  d.scale = str2num(token);
else
  if (nargin > 0) 
    d.offset = a;
  end;
  if (nargin > 1) 
    d.scale = scale;
  end;
  if (nargin > 2) 
    d.blocksize = blocksize;
  end;
end
d = class(d, 'tanh_dot', vanilla_dot);
superiorto('vanilla_dot');







