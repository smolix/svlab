function x = display(d)
%DISPLAY Basic template for the Dot Product display routine
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @poly_dot/display.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     05/08/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if nargout == 0
  tmp = sprintf(['Dot product\n' ...
		 'Type       \t: %s\n' ...
		 'Block size \t: %d\n' ...
		 'Degree     \t: %d\n' ...
		 'Offset     \t: %d\n' ...
		 'Scale      \t: %d'], ...
		d.name, d.blocksize, d.degree, d.offset, d.scale);
  disp(tmp);
  d.blocksize;
else
  x = sprintf('%s_blocksize_%d_degree_%d_offset_%d_scale_%d', ...
	      d.name, d.blocksize, d.degree, d.offset, d.scale);
end

