function x = display(d)
%DISPLAY Basic template for the optimizer routines of the kpca family
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @kpca/display.m
%
% Author:      Alex J. Smola / Ben O'Loghlin
% Created:     01/18/98
% Updated:     05/08/00
%
% This code is released under the GNU Public License
% Copyright The Australian National University

if nargout == 0
  tmp = sprintf(['KPCA Optimizer\n' ...
		 'Verbosity  \t: %d\n' ...
		 'Numfeatures\t: %d'], ...
		d.verbose, d.numfeatures);
  disp(tmp);
else
  x = sprintf('numfeatures_%d', ...
	      d.numfeatures);
end
