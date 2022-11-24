function x = display(d)
%DISPLAY Basic template for the sgma object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @sgma/display.m
%
% Author:      Ben O'Loghlin
% Created:     05/10/00
% Updated:     05/10/00
%
% This code is released under the GNU Public License
% Copyright The Australian National University

if nargout == 0
  tmp = sprintf(['SGMA Object\n' ...
		 'Type       \t: %s\n' ...
		 'Verbosity  \t: %d\n' ...
		 'Sigfig     \t: %d\n' ...
		 'Maxiter    \t: %d\n' ...
		 'SubsetSize \t: %d\n' ...
		 'ErrorBound \t: %d\n' ...
		 'BlockSize  \t: %d'], ...
		d.name, d.verbose, d.sigfig, ...
		d.maxiter, d.subsetsize, d.errorbound, d.blocksize);
  disp(tmp);
else
  x = sprintf( ...
	'%s_sigfig_%d_maxiter_%d_subsetsize_%d_errorbound_%d_blocksize_%d', ...
	      d.name, d.sigfig, d.maxiter, d.subsetsize, d.errorbound, d.blocksize);
end