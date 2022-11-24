function d = gradient_descent(a)
%GRADIENT_DESCENT basic gradient descent algorithm
%                 both in RKSH and ALPHA space
%
%  creates a gradient descent object. possible values are
%
%  1 rkhs (rkhs regularizer)
%  2 alpha (coefficient space regularizer)

% File:        @regularizer/regularizer.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Modified:    
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

d.keywords = { ...
    'rkhs', ...
    'alpha', ...
	     };


d.type    = -1;				% default no valid input
defaulttype = 1;			% default l2loss;

% sane parameter settings
d.verbose = 0;				% by default we're quiet
d.precompute_k = 1;			% compute k beforehand
                                        % (small sample size only)
d.maxiter      = 1000;			% maximum number of
                                        % iterations
d.threshold    = 10^(-4);		% gradient threshold to
                                        % stop
%
if (nargin == 0)
  d.type = defaulttype;
elseif (nargin > 0)
  for i=1:length(d.keywords)
    if equal(a, char(d.keywords(i)))
      d.type = i;			
    end;
  end;
end;
if (d.type == -1)
  disp(['WARNING: wrong argument, using ', ...
	char(d.keywords(defaulttype)),' instead']);
  d.type = defaulttype;
end;  

d = class(d, 'gradient_descent');		% make it a class
