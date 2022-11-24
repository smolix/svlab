function d = bessel_dot(a, nu ,n ,blocksize)
%BESSEL_DOT Besselnomial dot product constructor
%
%	d = bessel_dot(sigma, nu,n, blocksize) creates a bessel
%                                     dot product class
%       k(x, x') = besseli(nu, sigma \|x - x'\|^2)
%	see also DISPLAY, SV_DOT, SV_MULT, SV_POL

% File:        @bessel_dot/bessel_dot.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     21/10/00
% Updated:     26/11/02
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if (nargin > 4)
  error('Wrong number of arguments');
end;

d.name = 'bessel_dot';			% preset parameters
d.sigma  = 1;
d.blocksize = 128;			% have to redefine that
d.n = 2;                                % since matlab oo is
                                        % completely fscked up!
d.nu = -1;				% order of the bessel function is computed inside sv_*.m 
                                        % d.nu=(size(x,1)-1)/2

					
					
if ((nargin == 1) & isa(a, 'char'))     % we use the token or
                                        % equality format
  if (~isempty(findstr('=', a)))
    d = eval_hyper(a, d);
  else
    token = read_token(a, 'sigma');
    d.sigma = str2num(token);
    token = read_token(a,'nu');
    d.nu = str2num(token);
    token = read_token(a,'n');
    d.n = str2num(token); 
  end;
elseif (nargin == 1) & isa(a, 'double')
  d.blocksize = a;

else
  if (nargin > 0) 
    d.sigma = a;
    d.nu    = nu;
    d.blocksize = blocksize;
    d.n = n;
  end;
end;
d = class(d, 'bessel_dot', vanilla_dot);
superiorto('vanilla_dot');









