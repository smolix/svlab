function x = display(d)
%DISPLAY Basic template for the Dot Product display routine
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @laplace_dot/display.m
%
% Author:      Alex J. Smola
% Created:     17/07/03
% Updated:    
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if nargout == 0
  tmp = sprintf(['Dot product\n' ...
		 'Type       \t: %s\n' ...
		 'Block size \t: %d\n' ...
		 'Sigma      \t: '], ...
		d.name, d.blocksize);
  disp(tmp);
  disp(d.sigma);
  d.blocksize;
else
  x = sprintf('%s_blocksize_%d_sigma_%d', ...
	      d.name, d.blocksize, d.sigma);
end
