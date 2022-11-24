function x = display(d)
%DISPLAY Basic template for the kfa object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @kfa/display.m
%
% Author:      Ben O'Loghlin
% Created:     05/10/00
% Updated:     05/10/00
%
% This code is released under the GNU Public License
% Copyright The Australian National University

if nargout == 0
  disp(['Kernel :']); 
 d.kernel
disp(sprintf(' '));
  tmp = sprintf(['KFA Object :\n' ...
		 'features\t: %d\n' ...		 
		 'SubsetSize \t: %d\n' ...
		 'Normalized \t: %d\n' ...
		 'Verbosity  \t: %d\n' ...
		 'Sigfig     \t: %d\n'] ...
		  ,d.features ,d.subsetsize,d.normalized, ...
		 d.verbose ,d.sigfig);
		  
  disp(tmp);
else
  x = sprintf( ...
	'%s_sigfig_%d_numfeatures_%d_subsetsize_%d_normalized%d_p%d', ...
	      d.name, d.sigfig, d.numfeatures, d.subsetsize, ...
              d.normalized, d.p);
end
