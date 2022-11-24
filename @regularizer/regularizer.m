function d = regularizer(a)
%REGULARIZER Regularization Term in the gradient descent functional
%
%  creates a regularizer term with gradient and value
%  possible values are
%
%  rkhs_normsquare_rkhs
%  rkhs_normsquare_alpha
%  rkhs_norm_rkhs
%  rkhs_norm_alpha
%  ell1_alpha
%  ell2_alpha

% File:        @regularizer/regularizer.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Modified:    
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

d.keywords = { ...
    'rkhs_normsquare_rkhs' ...
    'rkhs_normsquare_alpha' ...
    'rkhs_norm_rkhs' ...
    'rkhs_norm_alpha' ...
    'ell1_alpha' ...
    'ell2_alpha' ...
	     };

d.verbose = 0;				% by default we're quiet
d.type    = -1;				% default no valid input
%
if (nargin == 0)
  d.type = 1;				% default rkhs_normsquare_rkhs
elseif (nargin == 1)
  for i=1:length(d.keywords)
    if equal(a, char(d.keywords(i)))
      d.type = i;			
    end;
  end;
end;
if (d.type == -1)
  disp(['WARNING: wrong argument, using ', char(d.keywords(1)),' instead']);
  d.type = 1;
end;  

d = class(d, 'regularizer');		% make it a class







