function d = sparse_laplace(a)
%SPARSE_LAPLACE Pattern Recognition Optimizer
%
%  creates an optimizer object with all basic settings installed
%  (sigfig etc.)

% File:        @sparse_laplace/sparse_laplace.m
%
% Author:      Alex J. Smola
% Created:     11/05/98
% Modified:    
%
% This code is released under the GNU Public License
% Copyright by Telstra Research and The Australian National University

d.name      = 'sparse_laplace';		% name it
d.verbose = 0;				% by default we're quiet
%
if nargin == 0
  d.sigfig   = 3;			% stopping criterion for
                                        % relative quadratic extrapolation
  d.maxiter = 50;			% stop after 50 iterations

elseif (nargin == 1) & isa(a, 'char')
  token = read_token(a, 'sigfig');
  d.sigfig = str2num(token);
  token = read_token(a, 'maxiter');
  d.maxiter = str2num(token);
else
  error('wrong type of arguments');
end

d = class(d, 'sparse_laplace');		% make it a class
