function d = loss(a, scale)
%LOSS Loss Term in the gradient descent functional
%
%  creates a loss term with gradient and value
%  possible values are
%
%  1 l1loss
%  2 l2loss
%  3 softmargin
%  4 epsinsens
%  5 logistic
%  6 boosting
%  7 marron

% File:        @regularizer/regularizer.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Modified:    
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

d.keywords = { ...
    'l1loss', ...
    'l2loss', ...
    'softmargin', ...
    'epsinsens', ...
    'logistic', ...
    'boosting', ...
    'marron', ...
	     };

defaulttype = 2;			% default l2loss;

d.verbose = 0;				% by default we're quiet
d.type    = -1;				% default no valid input
d.scale   = 1;				% scale parameter for eps
                                        % and huber
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

% special treatment for special losses
if ((d.type == 3) & (nargin > 1))	% softmargin
  d.scale = scale;
end;
if ((d.type == 4) & (nargin > 1))	% eps insensitive
  d.scale = scale;
end;

d = class(d, 'loss');		% make it a class
