function d = vanilla_dot(a)
%VANILLA_DOT Basic template for the dot product class
%
%	d = vanilla_dot creates a basic template for the dot product class
%
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @vanilla_dot/vanilla_dot.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Modified:    05/08/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

d.name      = 'vanilla_dot';
if nargin == 0
  d.blocksize = 128;			% block size for sv_mult
elseif (nargin == 1) & isa(a, 'char')
  if (~isempty(findstr('=', a)))
    d = eval_hyper(a, d);
  else
    token = read_token(a, 'blocksize');
    d.blocksize = str2num(token);
  end;
elseif (nargin == 1) & isa(a, 'double')
  d.blocksize = a;
else
  error('wrong type of arguments');
end;
d = class(d, 'vanilla_dot');		% make it a class

