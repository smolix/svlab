function x = display(d)
%DISPLAY Basic template for the Dot Product display routine
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @sparse_laplace/display.m
%
% Author:      Alex J. Smola
% Created:     11/05/11
% Updated:
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if nargout == 0
  tmp = sprintf(['Optimizer\n' ...
		 'Type       \t: %s\n' ...
		 'SigFig     \t: %d\n' ...
		 'MaxIter    \t: %d\n'], ...
		d.name, d.sigfig, d.maxiter);
  disp(tmp);
else
  x = sprintf('%s_sigfig_%d_maxiter_%d', ...
	      d.name, d.sigfig, d.maxiter);
end

