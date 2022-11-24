function d = laplace_dot(a, blocksize)
%RBF_DOT Rbfnomial dot product constructor
%
%	d = laplace_dot(sigma, blocksize) creates a rbf
%                                     dot product class
%       k(x, x') = exp(-sigma \|x - x'\|)
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @laplace_dot/laplace_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     08/05/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if (nargin > 2)
  error('Wrong number of arguments');
end;

d.name = 'laplace_dot';			% preset parameters
d.sigma  = 1;
d.blocksize = 128;			% have to redefine that
                                        % since matlab oo is
                                        % completely fscked up!

if ((nargin == 1) & isa(a, 'char'))	% we use the token format
  token = read_token(a, 'sigma')
  d.sigma = str2num(token);
else
  if (nargin > 0) 
    d.sigma = a;
  end;
end
d = class(d, 'laplace_dot', vanilla_dot);
superiorto('vanilla_dot');

